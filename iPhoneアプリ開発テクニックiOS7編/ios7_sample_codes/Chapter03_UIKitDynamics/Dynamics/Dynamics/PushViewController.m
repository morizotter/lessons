//
//  PushViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 基本behavior
 pushを利用したサンプル
 *********************************************** */

#import "PushViewController.h"

@interface PushViewController ()
@property (nonatomic, weak) UIView *square1;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@end

@implementation PushViewController

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
    
    UIView *square1 = [[UIView alloc] initWithFrame:CGRectMake(110, 80, 100, 100)];
    square1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:square1];
    self.square1 = square1;
    
    UIDynamicAnimator *animator =
    [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIPushBehavior *pushBehavior =
    [[UIPushBehavior alloc] initWithItems:@[square1]
                                     mode:UIPushBehaviorModeInstantaneous];
    [animator addBehavior:pushBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[square1]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collisionBehavior];
    
    self.pushBehavior = pushBehavior;
    self.animator = animator;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               self.view.bounds.size.height - 40,
                                                               self.view.bounds.size.width - 20,
                                                               30)];
    label.text = @"指の動きに合わせて対象物に力がかかります";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    CGFloat tx = translation.x / 100.0f;
    CGFloat ty = translation.y / 100.0f;
    
    self.pushBehavior.pushDirection = CGVectorMake(tx, ty);
    self.pushBehavior.active = YES; // Instantaneousモードのときは毎回アクティブにする
}

@end
