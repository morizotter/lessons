//
//  CacheListViewController.m
//  WebviewTEST
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "CacheListViewController.h"
#import "AppDelegate.h"

@interface CacheListViewController ()
@property (strong, nonatomic) NSMutableArray *files;
@end

@implementation CacheListViewController

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
    [self refresh:nil];
}

#pragma mark - UIRefreshControl
- (IBAction)refresh:(id)sender {
    NSLog(@"%@ -refresh:%@", NSStringFromClass(self.class), sender);
    // files
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cacheDirectory = [URLs objectAtIndex:0];
    NSURL *filesDirectory = [cacheDirectory URLByAppendingPathComponent:@"com.apple.nsnetworkd" isDirectory:YES];
    NSLog(@"path = %@", filesDirectory);
    NSError *error;
    self.files = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtURL:filesDirectory includingPropertiesForKeys:nil options:0 error:&error]];
    NSLog(@"caches: %@", self.files);
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.files.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return @"Cache Files";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSURL *url = [self.files objectAtIndex:indexPath.row];
    cell.textLabel.text = url.path.lastPathComponent;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    cell.detailTextLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:dic.fileSize]];
    return cell;
}

// 選択された
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"-tableView: didSelectRowAtIndexPath:");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        // Delete the row from the data source
        NSURL *deleteFile = [self.files objectAtIndex:indexPath.row];
        [self.files removeObject:deleteFile];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:deleteFile error:&error];
        NSLog(@"deletefile: %@", error);
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

#pragma mark -
- (IBAction)cancelAction:(id)sender {
    NSLog(@"%@ -cancelAction:", NSStringFromClass(self.class));
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate cancel:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
@end
