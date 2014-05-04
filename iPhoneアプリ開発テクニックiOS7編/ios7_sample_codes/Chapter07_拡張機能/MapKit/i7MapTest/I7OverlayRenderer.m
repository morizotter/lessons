//
//  I7OverlayRenderer.m
//  i7MapTest
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "I7OverlayRenderer.h"

@implementation I7OverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    [[UIColor blueColor] set];
    CGRect rect = [self rectForMapRect:mapRect];
    rect.size.width /= 2;
    rect.size.height /= 2;
    UIRectFill(rect);
    UIGraphicsPopContext();
}

@end
