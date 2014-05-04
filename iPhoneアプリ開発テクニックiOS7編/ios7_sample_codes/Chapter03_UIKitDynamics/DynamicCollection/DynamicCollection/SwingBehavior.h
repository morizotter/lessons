//
//  SwingBehavior.h
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface SwingBehavior : UIDynamicBehavior
@property (nonatomic, readonly) NSArray *items;
- (instancetype)initWithItems:(NSArray *)items;
- (void)addItem:(id<UIDynamicItem>)item;
@end
