//
//  i7Overlay.m
//  i7MapTest
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "i7Overlay.h"

@implementation i7Overlay
@dynamic coordinate, boundingMapRect;

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(0, 0);
}

- (MKMapRect)boundingMapRect {
    return MKMapRectWorld;
}

- (BOOL)intersectsMapRect:(MKMapRect)mapRect {
    return YES;
}

@end
