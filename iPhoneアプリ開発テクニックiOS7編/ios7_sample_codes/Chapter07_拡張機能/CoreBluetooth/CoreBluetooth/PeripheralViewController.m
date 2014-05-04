//
//  PeripheralViewController.m
//  CoreBluetooth
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "PeripheralViewController.h"

@import CoreBluetooth;

@interface PeripheralViewController () <CBPeripheralManagerDelegate>

@end

@implementation PeripheralViewController {
    IBOutlet __weak UITextView *messageView;
    CBPeripheralManager *peripheralManager;
    CBUUID *sUUID, *cUUID;

    CBService *transferService;
    CBMutableCharacteristic *transferCharacteristic;

    CBCharacteristic *cbCharacteristic;
    CBCentral *cbCentral;
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

    peripheralManager =
    [[CBPeripheralManager alloc]
     initWithDelegate:self
     queue:nil
     options:@{CBPeripheralManagerOptionShowPowerAlertKey:@YES,
               CBPeripheralManagerOptionRestoreIdentifierKey:@"iOS7CBP"}];

    sUUID = [CBUUID UUIDWithString:@"4BDFC11D-44A5-4399-9481-41D3F97D96A9"];
    cUUID = [CBUUID UUIDWithString:@"B8F92777-0ADF-42BD-BCF3-605C95B3403C"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setInteger:0 forKey:@"ViewControllerIndex"];
    [defs synchronize];

    NSLog(@"Peripheral");
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

- (IBAction)notifyButtonPressed:(id)sender {
    [peripheralManager updateValue:[self currentData:@"u:"]
                 forCharacteristic:transferCharacteristic
              onSubscribedCentrals:nil];
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

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:
(NSDictionary *)dict {
    NSLog(@"peripheralManager:willRestoreState:");
    NSArray *services = dict[CBPeripheralManagerRestoredStateServicesKey];
    if (services.count) {
        transferService = services[0];
        NSArray *chs = [services[0] characteristics];
        if (chs.count)
            transferCharacteristic = chs[0];
    }
    NSDictionary *advdat =
    dict[CBPeripheralManagerRestoredStateAdvertisementDataKey];
    if (advdat)
        [peripheral startAdvertising:advdat];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"update state");
    if (peripheral.state == CBPeripheralManagerStatePoweredOn && transferService == nil) {  // 1.
        CBMutableCharacteristic *c =
        [[CBMutableCharacteristic alloc]
         initWithType:cUUID
         properties:
         (CBCharacteristicPropertyNotify|
          CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite)
         value:nil
         permissions:
         (CBAttributePermissionsReadable|CBAttributePermissionsWriteable)]; // 2.
        transferCharacteristic = c;  // 3.
        CBMutableService *s = [[CBMutableService alloc]
                               initWithType:sUUID primary:YES];  // .4
        s.characteristics = @[c];  // 5.
        transferService = s;
        [peripheral addService:s];  // 6.
    } else {
        NSLog(@"%i", (int)peripheral.state);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    NSLog(@"didAddService");
    if (![service.UUID isEqual:sUUID]) return;

    NSDictionary *advertising_data =
    @{CBAdvertisementDataLocalNameKey : @"iOS7Test",
      CBAdvertisementDataServiceUUIDsKey : @[sUUID]};  // 1.
    [peripheral startAdvertising:advertising_data];  // 2.
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheralManagerDidStartAdvertising peripheral %@", peripheralManager);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"didReceiveReadRequest");
    request.value = [self currentData:@"r:"];
    [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
  didReceiveWriteRequests:(NSArray *)requests {
    NSLog(@"didReceiveWriteRequests");
    for (CBATTRequest *req in requests) {
        NSString *msg =
        [[NSString alloc] initWithData:req.value
                              encoding:NSUTF8StringEncoding];
        NSLog(@"received data %@", msg);
        [self updateMessage:msg];
        [peripheral respondToRequest:req withResult:CBATTErrorSuccess];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"Connected %@", characteristic.UUID);
    peripheralManager = peripheral;
    peripheralManager.delegate = self;
    cbCentral = central;
    cbCharacteristic = characteristic;
    [self updateMessage:@"connected"];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"didUnscribeFromCharacteristic");

    peripheralManager.delegate = nil;
    peripheral = nil;
    peripheralManager = nil;
    peripheralManager =
    [[CBPeripheralManager alloc]
     initWithDelegate:self
     queue:dispatch_get_global_queue(0, 0)
     options:@{CBPeripheralManagerOptionShowPowerAlertKey:@YES,
               CBPeripheralManagerOptionRestoreIdentifierKey:[[NSDate date] description]}];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"isReadyToUpdateSubscribers");
}

@end
