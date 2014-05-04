//
//  AppDelegate.h
//  SessionBrowser
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate, UITabBarControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *downloadTasks;
@property (strong, nonatomic) NSString *webViewURL;

- (NSURLSession*)globalSession;
- (void)startDownload:(NSURLRequest*)request;
- (void)stopDownload:(NSURLSessionTask*)task;
- (void)cancel:(void (^)(void)) handler;

@end
