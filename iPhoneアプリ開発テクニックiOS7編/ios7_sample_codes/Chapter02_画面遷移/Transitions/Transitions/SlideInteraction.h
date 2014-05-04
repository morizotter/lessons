//
//  SlideInteraction.h
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@protocol SlideInteractionDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
@end

@interface SlideInteraction : UIPercentDrivenInteractiveTransition
@property (nonatomic, weak) id <SlideInteractionDelegate> delegate;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@end
