//
//  Player.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "Player.h"
#import "Ball.h"
#import "GameConfig.h"
#import "OnHitProtocol.h"

@interface Player () <OnHitProtocol>
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end

@implementation Player

+ (instancetype)playerNode
{
    return [Player spriteNodeWithColor:[UIColor whiteColor]
                                  size:CGSizeMake(80, 10)];
}

-(instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];
    if (self) {
        // 物理特性を設定
        // （よく弾むが、移動は自分で行うためdynamicはNOとする）
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.restitution = 1.05;

        self.direction = PlayerDirectionStopped;
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval dt = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;

    CGFloat dx = 0.0;

    // 指定した方向に一定速度で動かす
    switch (self.direction) {
        case PlayerDirectionLeft:
            dx = PLAYER_SPEED * dt * -1.0;
            break;
        case PlayerDirectionRight:
            dx = PLAYER_SPEED * dt;
            break;
        default:
            break;
    }
    CGFloat newX = self.position.x + dx;
    if (newX < self.size.width/2) {
        newX = self.size.width / 2;
    } else if (newX > self.scene.size.width-self.size.width/2) {
        newX = self.scene.size.width - self.size.width / 2;
    }
    self.position = CGPointMake(newX, self.position.y);
}

#pragma mark - OnHitProtocol
- (void)onHit:(SKNode *)node at:(CGPoint)contactPoint impulse:(CGFloat)collisionImpulse
{
    if ([node isMemberOfClass:[Ball class]]) {
        // ボールとぶつかった場合は、当たった位置により角度を付ける
        // (X方向への速度が0にならないように)
        // 縦方向のスピードも速くなる
        CGPoint point = [self convertPoint:contactPoint
                                  fromNode:self.parent];
        CGFloat dx = point.x - self.size.width/2; // 中心からの距離
        CGVector v = CGVectorMake(node.physicsBody.velocity.dx + dx,
                                  node.physicsBody.velocity.dy + dx*2);
        node.physicsBody.velocity = v;
    }
}
@end
