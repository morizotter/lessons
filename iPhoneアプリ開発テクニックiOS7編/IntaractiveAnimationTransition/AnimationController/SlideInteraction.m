//
//  SlideInteraction.m
//  InteractiveTransition
//
//  Created by MORITA NAOKI on 2014/05/04.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "SlideInteraction.h"

@implementation SlideInteraction

- (void)setView:(UIView *)view {
    _view = view;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            // ジェスチャーを検出したらデリゲートを通じて画面遷移を開始する
            CGPoint point = [gesture locationInView:self.view];
            self.interactive = YES;
            [self.delegate interactionBeganAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // ジェスチャーの更新に合わせて画面遷移の進捗を更新する
            CGRect viewRect = self.view.bounds;
            CGPoint translation = [gesture translationInView:self.view];
            CGFloat percent = translation.x / CGRectGetWidth(viewRect);
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [gesture velocityInView:self.view];
            if (velocity.x <= 0) {
                // 左方向に動かしていたらキャンセルとみなす
                [self cancelInteractiveTransition];
            } else {
                // 右方向に動かしていたら画面遷移を継続する
                [self finishInteractiveTransition];
            }
            self.interactive = NO;
            break;
        }
            
        default:
            break;
    }
}

@end
