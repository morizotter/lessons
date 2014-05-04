//
//  DynamicLayout.h
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import <UIKit/UIKit.h>

@interface DynamicLayout : UICollectionViewFlowLayout
- (void)startDragItemAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point;
- (void)updateDragPoint:(CGPoint)point;
- (void)endDrag;
@end
