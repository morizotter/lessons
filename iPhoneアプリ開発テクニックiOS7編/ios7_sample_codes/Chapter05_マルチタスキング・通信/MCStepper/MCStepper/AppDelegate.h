//
//  AppDelegate.h
//  MCStepper
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;


#define SERVICE_TYPE @"MCStepper"

@protocol MultiPeerStepperDelegate<NSObject>
-(void)sendDictionary:(NSDictionary*)dic;
-(void)recvDictionary:(NSDictionary*)dic;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MCSession *session;
@property NSString *serviceType;
@property id<MultiPeerStepperDelegate> stepDelegate;

@end
