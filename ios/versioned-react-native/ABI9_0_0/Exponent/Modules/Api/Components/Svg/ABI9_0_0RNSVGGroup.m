/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI9_0_0RNSVGGroup.h"

@implementation ABI9_0_0RNSVGGroup

- (void)renderLayerTo:(CGContextRef)context
{
    ABI9_0_0RNSVGSvgView* svg = [self getSvgView];
    [self clip:context];
    
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        if (node.responsible && !svg.responsible) {
            svg.responsible = YES;
            return NO;
        }
        return YES;
    }];
    
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        [node mergeProperties:self mergeList:self.propList inherited:YES];
        [node renderTo:context];
        return YES;
    }];
}

- (CGPathRef)getPath:(CGContextRef)context
{
    CGMutablePathRef path = CGPathCreateMutable();
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        CGAffineTransform transform = node.matrix;
        CGPathAddPath(path, &transform, [node getPath:context]);
        return YES;
    }];
    
    return (CGPathRef)CFAutorelease(path);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event withTransform:(CGAffineTransform)transform
{
    CGAffineTransform matrix = CGAffineTransformConcat(self.matrix, transform);
    
    for (ABI9_0_0RNSVGNode *node in [self.subviews reverseObjectEnumerator]) {
        if ([node isKindOfClass:[ABI9_0_0RNSVGNode class]]) {
            if (event) {
                node.active = NO;
            } else if (node.active) {
                return node;
            }

            UIView *view = [node hitTest: point withEvent:event withTransform:matrix];
            
            if (view) {
                node.active = YES;
                if (node.responsible || (node != view)) {
                    return view;
                } else {
                    return self;
                }
            }
        }
    }
    return nil;
}

- (void)saveDefinition
{
    if (self.name) {
        ABI9_0_0RNSVGSvgView* svg = [self getSvgView];
        [svg defineTemplate:self templateRef:self.name];
    }
    
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        [node saveDefinition];
        return YES;
    }];
    
}

- (void)mergeProperties:(__kindof ABI9_0_0RNSVGNode *)target mergeList:(NSArray<NSString *> *)mergeList
{
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        [node mergeProperties:target mergeList:mergeList];
        return YES;
    }];
}

- (void)resetProperties
{
    [self traverseSubviews:^(ABI9_0_0RNSVGNode *node) {
        [node resetProperties];
        return YES;
    }];
}

- (void)traverseSubviews:(BOOL (^)(ABI9_0_0RNSVGNode *node))block
{
    for (ABI9_0_0RNSVGNode *node in self.subviews) {
        if ([node isKindOfClass:[ABI9_0_0RNSVGNode class]]) {
            if (!block(node)) {
                break;
            }
        }
    }
}


@end