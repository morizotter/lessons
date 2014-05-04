//
//  AppDelegate.m
//  MCStepper2
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "AppDelegate.h"
@import MultipeerConnectivity;
@import CoreMotion;

#define SERVICE_TYPE @"MCStepper"

@interface AppDelegate () <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
@property MCNearbyServiceAdvertiser *advertiser;
@property MCNearbyServiceBrowser *browser;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    
    // Sessionを初期化
    self.serviceType = SERVICE_TYPE;
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    MCSession *session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionOptional];
    session.delegate = self;
    self.session = session;
    
    // Advertiser を初期化
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:10];
    [info setObject:@"1.0" forKey:@"version"];
    MCNearbyServiceAdvertiser *advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:info serviceType:self.serviceType];
    advertiser.delegate = self;
    self.advertiser = advertiser;
    
    // Browser を初期化
    MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:self.serviceType];
    browser.delegate = self;
    self.browser = browser;
    
    // 万歩計を起動
    if ([CMStepCounter isStepCountingAvailable]) {
        NSLog(@"CMStepCounter: available");
        CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
        [stepCounter stopStepCountingUpdates];
        [stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue] updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            NSLog(@"step numberOfSteps:%ld %@ error:%@", (long)numberOfSteps, timestamp, error);
            if (!error) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSNumber numberWithDouble:32.0] forKey:@"size"];
                [dic setObject:[NSString stringWithFormat:@"%ld Steps.", (long)numberOfSteps] forKey:@"message"];
                [self.stepDelegate sendDictionary:dic];
            }
        }];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    // 広報を停止する
    NSLog(@"stop Advertiser");
    [self.advertiser stopAdvertisingPeer];
    //    // ブラウズを終了する
    //    NSLog(@"stop Browser");
    //    [self.browser stopBrowsingForPeers];
}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    // 広報を開始する
    NSLog(@"start Advertiser");
    [self.advertiser startAdvertisingPeer];
    // ブラウズを開始する
    NSLog(@"start Browser");
    [self.browser startBrowsingForPeers];
    double delayInSeconds = 5.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.browser stopBrowsingForPeers];
    });
}

//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
//}

#pragma mark - MCSessionDelegate
// 接続相手の状態が変わった
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session:peer: %@ didChangeState: %@", peerID.displayName, (state == 0 ? @"NotConnected" : (state == 1 ? @"Connecting" : @"Connected")));
    switch (state) {
        case MCSessionStateNotConnected:	// 切断した
            break;
        case MCSessionStateConnecting:		// 接続中
            break;
        case MCSessionStateConnected:		// 接続できた
            break;
        default:
            break;
    }
}

// dataを受け取った
// サブスレッドで受けてる
// 送信元： - (BOOL)sendData:(NSData *)data toPeers:(NSArray *)peerIDs withMode:(MCSessionSendDataMode)mode error:(NSError **)error;
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session: didReceiveData: fromPeer:%@", peerID.displayName);
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSMutableDictionary *dic = [json mutableCopy];
    if (!error) {
        NSLog(@"data = %@", json);
        // 色
        NSNumber *r = [json objectForKey:@"R"];
        NSNumber *g = [json objectForKey:@"G"];
        NSNumber *b = [json objectForKey:@"B"];
        NSNumber *alpha = [json objectForKey:@"A"];
        if (r && g && b && alpha) {
            UIColor *color = [UIColor colorWithRed:r.doubleValue green:g.doubleValue blue:b.doubleValue alpha:alpha.doubleValue];
            [dic setObject:color forKey:@"color"];
        }
        [self.stepDelegate recvDictionary:dic];
    }
}

// 相手からストリームデータを受けた
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session: didReceiveStream: withName:%@ fromPeer:%@", streamName, peerID.displayName);
    //    // Stream をdelegateで処理するように設定
    //    [stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    //    stream.delegate = self;
    //    [stream open];
}

// リソースの受信が始まった
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session: didStartReceivingResourceWithName:%@ fromPeer:%@ withProgress:", resourceName, peerID.displayName);
    // progress に進捗が入る
    //    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

// リソースの受信を完了した
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session: didFinishReceivingResourceWithName:%@ fromPeer:%@ atURL: withError:", resourceName, peerID.displayName);
    // localURLにファイルがある
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //    });
}

// 接続先の証明書を確認して接続可否を判断する
- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-session: didReceiveCertificate:%@ fromPeer:%@ certificateHandler:", certificate, peerID.displayName);
    certificateHandler(YES);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
// 広報できなかった
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"error: %@", error);
}

// 接続要求を受けた
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"-- invite: %@ [%@]", peerID.displayName, [[NSString alloc] initWithData:context encoding:NSUTF8StringEncoding]);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"Invite from %@", peerID.displayName] forKey:@"message"];
    [self.stepDelegate sendDictionary:dic];
    invitationHandler(YES, self.session);
}

#pragma mark - MCNearbyServiceBrowserDelegate
// ブラウズできなかった
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSLog(@"error: %@", error);
}

// peer を発見した
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    [self.browser invitePeer:peerID toSession:self.session withContext:NULL timeout:30];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"Connect to %@", peerID.displayName] forKey:@"message"];
    [self.stepDelegate sendDictionary:dic];
}

// peer を失った
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID;
{
    NSLog(@"%s %s:%d", __PRETTY_FUNCTION__, __FILE__, __LINE__);
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ Bye Bye!", peerID.displayName] forKey:@"message"];
    [self.stepDelegate sendDictionary:dic];
}

@end
