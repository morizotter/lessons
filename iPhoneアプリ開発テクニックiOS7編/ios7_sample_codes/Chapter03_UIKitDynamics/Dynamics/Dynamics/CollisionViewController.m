//
//  CollisionViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 基本behavior
 collisionを利用したサンプル
 UIBezirPathにより衝突対象となる物体を作成
 *********************************************** */

#import "CollisionViewController.h"

@interface CollisionViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation CollisionViewController

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
        
        CGRect barRect = CGRectMake(0, 280, 130, 10);
        UIView *bar = [[UIView alloc] initWithFrame:barRect];
        bar.backgroundColor = [UIColor grayColor];
        [self.view addSubview:bar];
        
        // (1) animatorの作成
        UIDynamicAnimator *animator =
        [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        // (2) behaviorの作成
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[square1]];
        
        UICollisionBehavior *collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[square1]];
        // viewの境界を衝突対象とする
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        // barRectから生成されるパスを衝突対象とする
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:barRect];
        [collisionBehavior addBoundaryWithIdentifier:@"bar" forPath:path];
        
        // (3) animatorにbehaviorを追加
        [animator addBehavior:gravityBehavior];
        [animator addBehavior:collisionBehavior];
        
        self.animator = animator;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
