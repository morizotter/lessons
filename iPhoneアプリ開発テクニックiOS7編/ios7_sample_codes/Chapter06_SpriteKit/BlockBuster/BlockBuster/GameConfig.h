//
//  GameConfig.h
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#ifndef BlockBuster_GameConfig_h
#define BlockBuster_GameConfig_h

// ゲームの状態
typedef enum {
    GameStateStart = 0,
    GameStatePlaying,
    GameStateGameOver,
    GameStateClear,
} GameState;

// ノードのタイプ（衝突判定に使う）
enum {
    NodeTypeNone   = 0,
    NodeTypePlayer = 1 << 0,
    NodeTypeBlock  = 1 << 1,
} NodeType;

// プレイヤーの移動速度（ポイント/sec）
#define PLAYER_SPEED 280

// ボールの最大移動速度
#define MAXIMUM_BALL_SPEED 400

// ゲーム状態が遷移したときの通知メッセージ
#define GameStartNotification @"GameStartNotification"
#define GameOverNotification @"GameoverNotification"
#define GameClearNotification @"GameClearNotification"
#endif
