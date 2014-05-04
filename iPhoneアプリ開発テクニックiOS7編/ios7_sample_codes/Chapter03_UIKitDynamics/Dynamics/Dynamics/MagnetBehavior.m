//
//  MagnetBehavior.m
//  Dynamics
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ***********************************************
 カスタムbehavior
 UIDynamicBehaviorのサブクラス化によるカスタムbehaviorの作成例
 *********************************************** */

#import "MagnetBehavior.h"

@implementation MagnetBehavior

- (instancetype)initWithItem:(id<UIDynamicItem>)item1
                 anotherItem:(id<UIDynamicItem>)item2
{
    self = [super init];
    if (self) {
        // 物理動作の対象となるdynamic item
        NSArray *items = @[item1, item2];
        
        
        // 境界、item同士の衝突をchildBehaviorとして追加
        UICollisionBehavior *collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:items];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [self addChildBehavior:collisionBehavior];
        
        // 衝突時に2つのitemがすぐ停止するように
        // UIDynamicItemBehaviorを用いて設定
        UIDynamicItemBehavior *propertyBehavior =
        [[UIDynamicItemBehavior alloc] initWithItems:items];
        
        propertyBehavior.elasticity = 0.0; // 弾性なし
        propertyBehavior.friction = 1.0; // 摩擦あり
        propertyBehavior.allowsRotation = NO; // 回転なし
        
        [self addChildBehavior:propertyBehavior];
        
        // プッシュ動作を作成しchildBehaviorとして追加
        // それぞれのdynamic itemにかかる力はactionブロック内で決める
        UIPushBehavior *pushBehavior1 =
        [[UIPushBehavior alloc] initWithItems:@[item1]
                                         mode:UIPushBehaviorModeInstantaneous];
        
        [self addChildBehavior:pushBehavior1];
        
        UIPushBehavior *pushBehavior2 =
        [[UIPushBehavior alloc] initWithItems:@[item2]
                                         mode:UIPushBehaviorModeInstantaneous];
        
        [self addChildBehavior:pushBehavior2];
        
        // actionブロックにてpush behaviorの力を決める
        // actionブロックはanimation tickごとに呼ばれる(パフォーマンス注意)
        self.action = ^{
            
            CGFloat length = sqrtf(powf(item1.center.x-item2.center.x, 2)+
                                   powf(item1.center.y-item2.center.y, 2));
            
            CGFloat force = length == 0 ? 0 : 1.0 / (length * length);
            CGFloat dx1 = (item2.center.x - item1.center.x) * force;
            CGFloat dy1 = (item2.center.y - item1.center.y) * force;
            CGFloat dx2 = (item1.center.x - item2.center.x) * force;
            CGFloat dy2 = (item1.center.y - item2.center.y) * force;
            pushBehavior1.pushDirection = CGVectorMake(dx1, dy1);
            pushBehavior2.pushDirection = CGVectorMake(dx2, dy2);
            pushBehavior1.active = YES;
            pushBehavior2.active = YES;
        };
    }
    return self;
}

        

@end
