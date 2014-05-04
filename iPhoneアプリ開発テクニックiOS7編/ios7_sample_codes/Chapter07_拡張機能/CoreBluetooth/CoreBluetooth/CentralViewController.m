//
//  CentralViewController.m
//  CoreBluetooth
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "CentralViewController.h"
@import CoreBluetooth;

@interface CentralViewController ()
<CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation CentralViewController {
    IBOutlet __weak UITextView *messageView;
    CBCentralManager *centralManager;
    CBUUID *sUUID;

    CBPeripheral *cbPeripheral;
    CBCharacteristic *cbCharacteristic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    sUUID = [CBUUID UUIDWithString:@"4BDFC11D-44A5-4399-9481-41D3F97D96A9"];  // 1.
    centralManager = [[CBCentralManager alloc]
                      initWithDelegate:self
                      queue:nil
                      options:
                      @{CBCentralManagerOptionRestoreIdentifierKey:@"i7CBC"}];  // ★ 2.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:1 forKey:@"ViewControllerIndex"];
    [defs synchronize];

    NSLog(@"Central");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData*)currentData:(NSString*)head {
    NSString *str = [NSString stringWithFormat:@"%@ %@",
                     head, [[NSDate date] description]];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)updateMessage:(NSString*)msg {
    static NSMutableArray *lines = nil;
    if (!lines) lines = @[].mutableCopy;

    [lines insertObject:msg atIndex:0];
    while (lines.count > 30)
        [lines removeLastObject];
    NSString *str = [lines componentsJoinedByString:@"\n"];
    dispatch_async(dispatch_get_main_queue(), ^{
        messageView.text = str;
    });
}

- (IBAction)writeButtonPressed:(id)sender {
    [cbPeripheral writeValue:[self currentData:@"w:"]
           forCharacteristic:cbCharacteristic
                        type:CBCharacteristicWriteWithResponse];
}

- (IBAction)readButtonPressed:(id)sender {
    [cbPeripheral readValueForCharacteristic:cbCharacteristic];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state {
    NSLog(@"willRestoreState:");
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    if (peripherals.count) {
        cbPeripheral = peripherals[0];
        cbPeripheral.delegate = self;
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"didUpdateState");
    if (central.state == CBCentralManagerStatePoweredOn) {
        if (!cbPeripheral ||
            cbPeripheral.state != CBPeripheralStateConnected) {
            [centralManager scanForPeripheralsWithServices:@[sUUID]
                                                   options:
             @{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];  // 1.
        } else {
            CBService *found_service = nil;
            for (CBService *service in cbPeripheral.services)
                if ([service.UUID isEqual:sUUID]) found_service = service;
            if (!found_service) {
                [cbPeripheral discoverServices:@[sUUID]];  // 2.
            } else {
                if (!found_service.characteristics.count) {
                    [cbPeripheral discoverCharacteristics:nil
                                               forService:found_service];  // 3.
                } else {
                    cbCharacteristic = found_service.characteristics[0];
                    [cbPeripheral setNotifyValue:YES
                               forCharacteristic:cbCharacteristic];  // 4.
                }
            }
        }
    } else {
        NSLog(@"state %d", (int)central.state);
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    NSLog(@"didDiscoverPeripheral");
    NSArray *services =
    advertisementData[CBAdvertisementDataServiceUUIDsKey];  // 1.
    NSArray *bg_services =
    advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey]; // 2.

    if (([services containsObject:sUUID] ||
         [bg_services containsObject:sUUID])
        && !cbPeripheral) {
        cbPeripheral = peripheral;  // 3.
        [central connectPeripheral:peripheral options:nil];  // 4.
    }
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"didConnectPeripheral");
    peripheral.delegate = self;
    [peripheral discoverServices:@[sUUID]];
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    NSLog(@"didRetrieveConnectedPeripherals");
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"didRetrievePeripherals");
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didFailToConnectPeripheral");
    cbPeripheral = nil;
    cbCharacteristic = nil;
    [central scanForPeripheralsWithServices:@[sUUID]
                                    options:
     @{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral %@ error %@", peripheral.description, error);
    centralManager.delegate = nil;
    centralManager = nil;
    cbPeripheral = nil;
    cbCharacteristic = nil;
    centralManager = [[CBCentralManager alloc]
                      initWithDelegate:self
                      queue:dispatch_get_global_queue(0, 0)
                      options:
                      @{CBCentralManagerOptionShowPowerAlertKey:@YES,
                        CBCentralManagerOptionRestoreIdentifierKey:@"i7CBC"}];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error {
    NSArray *services = peripheral.services;
    NSLog(@"services count %lu, %@", (unsigned long)services.count, error);
    for (CBService *service in services)
        if ([service.UUID isEqual:sUUID])
            [peripheral discoverCharacteristics:nil forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    for (CBCharacteristic *cbchar in service.characteristics) {
        NSLog(@"subscribe to service %@, char:%@", service.UUID, cbchar.UUID);
        [peripheral setNotifyValue:YES forCharacteristic:cbchar];  // 1.
        cbCharacteristic = cbchar;  // 2.
    }
}

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"updatevalue service:%@ char:%@ request value:%@", characteristic.service.UUID,
          characteristic.UUID, characteristic.value);
    NSString *msg = [[NSString alloc]
                     initWithData:characteristic.value  // 1.
                     encoding:NSUTF8StringEncoding];
    [self updateMessage:msg];  // 2.
}

@end
