//
//  TransitionLayout.m
//  CollectionTransition
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//
// -----------------------------------------------------
// 画面遷移時の中間レイアウト
// translateパラメータを利用して、画面遷移中にセルを上下左右に移動させられるようにする
// -----------------------------------------------------


#import "TransitionLayout.h"

@implementation TransitionLayout

- (void)setTranslate:(CGPoint)translate
{
    _translate = translate;
    
    // updteValue:forAnimatedKeyではCGFloatしか扱えないため、
    // CGPointの要素を2つに分けて保存
    [self updateValue:translate.x forAnimatedKey:@"translateX"];
    [self updateValue:translate.y forAnimatedKey:@"translateY"];
}

- (void)setTransitionProgress:(CGFloat)transitionProgress
{
    [super setTransitionProgress:transitionProgress];
    
    CGFloat translateX = [self valueForAnimatedKey:@"translateX"];
    CGFloat translateY = [self valueForAnimatedKey:@"translateY"];
    self.translate = CGPointMake(translateX, translateY);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        // レイアウト属性にtranslateの値を反映
        CGPoint center = attributes.center;
        attributes.center = CGPointMake(center.x + self.translate.x, center.y + self.translate.y);
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // レイアウト属性にtranslateの値を反映
    CGPoint center = attributes.center;
    attributes.center = CGPointMake(center.x + self.translate.x, center.y + self.translate.y);
    return attributes;
}


@end
