//
//  ViewController.m
//  MCStepper
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"
#import "MyScene.h"
#import "AppDelegate.h"
@import CoreMotion;
@import AudioToolbox;

@interface ViewController () <MCBrowserViewControllerDelegate, MultiPeerStepperDelegate>
@property MyScene *myScene;

// 加速度計
@property (strong, nonatomic) CMMotionManager *cmManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.stepDelegate = self;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.stepDelegate = self;
    self.myScene = scene;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated;
{
    self.cmManager = [[CMMotionManager alloc] init];
    self.cmManager.accelerometerUpdateInterval = 0.3f;
    [self.cmManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        SKView * skView = (SKView *)self.view;
        skView.scene.physicsWorld.gravity = CGVectorMake(accelerometerData.acceleration.x * 9.8f, accelerometerData.acceleration.y * 9.8f);
    }];
}


#pragma mark - IBAction
// Multipeer Connectivityで接続先を見つけるUIを表示する
- (IBAction)connectAction:(id)sender {
    NSLog(@"-connectAction:");
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:appDelegate.serviceType session:appDelegate.session];
	browserViewController.delegate = self;
    browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    browserViewController.maximumNumberOfPeers = kMCSessionMaximumNumberOfPeers;
    [self presentViewController:browserViewController animated:YES completion:NULL];
}

#pragma mark - MCBrowserViewControllerDelegate
// 完了したのでviewを隠す
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController;
{
    NSLog(@"browserViewControllerDidFinish:%@", browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

// キャンセルされたのでviewを隠す
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController;
{
    NSLog(@"browserViewControllerWasCancelled:%@", browserViewController);
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

// デバイスの表示可否
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;
{
    NSLog(@"browserViewController:%@ shouldPresentNearbyPeer:%@ withDiscoveryInfo:%@", browserViewController, peerID, info);
    NSString *version = [info objectForKey:@"version"];
    if ([@"1.0" isEqualToString:version]) {
        return YES;
    };
    return NO;
}

#pragma mark - MultiPeerStepperDelegate
// 辞書データを送る
-(void)sendDictionary:(NSDictionary*)dic;
{
    NSLog(@"-sendDictionary: %@", dic);
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *muteDic = [dic mutableCopy];
    [muteDic setObject:appDelegate.session.myPeerID.displayName forKey:@"peerName"];
    UIColor *color = [muteDic objectForKey:@"color"];
    if (color) {
        [muteDic removeObjectForKey:@"color"];
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        [muteDic setObject:[NSNumber numberWithFloat:red] forKey:@"R"];
        [muteDic setObject:[NSNumber numberWithFloat:green] forKey:@"G"];
        [muteDic setObject:[NSNumber numberWithFloat:blue] forKey:@"B"];
        [muteDic setObject:[NSNumber numberWithFloat:alpha] forKey:@"A"];
    }
    if([NSJSONSerialization isValidJSONObject:muteDic]){
        // 辞書をJSONデータに変換
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:muteDic options:NSJSONWritingPrettyPrinted error:&error];
        // JSONデータを送信する
        [appDelegate.session sendData:data toPeers:appDelegate.session.connectedPeers withMode:self.reliableSW.isOn ? MCSessionSendDataReliable : MCSessionSendDataUnreliable error:&error];
    }else{
        NSLog(@"non valid data: %@", dic);
    }
    // 画面に表示
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myScene addDictionary:dic];
    });
}

-(void)recvDictionary:(NSDictionary*)dic;
{
    NSLog(@"-recvDictionary: %@", dic);
    // バイブレーションを振動させる
    if (self.vibrateSW.isOn) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    // 画面出力
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myScene addDictionary:dic];
    });
}

@end
