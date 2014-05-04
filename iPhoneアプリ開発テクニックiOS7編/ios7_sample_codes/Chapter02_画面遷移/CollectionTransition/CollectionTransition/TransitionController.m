//
//  TransitionController.m
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//
// -----------------------------------------------------
// Collection Viewのレイアウト変更に対応した画面遷移コントローラ
// ピンチジェスチャーでプッシュ、ポップ動作が可能
// -----------------------------------------------------

#import "TransitionController.h"
#import "TransitionLayout.h"

@interface TransitionController ()
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) TransitionLayout *transitionLayout;
@property (nonatomic) CGFloat initialPinchDistance;
@property (nonatomic) CGPoint initialPinchPoint;
@end

@implementation TransitionController

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self) {
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handlePinch:)];
        [collectionView addGestureRecognizer:pinchGesture];
        _collectionView = collectionView;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

#pragma mark - UIViewControllerInteractiveTransitioning
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // コンテキストを保存
    self.transitionContext = transitionContext;
    
    // 遷移元、遷移先のビューコントローラを取得
    UICollectionViewController *fromCVC = (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCVC = (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 遷移先のビューをコンテナビューに追加
    [[transitionContext containerView] addSubview:toCVC.view];
    
    // 画面遷移アニメーション開始
    __weak TransitionController *weakSelf = self;
    self.transitionLayout =
    (TransitionLayout *)[fromCVC.collectionView startInteractiveTransitionToCollectionViewLayout:toCVC.collectionViewLayout
                                                                                      completion:^(BOOL completed, BOOL finish){
                                                                                          // 画面遷移コンテキストに対して画面遷移終了を通知
                                                                                          // finishの値がYESのとき画面遷移は完了、NOのとき画面遷移はキャンセル
                                                                                          NSLog(@"completed:%d, finish:%d", completed, finish);
                                                                                          [transitionContext completeTransition:finish];
                                                                                          
                                                                                          weakSelf.transitionLayout = nil;
                                                                                          weakSelf.transitionContext = nil;
                                                                                      }];
}

#pragma mark - private methods

// 画面遷移進捗の更新
- (void)updateInteractiveTransition:(CGFloat)progress
{
    if (self.transitionContext == nil) return;

    [self.transitionLayout setTransitionProgress:progress];
    [self.transitionLayout invalidateLayout];
    [self.transitionContext updateInteractiveTransition:progress];
}

// 独自の中間レイアウト（TransitionLayout）を利用するときはこちらのメソッドを使う（2-4-3 P.086以降）
- (void)updateInteractiveTransition:(CGFloat)progress withTranslate:(CGPoint)translate
{
    if (self.transitionContext == nil) return;
    
    [self.transitionLayout setTranslate:translate];
    [self updateInteractiveTransition:progress];
}

// インタラクティブ画面遷移完了
- (void)finishInteractiveTransition
{
    if (self.transitionContext == nil) return;
    
    [self.collectionView finishInteractiveTransition];
    [self.transitionContext finishInteractiveTransition];
}

// インタラクティブ画面遷移キャンセル
- (void)cancelInteractiveTransition
{
    if (self.transitionContext == nil) return;

    [self.collectionView cancelInteractiveTransition];
    [self.transitionContext cancelInteractiveTransition];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture
{
    if ([self.transitionContext transitionWasCancelled]) return;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (gesture.numberOfTouches < 2) break;
            CGPoint point1 = [gesture locationOfTouch:0 inView:gesture.view];
            CGPoint point2 = [gesture locationOfTouch:1 inView:gesture.view];
            CGFloat distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
            CGPoint point = [gesture locationInView:gesture.view];

            // 初期位置と距離を保存
            self.initialPinchDistance = distance;
            self.initialPinchPoint = point;

            self.interactive = YES;
            [self.delegate interactionBeganAtPoint:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (gesture.numberOfTouches < 2) {
                NSLog(@"numberOfTouches is less than 2. transition will be cancelled.");
                [self cancelInteractiveTransition];
                self.interactive = NO;
                break;
            }
            CGPoint point1 = [gesture locationOfTouch:0 inView:gesture.view];
            CGPoint point2 = [gesture locationOfTouch:1 inView:gesture.view];
            CGFloat distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
            
            CGFloat distanceDelta = distance - self.initialPinchDistance;
            if (self.operation == UINavigationControllerOperationPush) {
                distanceDelta = -distanceDelta;
            }
            CGFloat width = self.collectionView.bounds.size.width;
            CGFloat height = self.collectionView.bounds.size.height;
            CGFloat dimension = sqrt(width * width + height * height);
            CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);

            // 独自の画面遷移レイアウトTransitionLayoutを利用する場合
            // TransitionLayoutを利用しない場合には、[self uppdateInteraction:progress];を呼ぶ
            CGPoint point = [gesture locationInView:gesture.view];
            CGPoint translate = CGPointMake(point.x - self.initialPinchPoint.x, point.y - self.initialPinchPoint.y);
            [self updateInteractiveTransition:progress withTranslate:translate];

            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGFloat velocity = [gesture velocity];
            if ((self.operation == UINavigationControllerOperationPush && velocity <= 0) ||
                (self.operation == UINavigationControllerOperationPop && velocity >= 0)) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            self.interactive = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self cancelInteractiveTransition];
            self.interactive = NO;
            break;
        default:
            break;
    }

}
@end
