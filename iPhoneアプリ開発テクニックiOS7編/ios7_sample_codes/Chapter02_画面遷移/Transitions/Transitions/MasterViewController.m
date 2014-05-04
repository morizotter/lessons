//
//  MasterViewController.m
//  Transitions
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 MasterViewControllerとDetailViewController間を
 カスタムまたはインタラクティブ画面遷移を利用して遷移します。
 ナビゲーションコントローラのPush-Popまたはモーダルビュー表示・
 消去に対応しています。
 
 ビューコントローラの実装方法は、
 ・2-2-4（カスタム画面遷移）
 ・2-3-3（インタラクティブ画面遷移）
 で解説
  **************************************************** */

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "SlideTransition.h"
#import "DoorTransition.h"
#import "KeyframeTransition.h"
#import "SlideInteraction.h"
#import "PanInteraction.h"

@interface MasterViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, SlideInteractionDelegate, PanInteractionDelegate>
{
    NSArray *_transitionNames;
    NSArray *_descriptions;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSString *transitionName;

@property (nonatomic, strong) SlideInteraction *slideInteraction;
@property (nonatomic, strong) PanInteraction *panInteraction;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _transitionNames = @[@"Slide",
                         @"Door",
                         @"Key-frame",
                         @"Slide-Slide Interaction",
                         @"Slide-Pan Interaction"
                         ];
    _descriptions = @[@"標準的なアニメーションコントローラ (2-2-2)",
                      @"スナップショットを利用したアニメーションコントローラ (2-2-3)",
                      @"Key-frameアニメーション(2-1-3)の使用例",
                      @"UIPercentDrivenInteractiveTransitionの利用 (2-3-1)",
                      @"一般的なインタラクションコントローラ (2-3-2)"
                      ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.navigationController.delegate = self;
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
    return _transitionNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _transitionNames[indexPath.row];
    cell.detailTextLabel.text = _descriptions[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:9.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL push = self.segmentedControl.selectedSegmentIndex == 0;
    if (push) {
        [self performSegueWithIdentifier:@"pushDetail" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"presentDetail" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSIndexPath *indexPath = (NSIndexPath *)sender;
    self.transitionName = _transitionNames[indexPath.row];
    
    /*
     モーダルビューコントローラの初期化 (P.059)
     */
    DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
    controller.transitioningDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    controller.detailItem = self.transitionName;
    
    /*
     インタラクションコントローラの生成 (P.073)
     */
    if ([self.transitionName rangeOfString:@"Slide Interaction"].location != NSNotFound) {
        self.slideInteraction = [[SlideInteraction alloc] init];
        self.slideInteraction.delegate = self;
        [self.slideInteraction setView:controller.view];
    } else {
        self.slideInteraction = nil;

        if ([self.transitionName rangeOfString:@"Pan Interaction"]. location != NSNotFound) {
            self.panInteraction = [[PanInteraction alloc] init];
            self.panInteraction.delegate = self;
            [self.panInteraction setView:controller.view];
        } else {
            self.panInteraction = nil;
        }
    }
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate
/*
 アニメーションコントローラを返すメソッド（モーダルビュー表示）
 */
- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
presentingController:(UIViewController *)presenting
sourceController:(UIViewController *)source
{
    if ([self.transitionName rangeOfString:@"Slide"].location != NSNotFound) {
        SlideTransition *transition = [[SlideTransition alloc] init];
        transition.presenting = YES;
        return transition;
    } else if ([self.transitionName isEqualToString:@"Door"]) {
        DoorTransition *transition = [[DoorTransition alloc] init];
        transition.presenting = YES;
        return transition;
    } else if ([self.transitionName isEqualToString:@"Key-frame"]){
        KeyframeTransition *transition = [[KeyframeTransition alloc] init];
        transition.presenting = YES;
        return transition;
    }
    return nil;
}


/*
 アニメーションコントローラを返すメソッド（モーダルビュー消去）
 */
- (id <UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([self.transitionName rangeOfString:@"Slide"].location != NSNotFound) {
        SlideTransition *transition = [[SlideTransition alloc] init];
        transition.presenting = NO;
        return transition;
    } else if ([self.transitionName isEqualToString:@"Door"]) {
        DoorTransition *transition = [[DoorTransition alloc] init];
        transition.presenting = NO;
        return transition;
    } else if ([self.transitionName isEqualToString:@"Key-frame"]){
        KeyframeTransition *transition = [[KeyframeTransition alloc] init];
        transition.presenting = NO;
        return transition;
    }
    return nil;
}

/*
 インタラクションコントローラを返すメソッド（モーダルビュー表示）
 */
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:
(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

/*
 インタラクションコントローラを返すメソッド（モーダルビュー消去）
 */
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:
(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.slideInteraction && self.slideInteraction.isInteractive) {
        return self.slideInteraction;
    } else if (self.panInteraction && self.panInteraction.isInteractive) {
        return self.panInteraction;
    } else {
        return nil;
    }
}

#pragma mark UINavigationControllerDelegate
/*
 アニメーションコントローラを返すメソッド（ナビゲーションコントローラ）
 */
- (id <UIViewControllerAnimatedTransitioning>)navigationController:
(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([self.transitionName rangeOfString:@"Slide"].location != NSNotFound) {
        SlideTransition *transition = [[SlideTransition alloc] init];
        transition.presenting = (operation == UINavigationControllerOperationPush);
        return transition;
    } else if ([self.transitionName isEqualToString:@"Door"]) {
        DoorTransition *transition = [[DoorTransition alloc] init];
        transition.presenting = (operation == UINavigationControllerOperationPush);
        return transition;
    } else if ([self.transitionName isEqualToString:@"Key-frame"]){
        KeyframeTransition *transition = [[KeyframeTransition alloc] init];
        transition.presenting = (operation == UINavigationControllerOperationPush);
        return transition;
    }
    return nil;
}

/*
 インタラクションコントローラを返すメソッド（ナビゲーションコントローラ）
 */
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.slideInteraction && self.slideInteraction.isInteractive) {
        return self.slideInteraction;
    } else if (self.panInteraction && self.panInteraction.isInteractive) {
        return self.panInteraction;
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark SlideInteractionDelegate, PanInteractionDelegate
- (void)interactionBeganAtPoint:(CGPoint)point
{
    if (self.presentedViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
