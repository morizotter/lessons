//
//  MyScene.m
//  MCStepper2
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        // 背景
        self.backgroundColor = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        // 壁を作る
        // 天井
        SKShapeNode *topNode = [SKShapeNode node];
        topNode.fillColor = [SKColor blackColor];
        topNode.position = CGPointMake(0, self.size.height);
        topNode.path = CGPathCreateWithRect(CGRectMake(0, 0, self.size.width, 3), NULL);
        topNode.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:topNode.path];
        topNode.physicsBody.dynamic = NO;	// 位置を固定する
        [self addChild:topNode];
        // 底
        SKShapeNode *butomNode = [SKShapeNode node];
        butomNode.fillColor = [SKColor blackColor];
        butomNode.position = CGPointMake(0, 0);
        butomNode.path = CGPathCreateWithRect(CGRectMake(0, 0, self.size.width, 3), NULL);
        butomNode.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:butomNode.path];
        butomNode.physicsBody.dynamic = NO;	// 位置を固定する
        [self addChild:butomNode];
        // 右
        SKShapeNode *rightNode = [SKShapeNode node];
        rightNode.fillColor = [SKColor blackColor];
        rightNode.path = CGPathCreateWithRect(CGRectMake(0, 0, 3, self.size.height), NULL);
        rightNode.position = CGPointMake(self.frame.size.width, 0);
        rightNode.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:CGPathCreateCopy(rightNode.path)];
        rightNode.physicsBody.dynamic = NO;	// 位置を固定する
        [self addChild:rightNode];
        // 左
        SKShapeNode *leftNode = [SKShapeNode node];
        leftNode.fillColor = [SKColor blackColor];
        leftNode.position = CGPointMake(0, 0);
        leftNode.path = CGPathCreateWithRect(CGRectMake(0, 0, 3, self.size.height), NULL);
        leftNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, self.size.height)];
        leftNode.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:leftNode.path];
        leftNode.physicsBody.dynamic = NO;	// 位置を固定する
        [self addChild:leftNode];
    }
    return self;
}

// 画面をタッチした
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 全ての指について
    for (UITouch *touch in touches) {
        // 触り始めだけを処理するようにする
        if (touch.phase == UITouchPhaseBegan) {
            CGPoint location = [touch locationInNode:self];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithDouble:22.0] forKey:@"size"];
            [dic setObject:[UIColor greenColor] forKey:@"color"];
            [dic setObject:[NSNumber numberWithDouble:location.x] forKey:@"x"];
            [dic setObject:[NSNumber numberWithDouble:location.y] forKey:@"y"];
            [dic setObject:[NSNumber numberWithDouble:self.physicsWorld.gravity.dx * -100] forKey:@"vx"];
            [dic setObject:[NSNumber numberWithDouble:self.physicsWorld.gravity.dy * -100] forKey:@"vy"];
            [dic setObject:@"Like!" forKey:@"message"];
            [dic setObject:@"Chalkduster" forKey:@"font"];
            NSLog(@"touch: %@", dic);
            [self.stepDelegate sendDictionary:dic];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark -
