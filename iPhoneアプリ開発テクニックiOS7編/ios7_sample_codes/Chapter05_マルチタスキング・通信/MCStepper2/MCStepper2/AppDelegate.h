//
//  AppDelegate.h
//  MCStepper2
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@protocol MultiPeerStepperDelegate<NSObject>
-(void)sendDictionary:(NSDictionary*)dic;
-(void)recvDictionary:(NSDictionary*)dic;
@end

@class MCSession;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MCSession *session;
@property NSString *serviceType;
@property id<MultiPeerStepperDelegate> stepDelegate;

@end
