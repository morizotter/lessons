//
//  AttachmentViewController.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 基本behavior
 attachmentを利用したサンプル
 図3-3にある列車を引くような動作
 *********************************************** */

#import "AttachmentViewController.h"

@interface AttachmentViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@end

@implementation AttachmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *square1 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 40, 40)];
    square1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:square1];
    
    UIView *square2 = [[UIView alloc] initWithFrame:CGRectMake(70, 80, 40, 40)];
    square2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:square2];
    
    UIView *square3 = [[UIView alloc] initWithFrame:CGRectMake(130, 80, 40, 40)];
    square3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:square3];
    
    UIView *square4 = [[UIView alloc] initWithFrame:CGRectMake(190, 80, 40, 40)];
    square4.backgroundColor = [UIColor blueColor];
    [self.view addSubview:square4];
    
    UIDynamicAnimator *animator =
    [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIAttachmentBehavior *attachmentBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:square1
                              offsetFromCenter:UIOffsetMake(-15, 0)
                              attachedToAnchor:CGPointMake(5, 100)];
    
    UIAttachmentBehavior *attachmentItemsBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:square1
                              offsetFromCenter:UIOffsetMake(15, 0)
                                attachedToItem:square2
                              offsetFromCenter:UIOffsetMake(-15, 0)];
    
    UIAttachmentBehavior *attachmentItemsBehavior2 =
    [[UIAttachmentBehavior alloc] initWithItem:square2
                              offsetFromCenter:UIOffsetMake(15, 0)
                                attachedToItem:square3
                              offsetFromCenter:UIOffsetMake(-15, 0)];
    UIAttachmentBehavior *attachmentItemsBehavior3 =
    [[UIAttachmentBehavior alloc] initWithItem:square3
                              offsetFromCenter:UIOffsetMake(15, 0)
                                attachedToItem:square4 offsetFromCenter:UIOffsetMake(-15, 0)];
    
    [animator addBehavior:attachmentBehavior];
    [animator addBehavior:attachmentItemsBehavior];
    [animator addBehavior:attachmentItemsBehavior2];
    [animator addBehavior:attachmentItemsBehavior3];
    self.attachmentBehavior = attachmentBehavior;
    self.animator = animator;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               self.view.bounds.size.height - 40,
                                                               self.view.bounds.size.width - 20,
                                                               30)];
    label.text = @"画面を触り黄色いビューを引っ張ってください";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
}



@end
