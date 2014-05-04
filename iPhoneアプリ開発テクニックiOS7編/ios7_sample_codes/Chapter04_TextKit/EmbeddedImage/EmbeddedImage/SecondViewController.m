//
//  SecondViewController.m
//  EmbeddedImage
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 テキスト内に画像を埋め込む方法
 4-3-2 テキストの非表示領域設定と画像の埋め込み
 **************************************************** */

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"image"];
    // 非表示領域を設定
    CGRect exclusionRect = CGRectMake(120, 30, image.size.width, image.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:exclusionRect];
    self.textView.textContainer.exclusionPaths = @[path];
    
    // 座標変換: UITextContainer(exclusionRect) -> UITextView(imageRect)
    CGRect imageRect = CGRectOffset(exclusionRect,
                                    self.textView.textContainerInset.left,
                                    self.textView.textContainerInset.top);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = imageRect;
    [self.textView addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
