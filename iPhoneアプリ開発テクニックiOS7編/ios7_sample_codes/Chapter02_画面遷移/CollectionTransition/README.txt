インプレスジャパン発行「上を目指すプログラマーのためのiPhoneアプリ開発テクニックiOS 7編」サンプルコード

【概要】
Collection Viewのレイアウト変更を画面遷移として取り扱う際のサンプルコードです。
垂直にセルを並べたレイアウトから水平にセルを並べたレイアウトへ画面遷移します。

画面遷移は、以下のタイミングで発生します。
　1. 垂直レイアウト上でセルをタップ（水平レイアウトへ遷移）
　2. 水平レイアウト上で戻るボタンをタップ（垂直レイアウトへ戻る）
　3. 垂直レイアウト上で指の幅を狭くするピンチジェスチャーを行う（水平レイアウトへ遷移）
　4. 水平レイアウト上で指の幅を広くするピンチジェスチャーを行う（垂直レイアウトへ戻る）

また、独自の中間レイアウト(TransitionLayout)を利用することで、ピンチジェスチャーによる画面遷移中に指の位置を移動させると、セルを指に合わせて移動させることができます。ジェスチャー操作のイメージは、本書図2-10（P.089）を参照してください。


【補足事項】
TransitionController.mのstartInteractiveTransition:で、UICollectionViewのstartInteractiveTransitionToCollectionViewLayout:completion:メソッドを呼びだしていますが、このcompletionブロックの引数に注意してください。

completionブロックは以下で定義されています。

	typedef void(^UICollectionViewLayoutInteractiveTransitionCompletion)(BOOL completed, BOOL finish);

本書執筆時点（2013年12月）では、引数completedが画面遷移の完了orキャンセルを示していましたが、最新バージョンではfinishが画面遷移の完了orキャンセルを示すように変更されています（サンプルコード更新2014年1月現在）。そのため、completionブロック内で画面遷移コンテキストに対して画面遷移終了を通知するには、以下のようにfinishパラメータを利用する必要があります。

	[transitionContext completeTransition:finish];

（本書参照ページ: P.084）

【実行環境】
iOS SDK : 7.0.3
Xcode : 5.0.2
iOS : 7.0以降
