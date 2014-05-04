//
//  DataViewController.m
//  TextKitBook
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 4-3-3 マルチカラムレイアウト
 
 Page-Based Applicationのテンプレートを元に、NSTextContainerを
 利用してマルチカラムレイアウトを実現する例
 テキストコンテナの生成はModelControllerが担当し、DataViewControllerでは
 ページ内に2つのUITextViewを配置し、各コンテナの内容を表示する
 
 独自のUITextContainerを持つUITextViewはStoryboardでは作成できないため
 コードで作成（viewDidLoad）。
 **************************************************** */

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITextView *leftTextView =
    [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 314, 884)
                        textContainer:self.leftContainer];
    
    leftTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    leftTextView.editable = NO;
    leftTextView.scrollEnabled = NO;
    leftTextView.userInteractionEnabled = YES;
    [self.view addSubview:leftTextView];
    
    if (self.rightContainer) {
        UITextView *rightTextView =
        [[UITextView alloc] initWithFrame:CGRectMake(354, 20, 314, 884)
                            textContainer:self.rightContainer];
        rightTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        rightTextView.editable = NO;
        rightTextView.scrollEnabled = NO;
        rightTextView.userInteractionEnabled = YES;
        [self.view addSubview:rightTextView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
