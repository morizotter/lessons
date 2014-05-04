//
//  CollectionViewCell.h
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, readonly) UILabel *label;

+(NSString *)cellIdentifier;
@end
