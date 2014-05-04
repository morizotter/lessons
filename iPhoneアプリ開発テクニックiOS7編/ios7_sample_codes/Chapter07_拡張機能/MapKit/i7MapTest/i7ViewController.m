//
//  i7ViewController.m
//  i7MapTest
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

@import MapKit;
#import "i7ViewController.h"
#import "I7OverlayRenderer.h"
#import "i7Overlay.h"

NSString *UUIDString = @"080BC44C-AD1D-4E33-B135-DD3EC9CEA229";
NSString *Identifier = @"Test Place";
NSString *TileURLString;

@interface i7ViewController ()
<MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation i7ViewController {
    __weak IBOutlet MKMapView *mapView;

    CLLocationCoordinate2D mapCenterCoordinate;
    MKMapCamera *camera_init;
    CLLocationManager *locationManager;

    __weak IBOutlet UISlider *cameraX;
    __weak IBOutlet UISlider *cameraY;
    __weak IBOutlet UISlider *cameraZ;
    __weak IBOutlet UITextField *beaconField;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    mapView.delegate = self;
    mapCenterCoordinate = CLLocationCoordinate2DMake(35.11, 136.55);

    camera_init = [MKMapCamera cameraLookingAtCenterCoordinate:mapCenterCoordinate
                                             fromEyeCoordinate:CLLocationCoordinate2DMake(35.05, 136.55)
                                                   eyeAltitude:100];
    mapView.camera = camera_init;

    TileURLString = [[[NSBundle mainBundle]
                      URLForResource:@"screen" withExtension:@"png"]
                     absoluteString];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self startListenBeacon];
}


- (void)startListenBeacon {
    NSUUID *uuid = [[NSUUID alloc]
                    initWithUUIDString:UUIDString];
    CLBeaconRegion *beaconRegion =
    [[CLBeaconRegion alloc]
     initWithProximityUUID:uuid identifier:@"test"];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (IBAction)slidersValueChanged:(id)sender {
    MKMapCamera *camera = camera_init.copy;
    camera.heading = cameraX.value * 360 - 180;
    camera.pitch = cameraY.value * 70;
    camera.altitude = cameraZ.value * 10000 + 10;
    camera.centerCoordinate = mapView.camera.centerCoordinate;
    mapView.camera = camera;
}

- (IBAction)directionButtonPressed:(id)sender {
    MKDirectionsRequest *req = [[MKDirectionsRequest alloc] init];
    req.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *dplace = [[MKPlacemark alloc]
                           initWithCoordinate:mapView.camera.centerCoordinate
                           addressDictionary:nil];
    req.destination = [[MKMapItem alloc] initWithPlacemark:dplace];
    MKDirections *dir = [[MKDirections alloc]
                         initWithRequest:req];
    [dir calculateDirectionsWithCompletionHandler: // 5.
     ^(MKDirectionsResponse *resp, NSError *err) {
         if (err) {
             [[[UIAlertView alloc]
               initWithTitle:@"no route"
               message:[NSString stringWithFormat:@"%@", err]
               delegate:nil
               cancelButtonTitle:nil otherButtonTitles:@"OK", nil]
              show];
         } else if (resp.routes.count) {
             MKPolyline *pline = ((MKRoute*)resp.routes[0]).polyline;
             [mapView addOverlay:pline];
         }
     }];
}

- (IBAction)overlaySelected:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    switch (seg.selectedSegmentIndex) {
        case 0: // None
            [mapView removeOverlays:mapView.overlays];
            break;
        case 1: // Tile
        {
            NSString *tilestr = [[[NSBundle mainBundle]
                                  URLForResource:@"screen" withExtension:@"png"]
                                 absoluteString];
            MKTileOverlay *tile = [[MKTileOverlay alloc]
                                   initWithURLTemplate:tilestr];
            [mapView addOverlay:tile];
        }
            break;
        case 2: // Raw
            [mapView addOverlay:[[i7Overlay alloc] init]];
            break;
    }
}

- (IBAction)higherButtonPressed:(id)sender {
    MKMapCamera *camera = mapView.camera;
    camera.altitude += 100;
    camera.heading += 15;
    [mapView setCamera:camera animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer*)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *render =
        [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        render.strokeColor = UIColor.redColor;
        render.lineWidth = 5;
        return render;
    } else if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        MKTileOverlayRenderer *render =
        [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return render;
    } else if ([overlay isKindOfClass:[i7Overlay class]]) {
        I7OverlayRenderer *render = [[I7OverlayRenderer alloc] initWithOverlay:overlay];
        [render setNeedsDisplay];
        return render;
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    for (CLBeacon *b in beacons) {
        NSLog(@"proximity %d acuuracy %f rssi %d", b.proximity, b.accuracy, b.rssi);
        beaconField.text = [NSString stringWithFormat:@"p:%d a:%f r:%d",
                            b.proximity, b.accuracy, b.rssi];
    }
}

@end
