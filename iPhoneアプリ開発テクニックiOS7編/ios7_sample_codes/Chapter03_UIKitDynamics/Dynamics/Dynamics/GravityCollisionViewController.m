//
//  GravityCollisionViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 基本behavior
 gravityとcollisionを組み合わせて使用したサンプル
 *********************************************** */

#import "GravityCollisionViewController.h"

@interface GravityCollisionViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation GravityCollisionViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.animator == nil) {
    
        UIView *square1 = [[UIView alloc] initWithFrame:CGRectMake(110, 80, 100, 100)];
        square1.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:square1];
        
        // (1) animatorの作成
        UIDynamicAnimator *animator =
        [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        // (2) behaviorを作成し、itemとしてsquare1を追加
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[square1]];
        
        // 衝突検出用にcollisionBehaviorを作成
        UICollisionBehavior *collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[square1]];
        // referenceViewのboundsを境界として扱う
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        // (3) animatorにbehaviorを追加
        [animator addBehavior:gravityBehavior];
        [animator addBehavior:collisionBehavior];
        
        // (4) animatorをプロパティに保持
        self.animator = animator;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
