//
//  SlideTransition.m
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 2-2-2 アニメーションコントローラの作成
 **************************************************** */

#import "SlideTransition.h"

@implementation SlideTransition

- (NSTimeInterval)transitionDuration:
(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // 遷移元、遷移先のビューコントローラ、ビューを取得 --(1)
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // アニメーションを実行するためのコンテナビューを取得 --(2)
    UIView *containerView = [transitionContext containerView];
    
    // スライドアニメーション用にinframe(画面内)とoutframe(画面外)を計算
    CGRect inframe = [transitionContext initialFrameForViewController:fromVC];
    CGRect outframe = CGRectOffset(inframe, CGRectGetWidth(inframe), 0);
    
    if (self.presenting) { // 次の画面を表示する場合
        // 遷移元のビューの上に遷移先のビューを重ねる --(3)
        [containerView addSubview:toView];
        
        // ビューの位置を初期化 --(4)
        fromView.frame = inframe;
        toView.frame = outframe;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             // 遷移先のビューを画面内に移動 --(5)
                             toView.frame = inframe;
                         }
                         completion:^(BOOL finished){
                             // 画面遷移終了を通知 --(6)
                             BOOL completed = ![transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:completed];
                         }
         ];
    } else { // 元の画面に戻る場合
        // 遷移元のビューの下に遷移先のビューを挿入 --(3)
        [containerView insertSubview:toView belowSubview:fromView];
   
        // ビューの位置を初期化 --(4)
        fromView.frame = inframe;
        toView.frame = inframe;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          animations:^{
                              // 遷移元のビューを画面外に移動 --(5)
                              fromView.frame = outframe;
                          }
                          completion:^(BOOL finished){
                              // 画面遷移終了を通知 --(6)
                              BOOL completed = ![transitionContext transitionWasCancelled];
                              [transitionContext completeTransition:completed];
                          }
         ];
    }
}

@end
