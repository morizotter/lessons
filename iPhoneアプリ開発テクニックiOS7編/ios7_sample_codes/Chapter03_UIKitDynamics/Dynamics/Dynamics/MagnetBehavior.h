//
//  MagnetBehavior.h
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface MagnetBehavior : UIDynamicBehavior
- (instancetype)initWithItem:(id<UIDynamicItem>)item1
                 anotherItem:(id<UIDynamicItem>)item2;
@end
