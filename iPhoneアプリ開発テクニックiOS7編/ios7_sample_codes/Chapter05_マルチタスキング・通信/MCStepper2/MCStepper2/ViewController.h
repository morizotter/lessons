//
//  ViewController.h
//  MCStepper2
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController
- (IBAction)connectAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *vibrateSW;
@property (strong, nonatomic) IBOutlet UISwitch *reliableSW;

@end
