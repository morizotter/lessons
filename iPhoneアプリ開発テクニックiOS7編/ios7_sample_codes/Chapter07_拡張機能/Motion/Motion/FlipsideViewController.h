//
//  FlipsideViewController.h
//  Motion
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;


- (IBAction)done:(id)sender;

@end
