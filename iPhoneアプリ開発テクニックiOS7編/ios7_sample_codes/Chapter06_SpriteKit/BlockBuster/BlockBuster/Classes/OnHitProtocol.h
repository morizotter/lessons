//
//  OnHitProtocol.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <SpriteKit/SpriteKit.h>

@protocol OnHitProtocol <NSObject>

@required
// 衝突に対する振る舞いを定義する。衝突したときにシーンから呼ばれる
- (void)onHit:(SKNode *)node at:(CGPoint)contactPoint impulse:(CGFloat)collisionImpulse;
@end

@interface SKNode (OnHitProtocol) <OnHitProtocol>
@end
