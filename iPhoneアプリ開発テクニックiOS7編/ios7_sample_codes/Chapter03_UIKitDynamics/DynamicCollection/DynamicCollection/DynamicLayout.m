//
//  DynamicLayout.m
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ********************************************
 3-2-2 UIKit Dynamics を利用した Collection View レイアウト
 UICollectionViewFlowLayoutをサブクラス化し、レイアウト属性に
 UIKit Dynamicsを適用する。
 ******************************************** */

#import "DynamicLayout.h"
#import "SwingBehavior.h"

@interface DynamicLayout () <UIDynamicAnimatorDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) SwingBehavior *swingBehavior;
@property (nonatomic, getter = isDragged) BOOL dragged;
@end

@implementation DynamicLayout

#pragma mark レイアウト属性を返すメソッド
// self.animatorが存在する（物理動作している）場合には、self.animatorが持つ
// レイアウト属性を返す (P.113)
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.animator) {
        return [self.animator itemsInRect:rect];
    } else {
        return [super layoutAttributesForElementsInRect:rect];
    }
}

- (UICollectionViewLayoutAttributes *)
layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.animator) {
        return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
    } else {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

#pragma mark 更新時に呼ばれるメソッド
// self.animatorが存在する場合には、新しいセル用のレイアウト属性オブジェクトを
// SwingBehaviorに追加する（P.115）
- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    if (self.animator) {
        for (UICollectionViewUpdateItem *updateItem in updateItems) {
            if (updateItem.updateAction == UICollectionUpdateActionInsert) {
                // セルの挿入の場合、新しいレイアウト属性を作成し
                // SwingBehaviorに追加する
                UICollectionViewLayoutAttributes *attributes =
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
                attributes.size = self.itemSize;
                [self.swingBehavior addItem:attributes];
            }
        }
    }
}

#pragma mark -
#pragma mark private methods
// ドラッグ開始 (P.110)
- (void)startDragItemAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point
{
    if (self.animator == nil) { // animatorが存在しない（物理動作していない）場合
        // animatorを作成 --- (1)
        self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.animator.delegate = self;
        
        // superクラスより、すべてのレイアウト属性を取得
        NSMutableArray *allAttributes = [NSMutableArray array];
        for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *theIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attributes =
            [super layoutAttributesForItemAtIndexPath:theIndexPath];
            [allAttributes addObject:attributes];
        }
        // すべてのレイアウト属性を元にSwingBehaviorを作成する --- (2)
        self.swingBehavior =
        [[SwingBehavior alloc] initWithItems:allAttributes];
        [self.animator addBehavior:self.swingBehavior];
    }
    
    // ドラッグ対象となるセルのレイアウト属性を取得 --- (3)
    UICollectionViewLayoutAttributes *dragAttributes =
    self.swingBehavior.items[indexPath.item];
    
    // attachment behaviorを作成
    // anchorPointはupdateDragPoint:メソッドで更新
    self.attachmentBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:dragAttributes
                              attachedToAnchor:point];
    [self.animator addBehavior:self.attachmentBehavior];
    
    self.dragged = YES;
}

// 位置の更新 (P.112)
- (void)updateDragPoint:(CGPoint)point
{
    self.attachmentBehavior.anchorPoint = point;
}

// ドラッグ終了 (P.112)
- (void)endDrag
{
    [self.animator removeBehavior:self.attachmentBehavior];
    self.attachmentBehavior = nil;
    self.dragged = NO;
}

#pragma mark UIDynamicAnimatorDelegate (P.112)
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    if (!self.isDragged) {
        self.animator = nil;
        self.swingBehavior = nil;
    } }

@end
