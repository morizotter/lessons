//
//  TitleScene.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "TitleScene.h"
#import "GameConfig.h"
#import "PlayScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // タイトル画面を表示
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        // タイトル文字を表示
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Block Buster";
        myLabel.fontSize = 34;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        [self addChild:myLabel];

        // 画面をタップするラベルを表示
        SKLabelNode *operation = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        operation.text = @"Tap screen to start.";
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // ゲーム開始
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GameStartNotification
                          object:nil
                        userInfo:nil];
}

@end
