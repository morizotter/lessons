//
//  KeyframeTransition.m
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 Keyframeアニメーションメソッド(2-1-3)の使用例
 **************************************************** */

#import "KeyframeTransition.h"

@implementation KeyframeTransition

- (NSTimeInterval)transitionDuration:
(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 遷移元、遷移先のビューコントローラ、ビューを取得
    UIViewController *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC =
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    // アニメーションを実行するためのコンテナビューを取得
    UIView *containerView = [transitionContext containerView];
    
    // スライドアニメーション用にinframe（画面内）とoutframe（画面外）、middleframe（中間）を計算
    CGRect inframe = [transitionContext initialFrameForViewController:fromVC];
    CGRect outframe = CGRectOffset(inframe, CGRectGetWidth(inframe), 0);
    CGRect middleframe = CGRectOffset(inframe, CGRectGetWidth(inframe) / 2.0f, 0);
    
    if (self.presenting) { // 次の画面を表示する場合
        // 遷移元のビューの上に遷移先のビューを重ねる
        [containerView addSubview:toView];
        
        // ビューの位置を初期化
        fromView.frame = inframe;
        toView.frame = outframe;
        toView.transform = CGAffineTransformMakeRotation(M_PI);
        
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                      // 1つ目のKey-frame: スライドアニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           toView.frame = middleframe;
                                       }];
                                      
                                      // 2つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           toView.transform = CGAffineTransformIdentity;
                                           toView.frame = inframe;
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
        
    } else { // 元の画面に戻る場合
        // 遷移元のビューの下に遷移先のビューを追加
        [containerView insertSubview:toView belowSubview:fromView];
        
        // ビューの位置を初期化
        fromView.frame = inframe;
        toView.frame = inframe;
        
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                       delay:0
                                     options:0
                                  animations:^{
                                      // 1つ目のKey-frame: 回転アニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.0
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           fromView.frame = middleframe;
                                           fromView.transform = CGAffineTransformMakeRotation(M_PI);
                                       }];
                                      // 2つ目のKey-frame: スライドアニメーション
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:
                                       ^{
                                           fromView.frame = outframe;
                                       }];
                                  }
                                  completion:^(BOOL finished){
                                      // 画面遷移終了を通知
                                      BOOL completed = ![transitionContext transitionWasCancelled];
                                      [transitionContext completeTransition:completed];
                                  }
         ];
    }

}
@end
