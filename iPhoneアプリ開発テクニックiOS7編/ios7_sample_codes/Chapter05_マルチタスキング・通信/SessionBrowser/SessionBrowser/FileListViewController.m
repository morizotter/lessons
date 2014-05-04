//
//  FileListViewController.m
//  WebviewTEST
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "FileListViewController.h"
#import "AppDelegate.h"

@interface FileListViewController ()
@property (strong, nonatomic) NSMutableArray *downloads;
@property (strong, nonatomic) NSMutableArray *files;
@end

@implementation FileListViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated;
{
    NSLog(@"%@ -viewWillAppear:%d", NSStringFromClass(self.class), animated);
    // refresh Control の定義
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    // downloads
	AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSLog(@"downloads = %ld %@", (long)appDelegate.downloadTasks.count, appDelegate.downloadTasks);
    self.downloads = appDelegate.downloadTasks;
	[self refresh:nil];
}

#pragma mark - UIRefreshControl
- (IBAction)refresh:(id)sender {
    NSLog(@"%@ -refresh:%@", NSStringFromClass(self.class), sender);
    // files

    // show new data
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@ -numberOfSectionsInTableView:", NSStringFromClass(self.class));
    // Return the number of sections.
    NSLog(@"files=%ld, tasks=%ld", (long)self.files.count, (long)self.downloads.count);
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section ? self.files.count : self.downloads.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return section ? @"Local Files" : @"Download Tasks";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DownloadingCellIdentifier = @"DownloadingCell";
    static NSString *FilesCellIdentifier = @"FilesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section ? FilesCellIdentifier : DownloadingCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section) {	// files
        NSURL *url = [self.files objectAtIndex:indexPath.row];
        cell.textLabel.text = url.lastPathComponent;
        NSLog(@"path:%@", url.path);
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
        // Number Formatterを使ってカンマ付き数値にする
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        cell.detailTextLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:dic.fileSize]];
    }else{	// tasks
        NSURLSessionDownloadTask *task = [self.downloads objectAtIndex:indexPath.row];
        NSString *state;
        switch (task.state) {
            case NSURLSessionTaskStateRunning: state = @"Running"; break;
            case NSURLSessionTaskStateSuspended: state = @"Suspended"; break;
            case NSURLSessionTaskStateCanceling: state = @"Canceling"; break;
            case NSURLSessionTaskStateCompleted: state = @"Completed"; break;
            default: break;
        }
        cell.textLabel.text = task.currentRequest.URL.lastPathComponent;
        // Number Formatterを使ってカンマ付き数値にする
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@ [%@]", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:task.countOfBytesReceived]], [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:task.countOfBytesExpectedToReceive]], state];
    }
    return cell;
}

// 選択された
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"-tableView: didSelectRowAtIndexPath:");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {	// files
        NSURL *file = [self.files objectAtIndex:indexPath.row];
        if ([@"webloc" isEqualToString:file.pathExtension]) {
            NSLog(@"-> %@", file);
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:file];
            NSLog(@"   URL: %@", [dic objectForKey:@"URL"]);
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegate.webViewURL = [dic objectForKey:@"URL"];
        }
    }else{	// tasks
        NSURLSessionDownloadTask *task = [self.downloads objectAtIndex:indexPath.row];
        switch (task.state) {
            case NSURLSessionTaskStateRunning:
                [task suspend];
                break;
            case NSURLSessionTaskStateSuspended:
                [task resume];
                break;
            case NSURLSessionTaskStateCanceling: break;
            case NSURLSessionTaskStateCompleted: break;
            default: break;
        }
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            });
        });
    }
}

// 編集可能かどうかを判断する
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// このメソッドを実装すると左スワイプで削除ボタンを表示できる
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ -tableView: commitEditingStyle:%@ forRowAtIndexPath:%ld-%ld", NSStringFromClass(self.class), editingStyle == UITableViewCellEditingStyleDelete ? @"delete" : @"insert", (long)indexPath.section, (long)indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            // Download をキャンセルする
            NSURLSessionDownloadTask *task = [self.downloads objectAtIndex:indexPath.row];
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [appDelegate stopDownload:task];
        }else {
            // data sourceから削除する
            NSURL *deleteFile = [self.files objectAtIndex:indexPath.row];
            [self.files removeObject:deleteFile];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:deleteFile error:&error];
            NSLog(@"deletefile: %@", error);
        }
        // tableViewの表示から削除する
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
