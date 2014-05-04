//
//  AppDelegate.m
//  SessionBrowser
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"%@ -application: didFinishLaunchingWithOptions:%@", NSStringFromClass(self.class), launchOptions);
    // キャッシュの一覧を表示
    // Library/Caches/com.apple.nsnetworkd
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cacheDirectory = [urls objectAtIndex:0];
    NSLog(@"caches: %@", urls);
    NSError *error;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    for (NSURL *url in [fileManager contentsOfDirectoryAtURL:cacheDirectory includingPropertiesForKeys:nil options:0 error:&error]) {
        NSLog(@"- %@", url.path);
        for (NSURL *file in [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:0 error:&error]) {
            NSDictionary *dic = [fileManager attributesOfItemAtPath:file.path error:&error];
            NSLog(@"  %@ - %@", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:dic.fileSize]], file.path);
        }
    }
    // 現在Download中のセッションを取得する
    [self.globalSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSLog(@"dataTasks = %@", dataTasks);
        NSLog(@"uploadTasks = %@", uploadTasks);
        NSLog(@"downloadTasks = %@", downloadTasks);
        if (downloadTasks) {
            self.downloadTasks = [NSMutableArray arrayWithArray:downloadTasks];
        }else {
            self.downloadTasks = [NSMutableArray arrayWithCapacity:10];
        }
    }];
    // さいしょに表示するURLを決定する
	self.webViewURL = @"https://developer.apple.com/devcenter/ios/index.action";
    //
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"%@ -applicationWillResignActive:", NSStringFromClass(self.class));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%@ -applicationDidEnterBackground:", NSStringFromClass(self.class));
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"%@ -applicationWillEnterForeground:", NSStringFromClass(self.class));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@ -applicationDidBecomeActive:", NSStringFromClass(self.class));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%@ -applicationWillTerminate:", NSStringFromClass(self.class));
}

// バックグラウンドでセッションが完了したときに呼び出される(はず)
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"%@ -application: handleEventsForBackgroundURLSession:%@ completionHandler:", NSStringFromClass(self.class), identifier);
    //
    completionHandler();
}

#pragma mark -
- (NSURLSession*)globalSession;
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%@ dispatch_once", NSStringFromClass(self.class));
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"jp.coocan.movie.ero.BackgroundSession"];
        configuration.HTTPAdditionalHeaders = @{};
        configuration.allowsCellularAccess = YES;	// 3G,LTE通信はしない → WiFi無いとofflineエラーになる
        configuration.timeoutIntervalForRequest = 30; // レスポンス
        configuration.timeoutIntervalForResource = 3000; // 通信完了まで（無通信じゃないよ！）
        configuration.sessionSendsLaunchEvents = YES;
        
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

// ダウンロード開始
- (void)startDownload:(NSURLRequest *)request;
{
    NSLog(@"%@ -startDownload:%@", NSStringFromClass(self.class), request);
    NSURLSessionDownloadTask *downloadTask = [self.globalSession downloadTaskWithRequest:request];
    [self.downloadTasks addObject:downloadTask];
    [downloadTask resume];
    
    NSLog(@"tasks = %@", self.downloadTasks);
}

// ダウンロード停止
- (void)stopDownload:(NSURLSessionTask*)task;
{
    NSLog(@"%@ -stopDownload:%@", NSStringFromClass(self.class), task);
    [task cancel];
    [self.downloadTasks removeObject:task];
}

// キャンセル
- (void)cancel:(void (^)(void)) handler;
{
    NSLog(@"%@ -cancel", NSStringFromClass(self.class));
	[self.globalSession flushWithCompletionHandler:^{
        NSLog(@"flushWithCompletion");
        handler();
    }];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
{
    NSLog(@"%@ -URLSession: didBecomeInvalidWithError:%@", NSStringFromClass(self.class), error);
    
}

// 認証が必要な時に呼び出される
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler;
{
    NSLog(@"%@ -URLSession: didReceiveChallenge:%@ completionHandler:", NSStringFromClass(self.class), challenge);
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;
{
    NSLog(@"%@ -URLSessionDidFinishEventsForBackgroundURLSession:", NSStringFromClass(self.class));
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler;
{
    NSLog(@"%@ -URLSession: task: willPerformHTTPRedirection: newRequest: completionHandler:", NSStringFromClass(self.class));
	
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler;
{
    NSLog(@"%@ -URLSession: task: didReceiveChallenge: completionHandler:", NSStringFromClass(self.class));
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler;
{
    NSLog(@"%@ -URLSession: task: needNewBodyStream:", NSStringFromClass(self.class));
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
{
    NSLog(@"%@ -URLSession: task: didSendBodyData: totalBytesSent: totalBytesExpectedToSend:", NSStringFromClass(self.class));
    
}

// DL完了したときに呼び出される②
// エラーがある場合に理由が入る
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
{
    NSLog(@"%@ -URLSession: task: didCompleteWithError:%@", NSStringFromClass(self.class), error);
    if (error) {
        NSLog(@"session: %@", session);
        NSLog(@"task: %@", task);
        // もし継続するのであれば、-downloadTaskWithResumeData: を呼ぶ
        NSLog(@"resume");
    }
    [self.downloadTasks removeObject:task];
}

#pragma mark - NSURLSessionDownloadDelegate
// DL完了したときに呼び出される①
// ・テンポラリファイル名が渡される(location)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location;
{
    NSLog(@"%@ -URLSession: downloadTask: didFinishDownloadingToURL:%@", NSStringFromClass(self.class), location);
    // ファイルを保存する名前を作る
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *error;
    // サイズ確認
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:location.path error:nil];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSLog(@"destination: %@ %@", destinationURL.lastPathComponent, [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:dic.fileSize]]);
    // コピー先にファイルが有れば削除して新しいファイルを移動する
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager moveItemAtURL:location toURL:destinationURL error:&error];
    if (success) {
        NSLog(@"saved: %@", destinationURL.lastPathComponent);
    } else {
        NSLog(@"copy error: %@ %@", destinationURL.lastPathComponent, error);
    }
}

// DLしたサイズが都度呼び出される。※プログレスバー用
// 呼び出される時のthreadは固定されない
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
{
    NSLog(@"%@ -URLSession: downloadTask: didWriteData:%lld totalBytesWritten:%lld totalBytesExpectedToWrite:%lld", NSStringFromClass(self.class), bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes;
{
    NSLog(@"%@ -URLSession: downloadTask: didResumeAtOffset:%lld expectedTotalBytes:%lld", NSStringFromClass(self.class), fileOffset, expectedTotalBytes);
}

@end
