//
//  ViewController.m
//  AnimationController
//
//  Created by MORITA NAOKI on 2014/05/04.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "ViewController.h"
#import "SlideTransition.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SlideTransition *transition = [[SlideTransition alloc] init];
    transition.presenting = YES;
    return transition;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed {
    SlideTransition *transition = [[SlideTransition alloc] init];
    transition.presenting = NO;
    return transition;
}

- (IBAction)backToViewControler:(UIStoryboardSegue *)segue {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *mvc = segue.destinationViewController;
    mvc.transitioningDelegate = self;
    mvc.modalPresentationStyle = UIModalPresentationFullScreen;
}

@end
