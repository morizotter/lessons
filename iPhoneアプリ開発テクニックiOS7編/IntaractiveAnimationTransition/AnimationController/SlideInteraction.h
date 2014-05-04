//
//  SlideInteraction.h
//  InteractiveTransition
//
//  Created by MORITA NAOKI on 2014/05/04.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SlideInteractionDelegate;

@interface SlideInteraction : UIPercentDrivenInteractiveTransition
@property (weak, nonatomic) id<SlideInteractionDelegate> delegate;
@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic, getter = isInteractive) BOOL interactive;
@end

@protocol SlideInteractionDelegate <NSObject>

- (void)interactionBeganAtPoint:(CGPoint)point;

@end