//
//  FirstViewController.m
//  EmbeddedImage
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 テキスト内に画像を埋め込む方法
 4-2-3 UITextView によるデータ検出と画像の埋め込み（画像埋め込みのサンプル）
 **************************************************** */

#import "FirstViewController.h"

@interface FirstViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image"];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -20, image.size.width, image.size.height);

    // 画像を含む属性付き文字を作成
    NSAttributedString *attachmentStr =
    [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    // 属性付き文字として画像を追加
    NSMutableAttributedString *attrstr = self.textView.attributedText.mutableCopy;
    [attrstr insertAttributedString:attachmentStr atIndex:100];
    self.textView.attributedText = attrstr;
    
    // タップ検出用にデリゲートを設定
    self.textView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView
shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment
         inRange:(NSRange)characterRange
{
    NSLog(@"image at character range %@", NSStringFromRange(characterRange));
    // 画像タップ時の処理
    return NO; // YES: デフォルトの処理をする、NO: デフォルトの処理をしない
}

@end
