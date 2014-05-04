//
//  MasterViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "MasterViewController.h"

@interface MasterViewController () {
    NSArray *_behaviors;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _behaviors = @[@"Gravity",
                   @"Gravity+Collision",
                   @"Collision",
                   @"Snap",
                   @"Push",
                   @"Attachment",
                   @"Magnet"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _behaviors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = _behaviors[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *behavior = _behaviors[indexPath.row];
    NSString *name = [behavior stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *className = [NSString stringWithFormat:@"%@ViewController", name];
    UIViewController *controller = [[NSClassFromString(className) alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}


@end
