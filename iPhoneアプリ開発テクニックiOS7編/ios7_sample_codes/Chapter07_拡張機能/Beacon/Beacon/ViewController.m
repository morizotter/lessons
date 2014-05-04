//
//  ViewController.m
//  Beacon
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"
@import CoreBluetooth;
@import CoreLocation;

NSString *UUIDString = @"080BC44C-AD1D-4E33-B135-DD3EC9CEA229";

@interface ViewController ()

@end

@implementation ViewController {
    CBPeripheralManager *peripheralManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    peripheralManager =
    [[CBPeripheralManager alloc] initWithDelegate:nil queue:nil];  // 1.
    NSUUID *uuid = [[NSUUID alloc]
                    initWithUUIDString:UUIDString];  // 2.
    CLBeaconRegion *beaconRegion =
    [[CLBeaconRegion alloc]
     initWithProximityUUID:uuid
     major:1 minor:0
     identifier:@"iOS7BeaconTest"];  // 3.
    NSMutableDictionary *beaconData =
    [beaconRegion peripheralDataWithMeasuredPower:nil];  // 4.
    [peripheralManager startAdvertising:beaconData];  // 5.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
