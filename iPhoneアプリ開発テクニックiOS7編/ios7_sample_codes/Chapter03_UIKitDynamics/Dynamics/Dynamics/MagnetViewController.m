//
//  MagnetViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 カスタムbehavior
 UIDynamicBehaviorをサブクラス化して作成したMagnetBehaviorの使用例
 *********************************************** */

#import "MagnetViewController.h"
#import "MagnetBehavior.h"

@interface MagnetViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation MagnetViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *square1 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 40, 40)];
    square1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:square1];
    
    UIView *square2 = [[UIView alloc] initWithFrame:CGRectMake(270, 260, 40, 40)];
    square2.backgroundColor = [UIColor redColor];
    [self.view addSubview:square2];

    UIDynamicAnimator *animator =
    [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    MagnetBehavior *magnetBehavior =
    [[MagnetBehavior alloc] initWithItem:square1 anotherItem:square2];
    [animator addBehavior:magnetBehavior];
    
    self.animator = animator;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
