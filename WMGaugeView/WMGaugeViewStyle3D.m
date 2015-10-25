//
//  WMGaugeViewStyleFlat3D.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMGaugeViewStyle3D.h"

#define kNeedleWidth        0.035
#define kNeedleHeight       0.34
#define kNeedleScrewRadius  0.04

@implementation WMGaugeViewStyle3D

- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect
{
    // Left Needle
    CAShapeLayer *leftNeedleLayer = [CAShapeLayer layer];
    UIBezierPath *leftNeedlePath = [UIBezierPath bezierPath];
    [leftNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
    [leftNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    [leftNeedlePath closePath];
    
    leftNeedleLayer.path = leftNeedlePath.CGPath;
    leftNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    leftNeedleLayer.fillColor = CGRGB(176, 10, 19);
    
    [layer addSublayer:leftNeedleLayer];
    
    // Right Needle
    CAShapeLayer *rightNeedleLayer = [CAShapeLayer layer];
    UIBezierPath *rightNeedlePath = [UIBezierPath bezierPath];
    [rightNeedlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY))];
    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
    [rightNeedlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    [rightNeedlePath closePath];
    
    rightNeedleLayer.path = rightNeedlePath.CGPath;
    rightNeedleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    rightNeedleLayer.fillColor = CGRGB(252, 18, 30);
    
    [layer addSublayer:rightNeedleLayer];
    
    // Needle shadow
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.5];
    [layer setShadowRadius:2.0];
    
    // Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius), FULLSCALE(kNeedleScrewRadius * 2.0, kNeedleScrewRadius * 2.0));
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    screwLayer.fillColor = CGRGB(171, 171, 171);
    screwLayer.strokeColor = CGRGBA(81, 84, 89, 100);
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
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)@[iCGRGB(96, 96, 96), iCGRGB(68, 68, 68), iCGRGB(32, 32, 32)], (const CGFloat[]){0.35, 0.96, 0.99});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Shadow
    baseSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)@[iCGRGBA(40, 96, 170, 60), iCGRGBA(15, 34, 98, 80), iCGRGBA(0, 0, 0, 120), iCGRGBA(0, 0, 0, 140)], (const CGFloat[]){0.60, 0.85, 0.96, 0.99});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, kCenterPoint, 0, kCenterPoint, rect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Border
    CGContextSetLineWidth(context, 0.005);
    CGContextSetStrokeColorWithColor(context, CGRGBA(81, 84, 89, 160));
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
}

- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    return NO;
}

@end
