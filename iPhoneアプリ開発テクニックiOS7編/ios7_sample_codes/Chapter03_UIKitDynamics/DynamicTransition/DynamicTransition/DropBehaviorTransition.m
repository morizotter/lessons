//
//  DropBehaviorTransition.m
//  DynamicTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ********************************************************
 3-2-3 UIKit Dynamics を利用した画面遷移
 UIDynamicBehaviorのサブクラスであり、独自の落下動作を定義します。
 それと同時に、UIViewControllerAnimatedTransitioningプロトコルを採用し、
 画面遷移時のアニメーションコントローラとして使用できるようにします。
 ******************************************************** */

#import "DropBehaviorTransition.h"

@interface DropBehaviorTransition () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation DropBehaviorTransition

#pragma mark -
#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    /* ----- アニメーションコントローラとしての処理（ここから） ----- */
    // コンテキストの保存
    self.transitionContext = transitionContext;
    
    // 遷移元、遷移先のビューコントローラを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // コンテナビューに遷移先ビューを追加
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    // 物理動作させるための土台となるビューを作成し、コンテナビューに追加
    UIView *dynamicView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                             frame.size.width * 1.5,
                                             frame.size.height * 2)];
    UIView *fromView = fromVC.view;
    [dynamicView addSubview:fromView];
    [containerView addSubview:dynamicView];
    
    /* ----- アニメーションコントローラとしての処理（ここまで） ----- */
    
    /* ----- カスタムbehaviorとしての処理（ここから） ----- */
    // animatorの作成
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:dynamicView];
    self.animator.delegate = self;
    
    // 落下動作
    UIGravityBehavior *gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[fromView]];
    [self addChildBehavior:gravityBehavior];
    
    // 衝突動作
    UICollisionBehavior *collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[fromView]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self addChildBehavior:collisionBehavior];
    
    // 右端1点でぶら下げるためのattachment behavior
    UIOffset offset = UIOffsetMake(frame.size.width / 2.0f, frame.size.height / 2.0);
    UIAttachmentBehavior *attachmentBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:fromView
                              offsetFromCenter:offset
                              attachedToAnchor:CGPointMake(frame.size.width, 0)];
    [self addChildBehavior:attachmentBehavior];
    self.attachmentBehavior = attachmentBehavior;
    
    __weak DropBehaviorTransition *weakSelf = self;
    self.action = ^{
        if (weakSelf.animator.elapsedTime > 0.5 && weakSelf.attachmentBehavior) {
            // 0.5秒以上物理動作が継続していたら画面を落下させる
            [weakSelf removeChildBehavior:weakSelf.attachmentBehavior];
            weakSelf.attachmentBehavior = nil;
        }
    };
    /* ----- カスタムbehaviorとしての処理（ここまで） ----- */
    
    /* ----- 画面遷移アニメーションの開始 ----- */
    // animatorに自身をbehaviorとして追加
    // この追加処理により物理動作（画面遷移アニメーション）が開始される
    [self.animator addBehavior:self];
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // referenceView (dynamicView) を削除
    [self.animator.referenceView removeFromSuperview];
    self.animator = nil;
    self.transitionContext = nil;
}

#pragma mark -
#pragma mark UIDynamicAnimatorDelegate
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    if (self.attachmentBehavior == nil) { // すべてのアニメーションが終了
        [self.transitionContext completeTransition:YES];
    } else { // ぶら下がった状態で停止->画面の落下を開始する
        [self removeChildBehavior:self.attachmentBehavior];
        self.attachmentBehavior = nil;
    }
}

@end