-(void)addDictionary:(NSDictionary*)dic;
{
    NSLog(@"-addDictionary: %@", dic);
    // 色
    NSNumber *r = [dic objectForKey:@"R"];
    NSNumber *g = [dic objectForKey:@"G"];
    NSNumber *b = [dic objectForKey:@"B"];
    NSNumber *alpha = [dic objectForKey:@"A"];
    UIColor *color = [dic objectForKey:@"color"];
    if (r && g && b && alpha) {
        color = [UIColor colorWithRed:r.doubleValue green:g.doubleValue blue:b.doubleValue alpha:alpha.doubleValue];
    }
    color = color ? color : [UIColor grayColor];
    // position
    NSNumber *x = [dic objectForKey:@"x"];
    NSNumber *y = [dic objectForKey:@"y"];
    CGPoint position;
    position.x = x ? x.doubleValue : CGRectGetMidX(self.frame);
    position.y = y ? y.doubleValue : CGRectGetMidY(self.frame);
    // vector
    NSNumber *vx = [dic objectForKey:@"vx"];
    NSNumber *vy = [dic objectForKey:@"vy"];
    // 一文字ごとにボヨボヨさせるコード。これ入れるとたまにコリジョン起こして大変
    //    NSString *message = [dic objectForKey:@"message"];
    //    SKNode *lastNode;
    //    for (int pt = 0; pt < message.length; pt++) {
    //        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
    //        unichar ch = [message characterAtIndex:pt];
    //        label.text = [NSString stringWithCharacters:&ch length:1];
    //        label.fontSize = 22;
    //        label.fontColor = [UIColor greenColor];
    //        CGFloat width = label.fontSize / 2;
    //        label.position = CGPointMake(position.x + pt * width, position.y);
    //        label.alpha = 0.0f;
    //        SKPhysicsBody *physics = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, width)];	// 矩形
    //        physics.restitution = 0.8; // 弾性
    //        physics.linearDamping = 0.2; // 減衰
    //        physics.velocity = CGVectorMake(vx.doubleValue, vy.doubleValue); // 速度
    //        physics.angularDamping = 1.0;	// 回転の減衰
    //        label.physicsBody = physics;
    //        // アクションを決める
    //        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //        [array addObject:[SKAction fadeInWithDuration:0.1f]];
    //        [array addObject:[SKAction waitForDuration:2.0f]];
    //        [array addObject:[SKAction fadeOutWithDuration:0.6f]];
    //        [array addObject:[SKAction removeFromParent]];
    //        SKAction *group = [SKAction sequence:array];
    //        [label runAction:group completion:NULL];
    //        [self addChild:label];
    //        // ジョイント
    //        if (lastNode) {
    //            // スライダー
    //            SKPhysicsJointSliding *slider = [SKPhysicsJointSliding jointWithBodyA:lastNode.physicsBody bodyB:physics anchor:label.position axis:CGVectorMake(0.3, 1)];
    //            slider.shouldEnableLimits = YES;	// スライド範囲を制限するか？
    //            slider.upperDistanceLimit = label.fontSize;	// スライドする上限
    //            slider.lowerDistanceLimit = -label.fontSize; // スライドする下限
    //            [self.physicsWorld addJoint:slider];
    //            // スプリング
    //            SKPhysicsJointSpring *spling = [SKPhysicsJointSpring jointWithBodyA:physics bodyB:lastNode.physicsBody anchorA:label.position anchorB:lastNode.position];
    //            spling.damping = 0.0f;		// 振動の減衰
    //            spling.frequency = 5.0f;	// 長さを維持しようとする力
    //            [self.physicsWorld addJoint:spling];
    //        }
    //        lastNode = label;
    //    }
    
    // テキストラベル
    NSString *fontName = [dic objectForKey:@"font"];
    SKLabelNode *like = [SKLabelNode labelNodeWithFontNamed:fontName ? fontName : @"Chalkduster"];
    like.text = [dic objectForKey:@"message"];
    // フォントサイズ
    NSNumber *size = [dic objectForKey:@"size"];
    like.fontSize = size ? size.doubleValue : 12.0f;
    NSLog(@"size = %.2f", like.fontSize);
    like.position = position;
    like.fontColor = color;
    // 物理演算用
    like.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];	// 円形
    like.physicsBody.restitution = 0.8; // 弾性
    like.physicsBody.linearDamping = 0.2; // 減衰
    like.physicsBody.velocity = CGVectorMake(vx.doubleValue, vy.doubleValue); // 速度
    
    // アクションを決める
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    [array addObject:[SKAction fadeInWithDuration:0.1f]];
    [array addObject:[SKAction waitForDuration:2.0f]];
    [array addObject:[SKAction fadeOutWithDuration:0.6f]];
    [array addObject:[SKAction removeFromParent]];
    SKAction *group = [SKAction sequence:array];
    [like runAction:group completion:NULL];
    [self addChild:like];
}

@end
