//
//  Ball.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

@import QuartzCore;

#import "Ball.h"
#import "OnHitProtocol.h"
#import "GameConfig.h"

const CGFloat BALLSIZE = 15.0;

@interface Ball () <OnHitProtocol>
@end

@implementation Ball
+(instancetype)ball
{
    // ボールをオフスクリーンレンダリングした画像で作成する
    UIGraphicsBeginImageContext(CGSizeMake(BALLSIZE, BALLSIZE));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1); // 白
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, BALLSIZE, BALLSIZE));

    // 描画した図をCGImage→SKTextureに変換して、スプライトを作成
    CGImageRef imgRef = CGBitmapContextCreateImage(ctx);
    SKTexture *texture = [SKTexture textureWithCGImage:imgRef];
    Ball *me = [super spriteNodeWithTexture:texture];

    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();

    return me;
}

-(instancetype)initWithTexture:(SKTexture *)texture
{
    self = [super initWithTexture:texture];

    if (self) {
        // ボールの物理特性を設定
        // （よく弾み、速度の減衰なし）
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BALLSIZE/2];
        self.physicsBody.friction = 0.0;
        self.physicsBody.restitution = 1.0;
        self.physicsBody.linearDamping = 0.0;
        self.physicsBody.contactTestBitMask = NodeTypeBlock | NodeTypePlayer;
    }

    return self;
}

#pragma mark - OnHitProtocol
- (void)onHit:(SKNode *)node at:(CGPoint)contactPoint impulse:(CGFloat)collisionImpulse
{
    // ボールに制限速度を設ける
    CGVector v = self.physicsBody.velocity;
    if (ABS(v.dx)  > MAXIMUM_BALL_SPEED) {
        v.dx = (v.dx > 0)? MAXIMUM_BALL_SPEED:-MAXIMUM_BALL_SPEED;
    }
    if (ABS(v.dy) > MAXIMUM_BALL_SPEED) {
        v.dy = (v.dy > 0)? MAXIMUM_BALL_SPEED:-MAXIMUM_BALL_SPEED;
    }
    self.physicsBody.velocity = v;
}
@end
