//
//  SnapViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 基本behavior
 snapを利用したサンプル
 *********************************************** */


#import "SnapViewController.h"

@interface SnapViewController ()
@property (nonatomic, weak) UIView *square1;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@end

@implementation SnapViewController

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
    self.animator = animator;
    
    // snap behavior はタップ検出時に追加
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTap:)];
    [self.view addGestureRecognizer:gesture];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               self.view.bounds.size.height - 40,
                                                               self.view.bounds.size.width - 20,
                                                               30)];
    label.text = @"画面上をタップすると対象物が移動します";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.view];
    
    // すでに追加されているsnap behaviorを削除
    // removeBehavior:にnilを渡すと無視されるため、self.snapBehavior != nilのチェックは不要
    [self.animator removeBehavior:self.snapBehavior];
    
    // snap behaviorを作成しanimatorに追加
    UISnapBehavior *snapBehavior =
    [[UISnapBehavior alloc] initWithItem:self.square1
                             snapToPoint:point];
    [self.animator addBehavior:snapBehavior];
    self.snapBehavior = snapBehavior;
    
    // snap位置が分かるようにpointViewを追加
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(point.x - 2, point.y - 2, 4, 4)];
    pointView.backgroundColor = [UIColor redColor];
    [self.view addSubview:pointView];
    // 1秒後にpointViewを消すアニメーション
    [UIView animateWithDuration:1.0
                     animations:^{
                         pointView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [pointView removeFromSuperview];
                     }];

}

@end
