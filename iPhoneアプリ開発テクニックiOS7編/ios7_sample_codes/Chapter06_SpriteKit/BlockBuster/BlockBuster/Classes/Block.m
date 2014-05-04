//
//  Block.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "Block.h"
#import "BlockController.h"
#import "OnHitProtocol.h"
#include "GameConfig.h"

@interface Block () <OnHitProtocol> {
    BlockType _type;
    NSInteger _hp;
}
@property (nonatomic, assign)BOOL alive;
@property (nonatomic, strong)SKEmitterNode *fireParticle;
@end

@implementation Block

+ (instancetype)blockNodeWithType:(BlockType)type
{
    // ブロックの色と体力
    NSArray *typeInfo = @[
                          @[[UIColor greenColor], @1.0],
                          @[[UIColor yellowColor], @5.0],
                          @[[UIColor redColor], @10.0]
                          ];

    Block *me = [Block spriteNodeWithColor:typeInfo[type][0]
                                      size:CGSizeMake(35, 10)];
    me->_type = type;
    me->_hp = [typeInfo[type][1] integerValue];

    return me;
}

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];

    if (self) {
        self.alive = YES;

        // ボールの物理特性を設定
        // （よく弾むが重く、速度の減衰も早い）
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.friction = 0.0;
        self.physicsBody.restitution = 1.05;
        self.physicsBody.linearDamping = 0.2;
        self.physicsBody.angularDamping = 0.5;
        self.physicsBody.mass *= 10;
        self.physicsBody.contactTestBitMask = NodeTypeBlock;

        // sksファイルから爆発パーティクルを作成しておく
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Broken"
                                                             ofType:@"sks"];
        self.fireParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }

    return self;
}

- (void)explode
{
    if (!self.alive) {
        // 爆発処理が始まっている場合、これ以上何もしない
        return;
    }
    self.alive = NO;

    // パーティクルの実行開始
    self.fireParticle.position = self.position;
    [self.mother.scene addChild:self.fireParticle];

    // 0.1秒でフェードアウト、シーンから削除の3アクションを作成
    SKAction *wait = [SKAction waitForDuration:0.2];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.1];
    SKAction *remove = [SKAction removeFromParent];

    // 3つのアクションをシーケンシャルに実行するアクションを作成
    SKAction *waitAndFade = [SKAction sequence:@[wait, fadeOut, remove]];

    // パーティクルとスプライトの両方に一連のアクションを適用
    [self.fireParticle runAction:waitAndFade];
    [self runAction:waitAndFade];
}

#pragma mark - OnHitProtocol
- (void)onHit:(SKNode *)node at:(CGPoint)contactPoint impulse:(CGFloat)collisionImpulse
{
    _hp -= collisionImpulse;
    if (_hp <= 0.0) {
        // 蓄積ダメージがHPを上回った場合は爆発して壊れる
        [self.mother brokeBlock:self];
        [self explode];
    }
}
@end
