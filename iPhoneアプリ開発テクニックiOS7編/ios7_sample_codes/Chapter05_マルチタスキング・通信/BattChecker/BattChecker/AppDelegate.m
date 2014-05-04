//
//  AppDelegate.m
//  BattChecker
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // バッテリーモニタを有効にします
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    // fetch実行を指定します。
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

// fetchが起きると呼び出される
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
{
    // バッテリーレベル確認
    int level = [UIDevice currentDevice].batteryLevel * 100;
    [UIApplication sharedApplication].applicationIconBadgeNumber = level;
    
    // ログファイルに出力する
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *logURL = [documentsDirectory URLByAppendingPathComponent:@"fetchlog.txt"];
    // ログファイルが無い場合は作成する
    if (![fileManager fileExistsAtPath:logURL.path]) {
        if (![fileManager createFileAtPath:logURL.path contents:nil attributes:nil]) {
            NSLog(@"file create error");
        }
    }
    // ファイルオープン
    NSError *error;
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingToURL:logURL error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    // ファイル末尾に移動
    [handle seekToEndOfFile];
    // ログに書くデータを作る
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    NSData *data = [[NSString stringWithFormat:@"%@ [%d] battery level = %ld\n", [dateFormatter stringFromDate:[NSDate date]], getpid(), (long)[UIApplication sharedApplication].applicationIconBadgeNumber] dataUsingEncoding:NSUTF8StringEncoding];
    [handle writeData:data];	// 書き込み
	[handle closeFile];
    
    // fetch処理完了
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
