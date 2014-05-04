//
//  WebNavigateViewController.h
//  WebviewTEST
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface WebNavigateViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)goBack;

@end
