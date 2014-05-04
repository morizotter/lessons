//
//  TransitionController.h
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <Foundation/Foundation.h>

@protocol TransitionControllerDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
@end

@interface TransitionController : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic, weak) id <TransitionControllerDelegate> delegate;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, readonly) UICollectionView *collectionView;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
