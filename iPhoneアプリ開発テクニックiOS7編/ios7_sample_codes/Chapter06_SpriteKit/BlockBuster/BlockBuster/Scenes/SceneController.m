//
//  SceneController.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "SceneController.h"
#import "GameConfig.h"
#import "TitleScene.h"
#import "PlayScene.h"
#import "EndScene.h"

@implementation SceneController

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

        [center addObserver:self
                   selector:@selector(receiveStart:)
                       name:GameStartNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(receiveClear:)
                       name:GameClearNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(receiveGameover:)
                       name:GameOverNotification
                     object:nil];
    }
    return self;
}

-(void)receiveStart:(NSNotification *)notify
{
    // プレイ用シーンを作成
    SKScene *scene = [PlayScene sceneWithSize:self.view.bounds.size];
    [self transitToScene:scene];
}

-(void)receiveClear:(NSNotification *)notify
{
    // クリアー用シーンを作成
    SKScene *scene = [EndScene sceneWithSize:self.view.bounds.size
                                       state:GameStateClear];
    // 爆発のエフェクトを待ってから遷移
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self transitToScene:scene];
    });
}

-(void)receiveGameover:(NSNotification *)notify
{
    // ゲームオーバー用シーンを作成
    SKScene *scene = [EndScene sceneWithSize:self.view.bounds.size
                                       state:GameStateGameOver];
    [self transitToScene:scene];
}

-(void)transitToScene:(SKScene *)newScene
{
    newScene.scaleMode = SKSceneScaleModeAspectFill;

    // 新しいシーンに切り替え
    SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionDown
                                                        duration:1.0];
    [self.view presentScene:newScene transition:transition];
}
@end
