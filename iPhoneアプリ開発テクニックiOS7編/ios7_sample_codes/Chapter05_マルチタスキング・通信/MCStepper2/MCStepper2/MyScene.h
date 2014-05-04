//
//  MyScene.h
//  MCStepper2
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface MyScene : SKScene

@property id<MultiPeerStepperDelegate> stepDelegate;

// 画面にメッセージを表示する
-(void)addDictionary:(NSDictionary*)dic;

@end
