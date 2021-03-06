/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI19_0_0RNSVGEllipse.h"
#import <ReactABI19_0_0/ABI19_0_0RCTLog.h>

@implementation ABI19_0_0RNSVGEllipse

- (void)setCx:(NSString *)cx
{
    if (cx == _cx) {
        return;
    }
    [self invalidate];
    _cx = cx;
}

- (void)setCy:(NSString *)cy
{
    if (cy == _cy) {
        return;
    }
    [self invalidate];
    _cy = cy;
}

- (void)setRx:(NSString *)rx
{
    if (rx == _rx) {
        return;
    }
    [self invalidate];
    _rx = rx;
}

- (void)setRy:(NSString *)ry
{
    if (ry == _ry) {
        return;
    }
    [self invalidate];
    _ry = ry;
}

- (CGPathRef)getPath:(CGContextRef)context
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat cx = [self relativeOnWidth:self.cx];
    CGFloat cy = [self relativeOnHeight:self.cy];
    CGFloat rx = [self relativeOnWidth:self.rx];
    CGFloat ry = [self relativeOnHeight:self.ry];
    CGPathAddEllipseInRect(path, nil, CGRectMake(cx - rx, cy - ry, rx * 2, ry * 2));
    return (CGPathRef)CFAutorelease(path);
}

@end
