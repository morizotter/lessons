//
//  ViewController.m
//  iCloudSample
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"
@import CoreData;
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSManagedObjectContext *managedObjectContext;
    IBOutlet __weak UITextView *logView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupManagedObjectContext];
}

- (void)addMessage:(NSString*)msg {
    static NSMutableArray *lines = nil;
    if (!lines) lines = @[].mutableCopy;
    while (lines.count > 30) [lines removeLastObject];
    [lines insertObject:msg atIndex:0];
    logView.text = [lines componentsJoinedByString:@"\n"];
}

+ (NSURL*)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"UserModel" withExtension:@"momd"];
}

+ (NSURL*)storeURL {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSURL fileURLWithPath:[[dirs lastObject]
                                   stringByAppendingPathComponent:@"UserModel.sqlite"]];
}

+ (NSString*)localDateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone localTimeZone];
    format.dateFormat = @"MM月dd日 HH時mm分ss.SSSS秒";
    return [format stringFromDate:[NSDate date]];
}

- (void)setupManagedObjectContext {
    NSManagedObjectModel *model =
    [[NSManagedObjectModel alloc]
     initWithContentsOfURL:[self.class modelURL]];
    NSPersistentStoreCoordinator *coordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(icloudDidImportContentChanges:)
     name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
     object:coordinator];  // ★

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *options =
        @{NSMigratePersistentStoresAutomaticallyOption: @YES,
          NSInferMappingModelAutomaticallyOption: @YES}.mutableCopy;  // 1.
        NSURL *url = [[NSFileManager
                       defaultManager]
                      URLForUbiquityContainerIdentifier:nil];  // ★ 2.
        if (url) { // iCloud is enabled
            options[NSPersistentStoreUbiquitousContentNameKey] = @"UserModel";
            options[NSPersistentStoreUbiquitousContentURLKey] = @"data";
        }  // ★ 3.
        NSError *err = nil;
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                  configuration:nil
                                            URL:[self.class storeURL]
                                        options:options
                                          error:&err];  // 4.
        NSLog(@"setupManagedObjectContext error:%@", err);

        managedObjectContext =
        [[NSManagedObjectContext alloc]
         initWithConcurrencyType:NSMainQueueConcurrencyType];  // 5.
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    });
}

- (void)writeData {
    User *user =
    (User*)[NSEntityDescription
            insertNewObjectForEntityForName:@"User"
            inManagedObjectContext:managedObjectContext];  // 1.
    user.username = [self.class localDateString];  // 2.

    NSError *err = nil;
    if (![managedObjectContext save:&err])
        NSLog(@"writeData error:%@", err);  // 3.

    [self addMessage:@"write"];
}

- (void)readData {
    NSFetchRequest *request =
    [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"username" ascending:NO];
    [request setSortDescriptors:@[sort]];  // 1.
    NSError *error = nil;
    NSArray *result =
    [managedObjectContext executeFetchRequest:request
                                        error:&error];  // 2.
    if (result.count && !error) {
        User *obj = (User*)result[0];  // 3.
        NSLog(@"num %d username is %@", (int)result.count, obj.username);
        [self addMessage:[NSString stringWithFormat:@"read %@", obj.username]];
    } else {
        NSLog(@"dataReadButtonPressed error:%@", error);
    }
}

- (void)icloudDidImportContentChanges:(NSNotification*)noti {
    NSLog(@"did import content");
    [managedObjectContext performBlock:^{  // 1.
        [managedObjectContext
         mergeChangesFromContextDidSaveNotification:noti];  // ★ 2.
        NSError *error = nil;
        if (![managedObjectContext save:&error])
            NSLog(@"error in icloudDidImportContentChanges %@", error); // 3.
    }];
}

- (IBAction)dataWriteButtonPressed:(id)sender {
    [self writeData];
}

- (IBAction)dataReadButtonPressed:(id)sender {
    [self readData];
}

@end
