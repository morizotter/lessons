インプレスジャパン発行「上を目指すプログラマーのためのiPhoneアプリ開発テクニックiOS 7編」サンプルコード

【概要】
サイレントプッシュ通知のサンプルのサーバ側(Google App Engine)です。

【補足事項】
apns.py, cert.pem, key.pemを準備し、main.pyにiOSデバイスのデバイストークンを書いた上でGoogle App Engineにアップロードするとサイレントプッシュ通知の準備ができます。

詳しくは5-4 サイレントプッシュ通知(P.210)をお読み下さい。

【実行環境】
以下の環境で動作を確認しています。

iOS SDK：7.0.3
Xcode：5.0.2
iOS：7.0以降
