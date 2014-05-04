//
//  PanInteraction.h
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <Foundation/Foundation.h>

@protocol PanInteractionDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
@end

@interface PanInteraction : NSObject <UIViewControllerInteractiveTransitioning>
@property (nonatomic, weak) id <PanInteractionDelegate> delegate;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@end
