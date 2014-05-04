//
//  FlipsideViewController.m
//  Motion
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "FlipsideViewController.h"

#import <CoreMotion/CoreMotion.h>

@interface FlipsideViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FlipsideViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    CMMotionActivityManager *activityManager = [[CMMotionActivityManager alloc] init];
    [activityManager queryActivityStartingFromDate:self.startDate
                                            toDate:self.endDate
                                           toQueue:[NSOperationQueue mainQueue]
                                       withHandler:^(NSArray *activities, NSError *error){
                                           if (error == nil) {
                                               self.activities = activities;
                                               [self.tableView reloadData];
                                           }
                                       }];
  

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
    [stepCounter queryStepCountStartingFrom:self.startDate
                                         to:self.endDate
                                    toQueue:[NSOperationQueue mainQueue]
                                withHandler:^(NSInteger numberOfSteps, NSError *error){
                                    NSString *message;
                                    if (error == nil) {
                                        message = [NSString stringWithFormat:@"これまでに%ld歩歩きました。", (long)numberOfSteps];
                                    } else {
                                        message = [NSString stringWithFormat:@"エラー: %@", error];
                                    }
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"歩数計測"
                                                                                    message:message
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CMMotionActivity *activity = self.activities[indexPath.row];
    NSString *activityStr = [NSString stringWithFormat:@"%@%@",
                             (activity.unknown ? @"Unknown" :
                              activity.walking ? @"Walking" :
                              activity.running ? @"Running" :
                              activity.automotive ? @"Automotive" : @"---"),
                             (activity.stationary ? @" (s)" : @"")];
    NSString *confidenceStr = [NSString stringWithFormat:@"%@",
                               activity.confidence == CMMotionActivityConfidenceHigh ? @"High" :
                               activity.confidence == CMMotionActivityConfidenceMedium ? @"Medium" :
                               activity.confidence == CMMotionActivityConfidenceLow ? @"Low" : @"-"];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]",
                           activityStr, confidenceStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [self.dateFormatter stringFromDate:activity.startDate]];

    return cell;
}

@end
