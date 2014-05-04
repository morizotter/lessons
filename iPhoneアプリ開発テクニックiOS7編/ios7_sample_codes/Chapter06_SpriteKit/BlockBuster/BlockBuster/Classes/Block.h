//
//  Block.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    BlockTypeGreen = 0,
    BlockTypeYellow,
    BlockTypeRed,
} BlockType;
#define BlockTypeMax BlockTypeRed

@class BlockController;

@interface Block : SKSpriteNode

/**
 * 指定したタイプでブロックノードを作成
 *
 * @param type ブロックのタイプを BlockType で指定
 */
+ (instancetype)blockNodeWithType:(BlockType)type;

/**
 * ブロック管理ノードへの弱参照
 */
@property (nonatomic, weak) BlockController *mother;
@end
