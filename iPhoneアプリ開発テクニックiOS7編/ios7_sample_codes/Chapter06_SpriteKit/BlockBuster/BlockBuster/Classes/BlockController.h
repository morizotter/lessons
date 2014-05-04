//
//  BlockController.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class Block;

@interface BlockController : NSObject
@property (nonatomic,weak) SKScene *scene;

/**
 * コンビニエンスコンストラクタ
 */
+ (instancetype)controller;

/**
 * シーン上にブロックを並べる
 */
- (void)deployBlocksInScene:(SKScene *)scene;

/**
 * ブロックが破壊されたときの処理を行う
 */
- (void)brokeBlock:(Block *)block;
@end
