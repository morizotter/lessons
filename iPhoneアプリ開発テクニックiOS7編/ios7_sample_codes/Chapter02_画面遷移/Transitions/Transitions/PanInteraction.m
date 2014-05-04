//
//  PanInteraction.m
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 2-3-2 高度なインタラクションコントローラの作成
 **************************************************** */

#import "PanInteraction.h"

@interface PanInteraction ()
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) CGFloat transitionDuration;
@end

@implementation PanInteraction

- (void)setView:(UIView *)view
{
    _view = view;
    UIPanGestureRecognizer *gesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)startInteractiveTransition:
(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 画面遷移コンテキストを保存
    self.transitionContext = transitionContext;

    // 遷移元、遷移先のビューコントローラを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // コンテナビューにビューを追加
    [[transitionContext containerView] insertSubview:toVC.view
                                        belowSubview:fromVC.view];
    // 画面遷移時間を取得し保存
    self.transitionDuration = [[fromVC transitionCoordinator] transitionDuration];
}

- (CGFloat)completionSpeed
{
    return 1.0;
}

#pragma mark -
#pragma mark private methods
// 画面遷移の進捗を更新
- (void)updateInteractiveTransitionWithTranslation:(CGPoint)translation
{
    if (self.transitionContext == nil) return;
    
    UIViewController *fromVC =
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    // ビューの位置を更新
    CGRect frame = fromVC.view.frame;
    frame.origin.x = translation.x;
    frame.origin.y = translation.y;
    fromVC.view.frame = frame;
    
    // 画面遷移の進捗を更新
    self.percentComplete = frame.origin.x < 0 ? 0 : frame.origin.x / frame.size.width;
    [self.transitionContext updateInteractiveTransition:self.percentComplete];
}

// インタラクティブ画面遷移終了
- (void)finishInteractiveTransitionWithVelocity:(CGPoint)velocity
{
    if (self.transitionContext == nil) return;
    
    UIViewController *fromVC =
    [self.transitionContext
     viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 最終frameの計算
    CGRect frame = fromVC.view.frame;
    CGRect finalFrame = frame;

    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat dx = width - frame.origin.x;
    CGFloat dy = velocity.y < 0 ?
    - (height + frame.origin.y) : height - frame.origin.y;
    
    if (velocity.y == 0 || fabsf(dx/dy) < fabsf(velocity.x/velocity.y)) {//右に消える
        finalFrame.origin.x = width;
        finalFrame.origin.y += dx * velocity.y / velocity.x;
    } else { // 上または下に消える
        finalFrame.origin.x += dy * velocity.x / velocity.y;
        finalFrame.origin.y = (velocity.y < 0 ? -height : height);
    }

    // アニメーション時間の計算 --- (1)
    NSTimeInterval duration = self.transitionDuration // --- (1-a)
    * (1 - self.percentComplete) // --- (1-b)
    / [self completionSpeed]; // --- (1-c)
    
    // インタラクティブ画面遷移終了 --- (2)
    [self.transitionContext finishInteractiveTransition];
    
    // 残りのアニメーションを実行 --- (3)
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.frame = finalFrame;
                     }
                     completion:^(BOOL finished){
                         // 画面遷移終了を通知 --- (4)
                         [self.transitionContext completeTransition:YES];
                     }];
    
}

// インタラクティブ画面遷移キャンセル
- (void)cancelInteractiveTransition
{
    if (self.transitionContext == nil) return;

    UIViewController *fromVC =
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect frame = [self.transitionContext initialFrameForViewController:fromVC];

    // アニメーション時間の計算 --- (1)
    NSTimeInterval duration = self.transitionDuration
    * self.percentComplete
    / [self completionSpeed];
    
    // インタラクティブ画面遷移キャンセル --- (2)
    [self.transitionContext cancelInteractiveTransition];
    
    // キャンセル時のアニメーションを実行 --- (3)
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // 画面遷移終了を通知
                         [self.transitionContext completeTransition:NO];
                     }];
}

#pragma mark gesture handler
// ジェスチャーハンドラ
// 指の位置に応じて画面遷移を進める
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // 画面遷移開始
            CGPoint point = [gesture locationInView:self.view];
            self.interactive = YES;
            [self.delegate interactionBeganAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // 画面遷移の進捗を更新
            CGPoint translation = [gesture translationInView:self.view];
            [self updateInteractiveTransitionWithTranslation:translation];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            // ジェスチャーの方向によりキャンセルまた終了を判断
            CGPoint velocity = [gesture velocityInView:self.view];
            if (velocity.x <= 0) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransitionWithVelocity:velocity];
            }
            self.interactive = NO;
            break;
        }
        default:
            break;
    }
}
@end
