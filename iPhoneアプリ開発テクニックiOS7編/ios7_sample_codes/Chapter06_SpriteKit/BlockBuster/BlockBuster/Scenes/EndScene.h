//
//  EndScene.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//
//  クリアー・ゲームオーバー用画面
#import <SpriteKit/SpriteKit.h>
#include "GameConfig.h"

@interface EndScene : SKScene
+(instancetype)sceneWithSize:(CGSize)size state:(GameState)state;
@end
