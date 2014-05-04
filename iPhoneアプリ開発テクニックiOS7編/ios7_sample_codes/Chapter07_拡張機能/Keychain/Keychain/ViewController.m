//
//  ViewController.m
//  Keychain
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"

static NSDictionary *QueryKey = nil;

@interface ViewController ()
@end

@implementation ViewController {
    IBOutlet __weak UITextView *logView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!QueryKey)
        QueryKey = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                     (__bridge id)kSecAttrSynchronizable : @YES,
                     (__bridge id)kSecAttrAccount : @"iOS7Test"};
}

- (void)addMessage:(NSString*)msg {
    static NSMutableArray *lines = nil;
    if (!lines) lines = @[].mutableCopy;
    while (lines.count > 30) [lines removeLastObject];
    [lines insertObject:msg atIndex:0];
    logView.text = [lines componentsJoinedByString:@"\n"];
}

+ (NSData*)readKey {
    NSMutableDictionary *query = QueryKey.mutableCopy;
    query[(__bridge id)kSecReturnData] = @YES;
    CFTypeRef dataRef = nil;
    OSStatus status =
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataRef);
    NSData* data = (NSData*)CFBridgingRelease(dataRef);
    if (status == noErr) {
        return data;
    } else {
        NSLog(@"readKey error %d", (int)status);
        return nil;
    }
}

+ (void)writeKey {
    NSData *keyData = [[[NSDate date] description]
                       dataUsingEncoding:NSUTF8StringEncoding];
    if ([self.class readKey]) {
        NSDictionary *update = @{(__bridge id)kSecValueData : keyData};
        OSStatus stat =
        SecItemUpdate((__bridge CFDictionaryRef)QueryKey,
                      (__bridge CFDictionaryRef)update);
        NSLog(@"key update status %d", (int)stat);
    } else {
        NSMutableDictionary *query = QueryKey.mutableCopy;
        query[(__bridge id)kSecValueData] = keyData;
        OSStatus stat =
        SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        NSLog(@"key add status %d", (int)stat);
    }
}

+ (void)deleteKey {
    SecItemDelete((__bridge CFDictionaryRef)QueryKey);
}

- (IBAction)writeButtonPressed:(id)sender {
    [self addMessage:@"write"];
    [self.class writeKey];
}

- (IBAction)readButtonPressed:(id)sender {
    [self addMessage:@"read"];
    NSData *data = [self.class readKey];
    NSString *msg = [[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding];
    [self addMessage:msg];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self addMessage:@"delete"];
    [self.class deleteKey];
}

@end
