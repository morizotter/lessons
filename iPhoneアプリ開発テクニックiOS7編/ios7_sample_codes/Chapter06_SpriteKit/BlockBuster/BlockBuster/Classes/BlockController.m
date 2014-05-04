//
//  BlockController.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "BlockController.h"
#import "Block.h"
#import "GameConfig.h"

@interface BlockController ()
@property (nonatomic,strong) NSMutableArray *blocks;
@end

@implementation BlockController

+(instancetype)controller
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.blocks = [@[] mutableCopy];
    }
    return self;
}

- (void)deployBlocksInScene:(SKScene *)scene;
{
    self.scene = scene;

    CGPoint initialPoint = CGPointMake(2.5+17.5, scene.size.height*0.6);

    for (int i=0; i<64; i++) {
        NSInteger col  = i % 8; // 何列目か
        NSInteger line = i / 8; // 何段目か

        // 2段ずつタイプを変えてブロックを作成
        BlockType type = (line / 2) % (BlockTypeMax + 1);
        Block *block = [Block blockNodeWithType:type];

        CGFloat x = initialPoint.x + (col * (block.size.width + 5.0));
        CGFloat y = initialPoint.y + (line * (block.size.height + 10.0));
        block.position = CGPointMake(x, y);

        // 配置
        block.mother = self;
        [self.blocks addObject:block];
        [scene addChild:block];
    }
}

- (void)brokeBlock:(Block *)block
{
    // 渡されたブロックは破壊されたとみなし、コンテナから除去
    [self.blocks removeObject:block];
    if (self.blocks.count == 0) {
        // すべてのブロックが破壊されたので、ゲームクリア
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:GameClearNotification
                              object:nil
                            userInfo:nil];
    }
}
@end
