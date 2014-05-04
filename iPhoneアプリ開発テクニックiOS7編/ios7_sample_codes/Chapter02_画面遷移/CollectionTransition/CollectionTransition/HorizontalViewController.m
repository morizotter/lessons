//
//  HorizontalViewController.m
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "HorizontalViewController.h"

@interface HorizontalViewController ()

@end

@implementation HorizontalViewController

+ (UICollectionViewFlowLayout *)horizontalLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.sectionInset = UIEdgeInsetsMake(200, 10, 200, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}

- (CollectionViewController *)nextViewController
{
    return nil;
}

@end
