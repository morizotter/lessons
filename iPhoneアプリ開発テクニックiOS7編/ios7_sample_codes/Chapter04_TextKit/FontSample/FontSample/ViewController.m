//
//  ViewController.m
//  FontSample
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 4-2-1 UIFontDescriptorによるフォントの作成
 4-2-2 Dynamic Type対応
 4-2-3 UITextView によるデータ検出と画像の埋め込み（データ検出のサンプル）
 **************************************************** */

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *helveticaLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *detectorTextView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* ----- 4-2-1 UIFontDescriptorによるフォントの作成 ----- */
    
    // フォントファミリーを指定してディスクリプタを作成
    UIFontDescriptor *helveticaNeueFamily =
    [UIFontDescriptor fontDescriptorWithFontAttributes:
     @{UIFontDescriptorFamilyAttribute: @"Helvetica Neue"}];
    
    // サイズとボールド属性を追加
    helveticaNeueFamily = [helveticaNeueFamily fontDescriptorWithSize:15.0];
    helveticaNeueFamily =
    [helveticaNeueFamily fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    // UIFontDescripter から UIFont を作成
    UIFont *helveticaBoldFont = [UIFont fontWithDescriptor:helveticaNeueFamily size:0.0];
    self.helveticaLabel.font = helveticaBoldFont;
    
    /* ----- 4-2-2 Dynamic Type対応 ----- */

    // Headlineスタイルのフォントを生成し、labelのフォントとして設定
    UIFont *headlineFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.label.font = headlineFont;
    
    // Body スタイルのディスクリプタを生成
    UIFontDescriptor *bodyFontDescriptor =
    [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    // イタリック体の属性を追加
    bodyFontDescriptor =
    [bodyFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    // ディスクリプタからフォントを生成しtextViewのフォントとして設定
    UIFont *bodyFont = [UIFont fontWithDescriptor:bodyFontDescriptor size:0.0];
    self.textView.font = bodyFont;
    
    // 文字サイズの設定変更に対応するために通知を監視
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryDidChange:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    
    /* ----- 4-2-3 UITextView によるデータ検出と画像の埋め込み（データ検出のサンプル） ----- */
    
    self.detectorTextView.text = @"明日午後1時より打ち合わせを行います。"
    " 住所は東京都港区六本木6丁目10番1号です。"
    " ご不明な点は03-1234-5678 までお願いします。"
    "\n\n（URL）http://www.apple.com/jp/ \n\n";

    // editable, dataDetecotrTypesはstoryboardでも設定可
    self.detectorTextView.editable = NO;
    self.detectorTextView.dataDetectorTypes = UIDataDetectorTypeAll;

    // リンク検出時の文字属性を指定
    self.detectorTextView.linkTextAttributes =
    @{NSForegroundColorAttributeName: [UIColor orangeColor],
      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    self.detectorTextView.delegate = self;

    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/"];
    // NSLinkAttributeNameを利用したリンクの埋め込み
    NSAttributedString *linkText =
    [[NSAttributedString alloc] initWithString:@"[link to website]"
                                    attributes:@{NSLinkAttributeName: url}];
    NSMutableAttributedString *attributedText = self.detectorTextView.attributedText.mutableCopy;
    [attributedText appendAttributedString:linkText];
    self.detectorTextView.attributedText = attributedText;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification handler (4-2-2)
// 文字サイズ変更時の処理
- (void)contentSizeCategoryDidChange:(NSNotification *)notification
{
    // 単純なfontプロパティの更新
    // UIFontDescriptor からテキストスタイルを取得
    UIFontDescriptor *fontDescriptor = [self.label.font fontDescriptor];
    NSString *textStyle =
    [fontDescriptor objectForKey:UIFontDescriptorTextStyleAttribute];
    if (textStyle) {
        // テキストスタイルが設定されていた場合はフォントを更新
        UIFont *newFont = [UIFont preferredFontForTextStyle:textStyle];
        self.label.font = newFont;
        [self.label invalidateIntrinsicContentSize];
    }
    
    // 属性付き文字内のフォント属性を更新
    NSTextStorage *storage = self.textView.textStorage;
    [storage beginEditing];
    // フォントに関する属性の数え上げ
    [storage enumerateAttribute:NSFontAttributeName
                        inRange:NSMakeRange(0, storage.length)
                        options:0
                     usingBlock:^(id value, NSRange range, BOOL *stop){
                         // UIFontDescriptor からテキストスタイルを取得
                         UIFontDescriptor *fontDescriptor = [(UIFont *)value fontDescriptor];
                         NSString *textStyle =
                         [fontDescriptor objectForKey:UIFontDescriptorTextStyleAttribute];
                         if (textStyle) {
                             // テキストスタイルが設定されていた場合はフォントを更新
                             UIFont *newFont = [UIFont preferredFontForTextStyle:textStyle];
                             [storage removeAttribute:NSFontAttributeName range:range];
                             [storage addAttribute:NSFontAttributeName
                                             value:newFont range:range];
                         }
                     }];
    [storage endEditing];
}

#pragma mark - UITextViewDelegate (4-2-3)
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
{
    NSLog(@"( URL) %@", [URL absoluteString]);
    NSLog(@"(Text) %@", [textView.text substringWithRange:characterRange]);
    if ([[URL scheme] rangeOfString:@"http"].location != NSNotFound) {
        // UIWebView を利用してアプリ内でリンクを開く
        NSLog(@"open URL on UIWebView: %@", [URL absoluteString]);
        return NO;
    }
    return YES;
}
@end
