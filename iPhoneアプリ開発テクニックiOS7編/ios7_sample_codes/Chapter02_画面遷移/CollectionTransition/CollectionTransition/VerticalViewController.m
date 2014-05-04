//
//  VerticalViewController.m
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "VerticalViewController.h"
#import "HorizontalViewController.h"

@interface VerticalViewController ()

@end

@implementation VerticalViewController


+ (UICollectionViewFlowLayout *)verticalLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    
    CGFloat verticalInset = ([[UIScreen mainScreen] bounds].size.width - layout.itemSize.width) / 2.0;
    layout.sectionInset = UIEdgeInsetsMake(10, verticalInset, 10, verticalInset);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    return layout;
}

- (CollectionViewController *)nextViewController
{
    UICollectionViewFlowLayout *layout = [HorizontalViewController horizontalLayout];
    HorizontalViewController *controller = [[HorizontalViewController alloc] initWithCollectionViewLayout:layout];
    controller.useLayoutToLayoutNavigationTransitions = YES;
    return controller;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewController *nextController = [self nextViewController];
    if (nextController != nil) {
        [self.navigationController pushViewController:nextController animated:YES];
    }
}
@end
