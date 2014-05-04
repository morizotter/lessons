//
//  Player.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <SpriteKit/SpriteKit.h>

typedef enum  {
    PlayerDirectionStopped = 0,
    PlayerDirectionLeft,
    PlayerDirectionRight,
} PlayerDirection;

@interface Player : SKSpriteNode
/**
 * 現在進んでいる方向を指定
 */
@property (nonatomic,assign) PlayerDirection direction;

/**
 * コンビニエンスコンストラクタ。プレイヤーノードを返す
 */
+ (instancetype)playerNode;

/**
 * 毎フレームの処理でシーンから呼ばれるメソッド。
 * 他のノードでは使わないので、プロトコルではなくメソッドで宣言
 */
-(void)update:(CFTimeInterval)currentTime;
@end
