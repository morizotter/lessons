//
//  ViewController.m
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"
#import "DynamicLayout.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation ViewController {
    NSInteger _numOfItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.panGestureRecognizer];
    
    _numOfItems = 6;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

#pragma mark actions
- (IBAction)addItem:(id)sender
{
    _numOfItems++;
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numOfItems-1 inSection:0]]];
}

#pragma mark gesture handler (P.114)
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.collectionView];
    DynamicLayout *layout = (DynamicLayout *)self.collectionView.collectionViewLayout;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pt];
            if (indexPath != nil) {
                // セルのドラッグを開始する
                [layout startDragItemAtIndexPath:indexPath atPoint:pt];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
            [layout updateDragPoint:pt]; // ドラッグ位置更新
            break;
        case UIGestureRecognizerStateEnded: // ドラッグ終了
            [layout endDrag];
            break;
        default:
            break;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        //
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        return (indexPath != nil);
    }
    return YES;
}

- (void)didEnterBackground:(NSNotification*)notification
{
    DynamicLayout *layout = (DynamicLayout *)self.collectionView.collectionViewLayout;
    [layout endDrag];
}

@end
