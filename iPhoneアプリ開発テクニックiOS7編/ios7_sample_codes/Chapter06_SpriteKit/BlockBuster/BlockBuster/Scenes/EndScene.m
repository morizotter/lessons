//
//  EndScene.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "EndScene.h"
#import "PlayScene.h"
#import "GameConfig.h"

@interface EndScene ()
@property (nonatomic, assign)GameState state;
@end
@implementation EndScene

+(instancetype)sceneWithSize:(CGSize)size state:(GameState)state
{
    EndScene *me = [EndScene sceneWithSize:size];
    me.state = state;
    return me;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // 画面をタップするラベルを表示
        SKLabelNode *operation = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        operation.text = @"Tap screen to restart.";
        operation.fontSize = 17;
        operation.position = CGPointMake(CGRectGetMidX(self.frame),
                                         CGRectGetMidY(self.frame)-50);
        [self addChild:operation];

        // 明滅を繰り返すアクションを構築・開始
        SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.0];
        SKAction *blink = [SKAction sequence:@[fadeOut, fadeIn]];
        [operation runAction:[SKAction repeatActionForever:blink]];
    }
    return self;
}

-(void)showTitle
{
    // ゲーム状態に応じたタイトルを表示
    NSString *title = @"Invalid state";
    switch (self.state) {
        case GameStateClear:
            title = @"C L E A R !!";
            break;
        case GameStateGameOver:
            title = @"Game Over ...";
            break;
        default:
            break;
    }

    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.text = title;
    titleLabel.fontSize = 38;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
    titleLabel.name = @"title";
    [self addChild:titleLabel];

}

-(void)setState:(GameState)state
{
    _state = state;
    [self showTitle];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ゲーム再開
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GameStartNotification
                          object:nil
                        userInfo:nil];
}

@end
