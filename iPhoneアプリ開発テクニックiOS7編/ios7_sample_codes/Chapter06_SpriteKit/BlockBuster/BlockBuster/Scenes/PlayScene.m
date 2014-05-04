//
//  MyScene.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "PlayScene.h"
#import "GameConfig.h"
#import "BlockController.h"
#import "Player.h"
#import "Ball.h"
#import "onHitProtocol.h"
#import "EndScene.h"

@interface PlayScene () <SKPhysicsContactDelegate, OnHitProtocol>
@property (nonatomic, assign) GameState state;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) Ball *ball;
@property (nonatomic, strong) BlockController *blocks;
@end

@implementation PlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // シーンのセットアップ
        self.state = GameStateStart;
        [self setupScene];

        // プレーヤーノードを作成して配置
        self.player = [Player playerNode];
        self.player.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetHeight(self.frame)*0.1);
        [self addChild:self.player];

        // ボールを配置
        self.ball = [Ball ball];
        self.ball.position = CGPointMake(self.player.position.x,
                                         self.player.position.y + self.ball.size.height);;
        [self addChild:self.ball];

        // ブロック管理ノードを作成して、ブロックをシーン上に配置
        self.blocks = [BlockController controller];
        [self.blocks deployBlocksInScene:self];
    }
    return self;
}

-(void)setupScene
{
    // 背景を濃紺に設定
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

    // シーン上の物理特性を指定
    self.physicsWorld.gravity = CGVectorMake(0, 0);  // 重力ゼロ
    self.physicsWorld.contactDelegate = self; // 衝突したときに処理を行うオブジェクト

    // 物理エンジンの枠をシーンサイズと同じ場所、同じ大きさで指定
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:(CGRect){CGPointZero, self.size}];
    self.physicsBody.restitution = 1.05;
}

// フレームが更新されるたびに呼ばれる
-(void)update:(CFTimeInterval)currentTime {
    // 自機を動かす
    [self.player update:currentTime];
}

#pragma mark - ユーザー操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    // ゲーム起動直後はボールを射出
    if (self.state == GameStateStart) {
        self.state = GameStatePlaying;

        // タッチした位置でボールの向きを変える
        // ※実装時の注意：物理挙動はシーンに追加したあとで設定すること
        CGFloat vx = location.x - self.scene.size.width / 2.0;
        [self.ball.physicsBody applyForce:CGVectorMake(vx, 200)];
    }

    // タッチ中の位置で左右どちらに移動するかを決めてPlayerに設定
    PlayerDirection direction = (location.x < CGRectGetMidX(self.frame))?
        PlayerDirectionLeft:PlayerDirectionRight;
    self.player.direction = direction;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];

    // タッチ中の位置で左右どちらに移動するかを決めてPlayerに設定
    PlayerDirection direction = (location.x < CGRectGetMidX(self.frame))?
        PlayerDirectionLeft:PlayerDirectionRight;
    self.player.direction = direction;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 指を離すと止まる
    self.player.direction = PlayerDirectionStopped;
}

#pragma mark - SKPhysicsContactDelegate
-(void)didEndContact:(SKPhysicsContact *)contact
{
    // @TODO: たまに衝突した位置がCGPointZeroで届くため、その場合は無視する
    if (CGPointEqualToPoint(contact.contactPoint, CGPointZero)) {
        return;
    }

    // 衝突したことをノードに通知
    NSArray *matrix = @[@[contact.bodyA.node,contact.bodyB.node],
                        @[contact.bodyB.node,contact.bodyA.node]];
    for (NSArray *nodes in matrix) {
        SKNode<OnHitProtocol> *target = nodes[0];
        [target onHit:nodes[1]
                   at:contact.contactPoint
              impulse:contact.collisionImpulse];
    }
}

#pragma mark - OnHitProtocol
- (void)onHit:(SKNode *)node at:(CGPoint)contactPoint impulse:(CGFloat)collisionImpulse
{
    // 下端とボールがぶつかった場合はゲームオーバー
    if (contactPoint.y < 10.0 && [node isMemberOfClass:[Ball class]]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:GameOverNotification
                              object:nil
                            userInfo:nil];
    }
}

@end
