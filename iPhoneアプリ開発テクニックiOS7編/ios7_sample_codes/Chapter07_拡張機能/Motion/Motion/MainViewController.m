//
//  MainViewController.m
//  Motion
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "MainViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *confidenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDateLabel;

@property (nonatomic, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, strong) CMStepCounter *stepCounter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation MainViewController

- (CMStepCounter *)stepCounter
{
    if (_stepCounter == nil) {
        _stepCounter = [[CMStepCounter alloc] init];
    }
    return _stepCounter;
}

- (CMMotionActivityManager *)activityManager
{
    if (_activityManager == nil) {
        _activityManager = [[CMMotionActivityManager alloc] init];
    }
    return _activityManager;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([self checkAvailability]) {
        [self checkAuthenticationAndStartUpdating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setStartDate:self.startedDate];
        [[segue destinationViewController] setEndDate:[NSDate date]];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showAlternate"]) {
        return (self.startedDate != nil);
    }
    return YES;
}

#pragma mark -
#pragma mark Core Motion
- (BOOL)checkAvailability
{
    if (!([CMStepCounter class] &&
          [CMMotionActivityManager class])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"動作環境確認"
                                                        message:@"\"Motion\"はiOS 7またはそれ以上のOSを必要とします。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    NSString *unsupportedFunction = nil;
    if (![CMStepCounter isStepCountingAvailable]) {
        unsupportedFunction = @"歩数計測";
    }
    if (![CMMotionActivityManager isActivityAvailable]) {
        if (unsupportedFunction != nil) {
            unsupportedFunction = [unsupportedFunction stringByAppendingString:@"と"];
        }
        unsupportedFunction = [unsupportedFunction stringByAppendingString:@"モーショントラッキング"];
    }
    
    if (unsupportedFunction != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"動作環境"
                                                        message:[NSString stringWithFormat:@"このデバイスは%@をサポートしていません。", unsupportedFunction]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)checkAuthenticationAndStartUpdating
{
    [self.activityManager queryActivityStartingFromDate:[NSDate date]
                                                 toDate:[NSDate date]
                                                toQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(NSArray *activities, NSError *error){
                                                // モーションアクティビティのプライバシー設定は、アクセス許可の状態を
                                                // 取得する方法が用意されていないため、errorを見て設定状態を判断する
                                                if (error != nil &&
                                                    error.code == CMErrorMotionActivityNotAuthorized) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"プライバシー設定"
                                                                                                    message:@"モーションアクティビティへのアクセスが許可されていません。プライバシー設定を確認してください。"
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:@"OK"
                                                                                          otherButtonTitles: nil];
                                                    [alert show];
                                                } else {
                                                    [self startStepCounting];
                                                    [self startMotionActivityUpdating];
                                                }
                                            }];
}

- (void)startStepCounting
{
    CMStepUpdateHandler stepUpdateHandler = ^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error){
       
        self.stepLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfSteps];
        if (numberOfSteps == 0) {
            self.startDateLabel.text = [self.dateFormatter stringFromDate:timestamp];
            self.startedDate = timestamp;
        }
        if (error != nil) {
            NSLog(@"%@", error);
        }
    };
    
    [self.stepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                             updateOn:1
                                          withHandler:stepUpdateHandler];
}

- (void)startMotionActivityUpdating
{
    CMMotionActivityHandler activityUpdateHandler = ^(CMMotionActivity *activity){
        
        self.activityLabel.text = [NSString stringWithFormat:@"%@%@",
                                   (activity.unknown ? @"Unknown" :
                                    activity.walking ? @"Walking" :
                                    activity.running ? @"Running" :
                                    activity.automotive ? @"Automotive" : @"---"),
                                   (activity.stationary ? @" (s)" : @"")];
        self.confidenceLabel.text = [NSString stringWithFormat:@"Confidence: %@",
                                     activity.confidence == CMMotionActivityConfidenceHigh ? @"High" :
                                     activity.confidence == CMMotionActivityConfidenceMedium ? @"Medium" :
                                     activity.confidence == CMMotionActivityConfidenceLow ? @"Low" : @"-"];
        self.activityDateLabel.text = [self.dateFormatter stringFromDate:activity.startDate];
    };
    
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                          withHandler:activityUpdateHandler];
}


@end
