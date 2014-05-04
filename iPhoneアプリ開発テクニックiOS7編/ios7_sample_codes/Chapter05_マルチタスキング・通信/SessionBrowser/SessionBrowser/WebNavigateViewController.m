//
//  WebNavigateViewController.m
//  WebviewTEST
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "WebNavigateViewController.h"
#import "AppDelegate.h"

@interface WebNavigateViewController ()

@end

@implementation WebNavigateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.webViewURL) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:appDelegate.webViewURL]]];
    }
}

#pragma mark - 
- (void)goBack;
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSLog(@"%@ -webView: shouldStartLoadWithRequest:%@ navigationType:%ld", NSStringFromClass(self.class), request, (long)navigationType);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    NSLog(@"%@ -webViewDidStartLoad:", NSStringFromClass(self.class));
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"%@ -webViewDidFinishLoad:", NSStringFromClass(self.class));
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSLog(@"%@ -webView: didFailLoadWithError:%@", NSStringFromClass(self.class), error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // DLするようなファイルは Error になる
    // Domain = WebKitErrorDomain
    // Code = 102
    // userInfoの各情報
    //   NSErrorFailingURLKey → これをfetchDownloadしたい
    //   NSErrorFailingURLStringKey
    //   NSLocalizedDescription
    for (NSString *key in error.userInfo.keyEnumerator) {
        NSLog(@"%@ = %@", key, [error.userInfo objectForKey:key]);
    }
    // DL出来ないファイルの場合はDLする
    if (error.code == 102) {
        NSURL *url = (NSURL*)[error.userInfo objectForKey:@"NSErrorFailingURLKey"];
        NSString *fileName = url.lastPathComponent;
        NSLog(@"fileName = %@", fileName);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate startDownload:request];
    }
}

@end
