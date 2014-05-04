//
//  ViewController.m
//  CodeEditor
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 4-3-4 文字属性の動的変更
 
 文字属性を動的に変更するために、NSTextStorageをサブクラス化する（SyntaxTextStorage）
 作成した独自のテキストストレージを利用するために、UITextViewのオブジェクトを
 コードから生成（Storyboardでは独自のテキストストレージを対応づけられないため）
 **************************************************** */

#import "ViewController.h"
#import "SyntaxTextStorage.h"

@interface ViewController ()
@property (nonatomic, weak) UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // テキストコンテナを作成する
    CGRect textViewRect = self.view.bounds;
    CGSize containerSize = CGSizeMake(textViewRect.size.width, CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    
    // レイアウトマネージャを作成し、テキストコンテナと関連づける
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:container];

    // 独自のテキストストレージ（SyntaxTextStorage）を作成し、レイアウトマネージャと関連づける
    SyntaxTextStorage *textStorage = [[SyntaxTextStorage alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    // containerをテキストコンテナとして持つUITextViewを作成
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect
                                               textContainer:container];
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.textView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

@end
