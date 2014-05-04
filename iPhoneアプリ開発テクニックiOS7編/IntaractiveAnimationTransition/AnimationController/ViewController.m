//
//  ViewController.m
//  AnimationController
//
//  Created by MORITA NAOKI on 2014/05/04.
//  Copyright (c) 2014年 molabo. All rights reserved.
//

#import "ViewController.h"
#import "SlideTransition.h"
#import "SlideInteraction.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate,SlideInteractionDelegate>
@property (strong, nonatomic) SlideInteraction *slideInteraction;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

#pragma mark - modal view controller
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

#pragma mark - navigation controller
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    SlideTransition *transition = [[SlideTransition alloc] init];
    transition.presenting = (operation == UINavigationControllerOperationPush);
    return transition;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  
    if (self.slideInteraction && self.slideInteraction.isInteractive) {
        return self.slideInteraction;
    } else {
		return nil;
	}
}

- (void)interactionBeganAtPoint:(CGPoint)point {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modal1"]) {
        UIViewController *mvc = segue.destinationViewController;
        mvc.transitioningDelegate = self;
        mvc.modalPresentationStyle = UIModalPresentationFullScreen;
    } else if ([segue.identifier isEqualToString:@"push1"]) {
        UIViewController *pvc = segue.destinationViewController;
        pvc.transitioningDelegate = self;
        pvc.modalPresentationStyle = UIModalPresentationFullScreen;
        self.slideInteraction = [[SlideInteraction alloc] init];
        self.slideInteraction.delegate = self;
        [self.slideInteraction setView:pvc.view];
    }
}

- (IBAction)backToViewControler:(UIStoryboardSegue *)segue {
    
}

@end
