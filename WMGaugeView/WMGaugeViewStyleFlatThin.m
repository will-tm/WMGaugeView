//
//  WMGaugeViewStyleFlatThin.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMGaugeViewStyleFlatThin.h"

@interface WMGaugeViewStyleFlatThin ()

@property (nonatomic) CAShapeLayer *needleLayer;

@end

@implementation WMGaugeViewStyleFlatThin

- (instancetype)init
{
    if (self = [super init]) {
        _needleWidth = 0.012;
        _needleHeight = 0.4;
        _needleScrewRadius = 0.05;
        _needleColor = RGB(255, 104, 97);
        _needleScrewColor = RGB(68, 84, 105);
        
        _externalRingRadius = 0.24;
        _externalFaceColor = RGB(255, 104, 97);

        _internalRingRadius = 0.1;
        _internalFaceColor = RGB(242, 99, 92);
        
        _borderColor = RGBA(81, 84, 89, 160);
        _borderWidth = 0;
    }
    return self;
}

- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect
{
    _needleLayer = [CAShapeLayer layer];
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    [needlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX - _needleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + _needleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - _needleHeight))];
    [needlePath closePath];
    
    _needleLayer.path = needlePath.CGPath;
    _needleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _needleLayer.fillColor = _needleColor.CGColor;
    _needleLayer.strokeColor = _needleColor.CGColor;
    _needleLayer.lineWidth = 1.2;
    
    // Needle shadow
    _needleLayer.shadowColor = [[UIColor blackColor] CGColor];
    _needleLayer.shadowOffset = CGSizeMake(-2.0, -2.0);
    _needleLayer.shadowOpacity = 0.2;
    _needleLayer.shadowRadius = 1.2;
    
    [layer addSublayer:_needleLayer];
    
    // Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - _needleScrewRadius, kCenterY - _needleScrewRadius), FULLSCALE(_needleScrewRadius * 2.0, _needleScrewRadius * 2.0));
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    screwLayer.fillColor = _needleScrewColor.CGColor;
    
    // Screw shadow
    screwLayer.shadowColor = [[UIColor blackColor] CGColor];
    screwLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    screwLayer.shadowOpacity = 0.2;
    screwLayer.shadowRadius = 2.0;
    
    [layer addSublayer:screwLayer];
}

- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
    // External circle
    CGRect externalRect = CGRectMake(kCenterX - _externalRingRadius, kCenterY - _externalRingRadius, _externalRingRadius * 2.0, _externalRingRadius * 2.0);
    CGContextSetFillColorWithColor(context, _externalFaceColor.CGColor);
    CGContextFillEllipseInRect(context, externalRect);

    // Inner circle
    CGRect internalRect = CGRectMake(kCenterX - _internalRingRadius, kCenterY - _internalRingRadius, _internalRingRadius * 2.0, _internalRingRadius * 2.0);
    CGContextSetFillColorWithColor(context, _internalFaceColor.CGColor);
    CGContextFillEllipseInRect(context, internalRect);
    
    // Border
    CGRect borderRect = CGRectInset(rect, _borderWidth * 0.5, _borderWidth * 0.5);
    CGContextSetLineWidth(context, _borderWidth);
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    CGContextStrokeEllipseInRect(context, borderRect);
}

- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    layer.transform = [[animation.values objectAtIndex:0] CATransform3DValue];
    CGAffineTransform affineTransform1 = [layer affineTransform];
    layer.transform = [[animation.values objectAtIndex:1] CATransform3DValue];
    CGAffineTransform affineTransform2 = [layer affineTransform];
    layer.transform = [[animation.values lastObject] CATransform3DValue];
    CGAffineTransform affineTransform3 = [layer affineTransform];
    
    _needleLayer.shadowOffset = CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3);
    
    [layer addAnimation:animation forKey:kCATransition];
    
    CAKeyframeAnimation * animationShadowOffset = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
    animationShadowOffset.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationShadowOffset.removedOnCompletion = YES;
    animationShadowOffset.duration = animated ? duration : 0.0;
    animationShadowOffset.values = @[[NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform1)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform2)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3)]];
    [_needleLayer addAnimation:animationShadowOffset forKey:kCATransition];
    
    return YES;
}

@end
