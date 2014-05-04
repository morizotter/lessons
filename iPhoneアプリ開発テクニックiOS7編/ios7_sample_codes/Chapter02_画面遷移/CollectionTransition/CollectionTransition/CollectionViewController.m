//
//  CollectionViewController.m
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "TransitionLayout.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor darkGrayColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:[CollectionViewCell cellIdentifier]];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[CollectionViewCell cellIdentifier] forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    return cell;
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *layout = [[TransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return layout;
}

// layout-to-layoutナビゲーション画面遷移における次のビューコントローラを指定（サブクラスで実装）
- (CollectionViewController *)nextViewController
{
    return nil;
}



@end
