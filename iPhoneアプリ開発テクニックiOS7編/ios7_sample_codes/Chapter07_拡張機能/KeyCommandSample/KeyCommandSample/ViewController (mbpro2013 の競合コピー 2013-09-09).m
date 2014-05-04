//
//  ViewController.m
//  KeyCommandSample
//
//  Created by sakira on 2013/09/04.
//  Copyright (c) 2013年 sakira. All rights reserved.
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
  
  NSArray *key_modifier_array =
  @[
    /*
    @[UIKeyInputUpArrow, @(UIKeyModifierControl)],
    @[@"a", @(UIKeyModifierCommand)],
    @[UIKeyInputEscape, @0],
    @[UIKeyInputUpArrow, @0],
    @[UIKeyInputDownArrow, @0],
    @[UIKeyInputLeftArrow, @0],
    @[UIKeyInputRightArrow, @0],
    @[@"", @(UIKeyModifierCommand)],
    @[@"", @(UIKeyModifierShift)],
    @[@"", @(UIKeyModifierControl)],
    @[@"", @(UIKeyModifierAlternate)],
    @[@"", @(UIKeyModifierAlphaShift)],
    @[@"a", @(UIKeyModifierAlphaShift)],
    @[@"", @(UIKeyModifierControl|UIKeyModifierCommand)],
    @[@"a", @0],
    @[@" ", @0],
     */
    @[@"bc", @0]
    ];
  
  const SEL selector = @selector(parseKeyCommand:);
  NSMutableArray *key_commands = @[].mutableCopy;

  for (NSArray* k_m in key_modifier_array) {
    NSString* key = k_m[0];
    NSNumber* mod = k_m[1];
    [key_commands addObject:
     [UIKeyCommand keyCommandWithInput:key
                         modifierFlags:mod.intValue
                                action:selector]];
  }
  UIKeyCommand *key_command =
  [UIKeyCommand
   keyCommandWithInput:@"a"
   modifierFlags:(UIKeyModifierCommand|
                  UIKeyModifierControl)
   action:@selector(parseCommandControlA:)];
  key_commands[0] = key_command;
  
  NSMutableString *keys = @"abcdefghijklmnopqrstuvwxyz0123456789-=',./;\\[]`§!@#$%^&*()_\r\t ".mutableCopy;
  NSMutableArray *key_array = @[].mutableCopy;
  for (int i = 0; i < keys.length; i ++)
    [key_array addObject:[keys substringWithRange:NSMakeRange(i, 1)]];
  [key_array addObject:UIKeyInputRightArrow];
  [key_array addObject:UIKeyInputLeftArrow];
  [key_array addObject:UIKeyInputUpArrow];
  [key_array addObject:UIKeyInputDownArrow];
  [key_array addObject:UIKeyInputEscape];
  [key_array addObject:@""];
  
  for (NSString *key in key_array) {
    for (int j = 0; j < 0x20; j ++)
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

- (void)parseCommandControlA:(UIKeyCommand*)key_cmd {
  NSLog(@"command control A");
  [self LogOutput:@"command control A"];
}


@end
