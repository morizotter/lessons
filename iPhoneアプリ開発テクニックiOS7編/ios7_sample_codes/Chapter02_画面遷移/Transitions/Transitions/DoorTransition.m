//
//  DoorTransition.m
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 2-2-3 スナップショットを利用したアニメーション
 **************************************************** */

#import "DoorTransition.h"

@implementation DoorTransition

- (NSTimeInterval)transitionDuration:
(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 遷移元、遷移先のビューコントローラ、ビューを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // アニメーションを実行するためのコンテナビューを取得
    UIView *containerView = [transitionContext containerView];
    
    // 分割対象となるビューの画面全体のスナップショットを作成 ---(1)
    UIView *snapshot = self.presenting ?
    [fromView snapshotViewAfterScreenUpdates:NO] :
    [toView snapshotViewAfterScreenUpdates:YES];
    
    CGFloat w = CGRectGetWidth(snapshot.frame) / 2.0f;
    CGFloat h = CGRectGetHeight(snapshot.frame);
    
    // 分割対象のスナップショットから左右それぞれのビューを作成 ---(2)
    UIView *leftView = [snapshot resizableSnapshotViewFromRect:CGRectMake(0, 0, w, h)
                                            afterScreenUpdates:NO
                                                 withCapInsets:UIEdgeInsetsZero];
    UIView *rightView = [snapshot resizableSnapshotViewFromRect:CGRectMake(w, 0, w, h)
                                             afterScreenUpdates:NO
                                                  withCapInsets:UIEdgeInsetsZero];
    
    // 左右それぞれの画面内、画面外frameを計算
    CGRect leftFrame = leftView.frame;
    CGRect leftOutFrame = CGRectOffset(leftFrame, -CGRectGetWidth(leftFrame), 0);
    CGRect rightFrame = CGRectOffset(rightView.frame, CGRectGetWidth(leftFrame), 0);
    CGRect rightOutFrame = CGRectOffset(rightFrame, CGRectGetWidth(rightFrame), 0);
    
    rightView.frame = rightFrame;
    
    // 左右のスナップショットをコンテナビューに追加 ---(3)
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    if (self.presenting) {
        // 遷移先のビューをスナップショットの下に挿入 ---(4)
        [containerView insertSubview:toView belowSubview:leftView];
        
        // 遷移先ビューの alpha の初期状態 ---(5)
        toView.alpha = 0.5;
        
        // コンテナビュー上に最初から乗っている遷移元ビューを取り除く ---(6)
        [fromView removeFromSuperview];

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             // アニメーション ---(7)
                             leftView.frame = leftOutFrame;
                             rightView.frame = rightOutFrame;
                             toView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             // スナップショットを削除 --- (8)
                             [leftView removeFromSuperview];
                             [rightView removeFromSuperview];
                             // 画面遷移終了を通知
                             BOOL completed = ![transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:completed];
                         }
         ];
    } else {
        // 遷移先ビューのスナップショットを画面外に設定
        leftView.frame = leftOutFrame;
        rightView.frame = rightOutFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             // 遷移先ビューのスナップショットを画面内に移動
                             leftView.frame = leftFrame;
                             rightView.frame = rightFrame;
                             fromView.alpha = 0.5;
                         }
                         completion:^(BOOL finished){
                             // アニメーション用に追加したスナップショットを削除
                             [leftView removeFromSuperview];
                             [rightView removeFromSuperview];
                             // 遷移先ビューの追加
                             [containerView addSubview:toView];
                             // 画面遷移終了を通知
                             BOOL completed = ![transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:completed];
                         }];
    }
}
@end
