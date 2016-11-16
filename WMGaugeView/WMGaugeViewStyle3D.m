//
//  WMGaugeViewStyleFlat3D.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMGaugeViewStyle3D.h"

@implementation WMGaugeViewStyle3D

- (instancetype)init
{
    if (self = [super init]) {
        _needleWidth = 0.035;
        _needleHeight = 0.34;
        _needleScrewRadius = 0.04;
        
        _leftNeedleColor = RGB(176, 10, 19);
        _rightNeedleColor = RGB(252, 18, 30);
        
        _screwFillColor = RGB(171, 171, 171);
        _screwStrokeColor = RGBA(81, 84, 89, 100);
        
        _borderColor = RGBA(81, 84, 89, 160);
        _borderWidth = 0.005;
        
        _faceGradientColors = @[RGB(96, 96, 96), RGB(68, 68, 68), RGB(32, 32, 32)];
        _faceGradientPositions = @[@0.35, @0.96, @0.99];
        _faceShadowColors = @[RGBA(40, 96, 170, 60), RGBA(15, 34, 98, 80), RGBA(0, 0, 0, 120), RGBA(0, 0, 0, 140)];
        _faceShadowPositions = @[@0.60, @0.85, @0.96, @0.99];
    }
    return self;
}

- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect
{
    // Left Needle
    CAShapeLayer *leftNeedleLayer = [CAShapeLayer layer];
    UIBezierPath *leftNeedlePath = [UIBezierPath bezierPath];
    [leftNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX - _needleWidth, kCenterY))];
    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - _needleHeight))];
    [leftNeedlePath closePath];
    
    leftNeedleLayer.path = leftNeedlePath.CGPath;
    leftNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    leftNeedleLayer.fillColor = _leftNeedleColor.CGColor;
    
    [layer addSublayer:leftNeedleLayer];
    
    // Right Needle
    CAShapeLayer *rightNeedleLayer = [CAShapeLayer layer];
    UIBezierPath *rightNeedlePath = [UIBezierPath bezierPath];
    [rightNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + _needleWidth, kCenterY))];
    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - _needleHeight))];
    [rightNeedlePath closePath];
    
    rightNeedleLayer.path = rightNeedlePath.CGPath;
    rightNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    rightNeedleLayer.fillColor = _rightNeedleColor.CGColor;
    
    [layer addSublayer:rightNeedleLayer];
    
    // Needle shadow
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.5];
    [layer setShadowRadius:2.0];
    
    // Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - _needleScrewRadius, kCenterY - _needleScrewRadius), FULLSCALE(_needleScrewRadius * 2.0, _needleScrewRadius * 2.0));
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    screwLayer.fillColor = _screwFillColor.CGColor;
    screwLayer.strokeColor = _screwStrokeColor.CGColor;
    screwLayer.lineWidth = 1.5;
    
    // Screw shadow
    screwLayer.shadowColor = [[UIColor blackColor] CGColor];
    screwLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    screwLayer.shadowOpacity = 0.1;
    screwLayer.shadowRadius = 2.0;
    
    [layer addSublayer:screwLayer];
}

- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
    // Default Face
    NSAssert(_faceGradientPositions.count == _faceGradientColors.count, @"Must have same amout of colors as positions");
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat* positions = CGFloatCArray(_faceGradientPositions);
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)CGColorArray(_faceGradientColors), positions);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    free(positions); positions = NULL;
    
    // Shadow
    NSAssert(_faceShadowPositions.count == _faceShadowColors.count, @"Must have same amount of colors as positions");
    baseSpace = CGColorSpaceCreateDeviceRGB();
    positions = CGFloatCArray(_faceShadowPositions);
    gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)CGColorArray(_faceShadowColors), positions);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    free(positions); positions = NULL;
    
    // Border
    CGContextSetLineWidth(context, _borderWidth);
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
}

- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    return NO;
}

@end
