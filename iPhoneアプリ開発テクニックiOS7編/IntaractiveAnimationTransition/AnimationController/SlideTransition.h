//
//  SlideTransition.h
//  AnimationController
//
//  Created by MORITA NAOKI on 2014/05/04.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) BOOL presenting;
@end
