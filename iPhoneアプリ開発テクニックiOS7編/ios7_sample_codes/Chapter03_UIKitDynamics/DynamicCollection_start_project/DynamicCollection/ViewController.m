//
//  ViewController.m
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"

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
}

#pragma mark gesture handler (P.114)
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        // ドラッグ開始位置にセルが存在する場合のみジェスチャーの検出を開始する
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        return (indexPath != nil);
    }
    return YES;
}

@end
