//
//  ViewController.m
//  KeyCommandSample
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *keyCommands_;
    UITextField *dummyTextField;
    __weak IBOutlet UITextView *logTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    dummyTextField = [[UITextField alloc]
                      initWithFrame:CGRectMake(0, 0, 100, 50)];
    dummyTextField.hidden = YES;
    [self.view addSubview:dummyTextField];
    dummyTextField.keyboardType = UIKeyboardTypeAlphabet;
    [dummyTextField becomeFirstResponder];

    const SEL selector = @selector(parseKeyCommand:);
    NSMutableArray *key_commands = @[].mutableCopy;

    NSMutableString *keys = @"abcdefghijklmnopqrstuvwxyz0123456789-=',./;\\[]`§!@#$%^&*()_\r\t\x20".mutableCopy;
    NSMutableArray *key_array = @[].mutableCopy;
    for (int i = 0; i < keys.length; i ++)
        [key_array addObject:[keys substringWithRange:NSMakeRange(i, 1)]];
    [key_array addObject:UIKeyInputRightArrow];
    [key_array addObject:UIKeyInputLeftArrow];
    [key_array addObject:UIKeyInputUpArrow];
    [key_array addObject:UIKeyInputDownArrow];
    [key_array addObject:UIKeyInputEscape];
    [key_array addObject:@""];

    for (int j = 0; j < 0x20; j ++)
        for (NSString *key in key_array) {
            [key_commands addObject:
             [UIKeyCommand keyCommandWithInput:key
                                 modifierFlags:(j << 16)
                                        action:selector]];
        }

    keyCommands_ = key_commands;
}

- (void)LogOutput:(NSString*)msg {
    static NSMutableArray *lines = nil;
    if (!lines) lines = @[].mutableCopy;
    [lines insertObject:msg atIndex:0];
    while (lines.count > 30) [lines removeLastObject];
    logTextView.text = [lines componentsJoinedByString:@"\n"];
}

- (NSArray*)keyCommands {
    return keyCommands_;
}

- (void)parseKeyCommand:(UIKeyCommand*)key_command {
    NSMutableString *msg = [NSMutableString stringWithFormat:@"\"%@\" ", key_command.input];
    for (int i = 0; i < key_command.input.length; i ++)
        [msg appendFormat:@"(%d) ", [key_command.input characterAtIndex:i]];
    [msg appendFormat:@"[%d] ", key_command.modifierFlags];
    if (key_command.modifierFlags & UIKeyModifierAlphaShift)
        [msg appendString:@"CapsLock "];
    if (key_command.modifierFlags & UIKeyModifierShift)
        [msg appendString:@"Shift "];
    if (key_command.modifierFlags & UIKeyModifierControl)
        [msg appendString:@"Control "];
    if (key_command.modifierFlags & UIKeyModifierAlternate)
        [msg appendString:@"Option "];
    if (key_command.modifierFlags & UIKeyModifierCommand)
        [msg appendString:@"Command "];
    if (key_command.modifierFlags & UIKeyModifierNumericPad)
        [msg appendString:@"NumLock "];
    [self LogOutput:msg];
}


@end
