//
//  SwingBehavior.m
//  DynamicCollection
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ********************************************
 3-2-1 Collection Viewに使用する準備(カスタムbehaviorの作成)
 UIDynamicBehaviorをサブクラス化し、カスタムbehaviorを作成する
 アイテムが縦に連結するbehaviorであり、連結したアイテムは振り子のように動作する
 ******************************************** */

#import "SwingBehavior.h"

@interface SwingBehavior () {
    NSMutableArray *_items;
}
@end

@implementation SwingBehavior
const CGFloat attachOffsetFromEdge = 5;

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _items = [items mutableCopy];
        
        // gravity behaviorにすべてのdynamic itemを追加
        UIGravityBehavior *gravityBehavior =
        [[UIGravityBehavior alloc] initWithItems:_items];
        [self addChildBehavior:gravityBehavior];
        
        id <UIDynamicItem> prevItem = nil;
        for (int i = 0; i < [_items count]; i++) {
            id <UIDynamicItem> item = _items[i];
            CGPoint center = item.center;
            CGSize size = item.bounds.size;
            
            UIOffset upperOffset =
            UIOffsetMake(0, -(size.height / 2.0 - attachOffsetFromEdge));
            UIOffset lowerOffset =
            UIOffsetMake(0, size.height / 2.0 - attachOffsetFromEdge);
            CGPoint ancherPoint =
            CGPointMake(center.x,
                        center.y - size.height / 2.0 - attachOffsetFromEdge);
            
            // attachment behaviorを接続点ごとに作成して追加
            UIAttachmentBehavior *attachmentBehavior;
            if (i == 0) { // 先頭の dynamic item
                // 上部接続ポイントをアンカーポイントと接続
                attachmentBehavior =
                [[UIAttachmentBehavior alloc] initWithItem:item
                                          offsetFromCenter:upperOffset
                                          attachedToAnchor:ancherPoint];
                
            } else {
                // 上部接続ポイントを一つ上のdynamic itemの下部接続ポイントと接続
                attachmentBehavior =
                [[UIAttachmentBehavior alloc] initWithItem:item
                                          offsetFromCenter:upperOffset
                                            attachedToItem:prevItem
                                          offsetFromCenter:lowerOffset];
            }
            [self addChildBehavior:attachmentBehavior];
            prevItem = item;
        }
    }
    return self;
}

- (void)addItem:(id<UIDynamicItem>)item
{
    // 最後のdynamic itemと同じ位置から動作を開始させる
    id <UIDynamicItem> prevItem = [_items lastObject];
    item.center = prevItem.center;
    
    // gravity behaviorにitemを追加
    NSArray *behaviors = [self childBehaviors];
    UIGravityBehavior *gravityBehavior = (UIGravityBehavior *)behaviors[0];
    [gravityBehavior addItem:item];
    
    // 初期化時と同様にattaciment behaviorを作成し追加
    CGSize size = item.bounds.size;
    UIOffset upperOffset =
    UIOffsetMake(0, -(size.height / 2.0 - attachOffsetFromEdge));
    UIOffset lowerOffset =
    UIOffsetMake(0, size.height / 2.0 - attachOffsetFromEdge);
    
    UIAttachmentBehavior *attachmentBehavior =
    [[UIAttachmentBehavior alloc] initWithItem:item
                              offsetFromCenter:upperOffset
                                attachedToItem:prevItem
                              offsetFromCenter:lowerOffset];
    // item間の距離を調整する
    attachmentBehavior.length = 20; // minimumLineSpacing + attachOffsetFromEdge * 2
    [self addChildBehavior:attachmentBehavior];
    
    // _itemsを更新
    [_items addObject:item];
}
@end
