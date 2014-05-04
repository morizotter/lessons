//
//  HistoryViewController.m
//  BattChecker
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property NSArray *logArray;	// ログファイルから読み込んだ文字列

@end

@implementation HistoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ログファイルを読み込む
    [self loadData];
    // アプリがアクティブになったら読み込み直す
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self loadData];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)loadData;
{
    NSLog(@"load data");
    // ログを読み込む
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *logURL = [documentsDirectory URLByAppendingPathComponent:@"fetchlog.txt"];
    // ファイルオープン
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:logURL options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return;
    }
    // 文字列配列に変換してプロパティに保持する
    NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *logArray = [logString componentsSeparatedByString:@"\n"];
    self.logArray = logArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *string = [self.logArray objectAtIndex:indexPath.row];
    NSArray *lineArray = [string componentsSeparatedByString:@" "];
    if (lineArray.count > 1) {
        cell.textLabel.text = (NSString*)[lineArray objectAtIndex:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", [lineArray objectAtIndex:6]];
    }else{
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

@end
