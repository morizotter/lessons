//
//  TabDelegate.m
//  WebviewTEST
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "TabDelegate.h"
#import "FileListViewController.h"
#import "WebNavigateViewController.h"

@implementation TabDelegate

#pragma mark - UITabBarControllerDelegate
//  NS_AVAILABLE_IOS(3_0)
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
{
    NSLog(@"%@ -tabBarController: shouldSelectViewController:%@", NSStringFromClass(self.class), viewController);
    NSLog(@"from: %@ to: %@", tabBarController.selectedViewController.tabBarItem.title, viewController.tabBarItem.title);
    if (tabBarController.selectedViewController == viewController) {
        if ([viewController isKindOfClass:[WebNavigateViewController class]]) {
            NSLog(@"webview reload");
            WebNavigateViewController *webController = (WebNavigateViewController*)viewController;
            [webController goBack];
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    NSLog(@"%@ -tabBarController: didSelectViewController:%@", NSStringFromClass(self.class), viewController);
}

//  NS_AVAILABLE_IOS(3_0)
- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers;
{
    NSLog(@"%@ -tabBarController: willBeginCustomizingViewControllers:%@", NSStringFromClass(self.class), viewControllers);
    
}

//  NS_AVAILABLE_IOS(3_0)
- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
{
    NSLog(@"%@ -tabBarController: willEndCustomizingViewControllers:%@ changed:%d", NSStringFromClass(self.class), viewControllers, changed);
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
{
    NSLog(@"%@ -tabBarController: didEndCustomizingViewControllers:%@ changed:%d", NSStringFromClass(self.class), viewControllers, changed);
    
}

//  NS_AVAILABLE_IOS(7_0)
- (NSUInteger)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController;
{
    NSLog(@"%@ -tabBarControllerSupportedInterfaceOrientations:", NSStringFromClass(self.class));
    return UIInterfaceOrientationMaskPortrait;
}

//  NS_AVAILABLE_IOS(7_0)
- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController;
{
    NSLog(@"%@ -tabBarControllerPreferredInterfaceOrientationForPresentation:", NSStringFromClass(self.class));
    return UIInterfaceOrientationPortrait;
}

////  NS_AVAILABLE_IOS(7_0)
//- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController;
//{
//    
//}

//// NS_AVAILABLE_IOS(7_0);
//- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
//{
//    
//}

#pragma mark - UITabBarDelegate
// called when a new view is selected by the user (but not programatically)
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;
{
    NSLog(@"%@ -tabBar: didSelectItem:%@", NSStringFromClass(self.class), item);

}

// called before customize sheet is shown. items is current item list
- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items;
{
    NSLog(@"%@ -tabBar: willBeginCustomizingItems:%@", NSStringFromClass(self.class), items);
    
}

// called after customize sheet is shown. items is current item list
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items;
{
    NSLog(@"%@ -tabBar: didBeginCustomizingItems:%@", NSStringFromClass(self.class), items);
    
}

// called before customize sheet is hidden. items is new item list
- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;
{
    NSLog(@"%@ -tabBar: willEndCustomizingItems:%@ changed:%d", NSStringFromClass(self.class), items, changed);
    
}

// called after customize sheet is hidden. items is new item list
- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed;
{
    NSLog(@"%@ -tabBar: didEndCustomizingItems:%@ changed:%d", NSStringFromClass(self.class), items, changed);
    
}

@end
