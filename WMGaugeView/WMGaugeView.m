/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#import "WMGaugeView.h"

#define DEGREES_TO_RADIANS(degrees) (degrees) / 180.0 * M_PI

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]
#define CGRGB(r,g,b) RGB(r,g,b).CGColor
#define iCGRGB(r,g,b) (id)CGRGB(r,g,b)
#define CGRGBA(r,g,b,a) RGBA(r,g,b,a).CGColor
#define iCGRGBA(r,g,b,a) (id)CGRGBA(r,g,b,a)

@implementation WMGaugeView
{
    CGRect fullRect;
    CGRect innerRimRect;
    CGRect innerRimBorderRect;
    CGRect faceRect;
    CGRect rangeLabelsRect;
    CGRect scaleRect;
    CGPoint center;
    CGFloat scaleRotation;
    CGFloat divisionValue;
    CGFloat subdivisionValue;
    CGFloat subdivisionAngle;
    double currentValue;
    double needleAcceleration;
    double needleVelocity;
    NSTimeInterval needleLastMoved;
    UIImage *background;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)initialize;
{
    _showInnerRim = NO;
    _showInnerBackground = YES;
    _innerRimWidth = 0.05;
    _innerRimBorderWidth = 0.005;
    
    _needleWidth = 0.035;
    _needleHeight = 0.34;
    _needleScrewRadius = 0.04;
    
    _scalePosition = 0.025;
    _scaleStartAngle = 30.0;
    _scaleEndAngle = 330.0;
    _scaleDivisions = 12.0;
    _scaleSubdivisions = 10.0;
    
    _value = 0.0;
    _minValue = 0.0;
    _maxValue = 240.0;
    currentValue = 0.0;
    
    _rangeLabelsWidth = 0.0;
    
    needleVelocity = 0.0;
    needleAcceleration = 0.0;
    needleLastMoved = -1;
    
    background = nil;
    
    _rangeValues = @[ @50,                  @90,                @130,               @(_maxValue)        ];
    _rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
    _rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
    
    _unitOfMeasurement = @"psi";
    
    [self initDrawingRects];
    [self initScale];
}

- (void)initDrawingRects
{
    center = CGPointMake(0.5, 0.5);
    fullRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    _innerRimBorderWidth = _showInnerRim?_innerRimBorderWidth:0.0;
    _innerRimWidth = _showInnerRim?_innerRimWidth:0.0;
    
    innerRimRect = fullRect;
    innerRimBorderRect = CGRectMake(innerRimRect.origin.x + _innerRimBorderWidth,
                                    innerRimRect.origin.y + _innerRimBorderWidth,
                                    innerRimRect.size.width - 2 * _innerRimBorderWidth,
                                    innerRimRect.size.height - 2 * _innerRimBorderWidth);
    faceRect = CGRectMake(innerRimRect.origin.x + _innerRimWidth,
                          innerRimRect.origin.y + _innerRimWidth,
                          innerRimRect.size.width - 2 * _innerRimWidth,
                          innerRimRect.size.height - 2 * _innerRimWidth);
    rangeLabelsRect = CGRectMake(faceRect.origin.x + _rangeLabelsWidth,
                                 faceRect.origin.y + _rangeLabelsWidth,
                                 faceRect.size.width - 2 * _rangeLabelsWidth,
                                 faceRect.size.height - 2 * _rangeLabelsWidth);
    scaleRect = CGRectMake(rangeLabelsRect.origin.x + _scalePosition,
                           rangeLabelsRect.origin.y + _scalePosition,
                           rangeLabelsRect.size.width - 2 * _scalePosition,
                           rangeLabelsRect.size.height - 2 * _scalePosition);
}

- (void)drawRect:(CGRect)rect
{
    [self computeCurrentValue];
    
    if (background == nil)
    {
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, rect.size.width , rect.size.height);
        [self drawGauge:context];
        background = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [background drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, rect.size.width , rect.size.height);
    
    [self drawNeedle:context];
}

- (void)drawGauge:(CGContextRef)context
{
    [self drawRim:context];
    if (_showInnerBackground)
        [self drawFace:context];
    [self drawText:context];
    [self drawScale:context];
    [self drawRangeLabels:context];
}

- (void)drawRim:(CGContextRef)context
{
    
}

- (void)drawFace:(CGContextRef)context
{
    // Default Face
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)@[iCGRGB(96, 96, 96), iCGRGB(68, 68, 68), iCGRGB(32, 32, 32)], (const CGFloat[]){0.35, 0.96, 0.99});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, faceRect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, faceRect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;

    // Shadow
    baseSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)@[iCGRGBA(40, 96, 170, 60), iCGRGBA(15, 34, 98, 80), iCGRGBA(0, 0, 0, 120), iCGRGBA(0, 0, 0, 140)], (const CGFloat[]){0.60, 0.85, 0.96, 0.99});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, faceRect);
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, faceRect.size.width / 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Border
    CGContextSetLineWidth(context, 0.005);
    CGContextSetStrokeColorWithColor(context, CGRGBA(81, 84, 89, 160));
    CGContextAddEllipseInRect(context, faceRect);
    CGContextStrokePath(context);
}

- (void)drawText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:0.04];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor] };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:_unitOfMeasurement attributes:stringAttrs];
    CGSize fontWidth = [_unitOfMeasurement sizeWithAttributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, 0.6)];
}

- (void)drawScale:(CGContextRef)context
{
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, DEGREES_TO_RADIANS(180 + _scaleStartAngle));
    CGContextTranslateCTM(context, -center.x, -center.y);
    
    int totalTicks = _scaleDivisions * _scaleSubdivisions + 1;
    for (int i = 0; i < totalTicks; i++)
    {
        CGFloat y1 = scaleRect.origin.y;
        CGFloat y2 = y1 + 0.015;
        CGFloat y3 = y1 + 0.045;
        
        float value = [self valueForTick:i];
        float div = (_maxValue - _minValue) / _scaleDivisions;
        float mod = (int)value % (int)div;
        
        UIColor *color = [self rangeColorForValue:value];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 0.01);
        CGContextMoveToPoint(context, 0.5, y1);
        CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
        
        if ((abs(mod - 0) < 0.001) || (abs(mod - div) < 0.001))
        {
            CGContextAddLineToPoint(context, 0.5, y3);
            CGContextStrokePath(context);
            
            NSString *valueString = [NSString stringWithFormat:@"%0.0f",value];
            UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:0.05];
            NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
            NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:valueString attributes:stringAttrs];
            CGSize fontWidth = [valueString sizeWithAttributes:stringAttrs];
            [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, y3 + 0.005)];
        }
        else
        {
            CGContextAddLineToPoint(context, 0.5, y2);
            CGContextStrokePath(context);
        }
        
        CGContextTranslateCTM(context, center.x, center.y);
        CGContextRotateCTM(context, DEGREES_TO_RADIANS(subdivisionAngle));
        CGContextTranslateCTM(context, -center.x, -center.y);
    }
}

- (void)drawRangeLabels:(CGContextRef)context
{
    
}

- (void)drawNeedle:(CGContextRef)context
{
    CGContextTranslateCTM(context, center.x, center.y);
    CGContextRotateCTM(context, DEGREES_TO_RADIANS(180 + _scaleStartAngle + currentValue / (_maxValue - _minValue) * (_scaleEndAngle - _scaleStartAngle)));
    CGContextTranslateCTM(context, -center.x, -center.y);
    
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 8.0);
    
    // Left Needle
    UIBezierPath *leftNeedlePath = [UIBezierPath bezierPath];
    [leftNeedlePath moveToPoint:center];
    [leftNeedlePath addLineToPoint:CGPointMake(center.x - _needleWidth, center.y)];
    [leftNeedlePath addLineToPoint:CGPointMake(center.x, center.x - _needleHeight)];
    [leftNeedlePath addLineToPoint:center];
    [leftNeedlePath addLineToPoint:CGPointMake(center.x - _needleWidth, center.y)];
    [leftNeedlePath closePath];
    [RGB(176, 10, 19) setFill];
    [leftNeedlePath fill];
    
    // Right Needle
    UIBezierPath *rightNeedlePath = [UIBezierPath bezierPath];
    [rightNeedlePath moveToPoint:center];
    [rightNeedlePath addLineToPoint:CGPointMake(center.x + _needleWidth, center.y)];
    [rightNeedlePath addLineToPoint:CGPointMake(center.x, center.x - _needleHeight)];
    [rightNeedlePath addLineToPoint:center];
    [rightNeedlePath addLineToPoint:CGPointMake(center.x + _needleWidth, center.y)];
    [rightNeedlePath closePath];
    [RGB(252, 18, 30) setFill];
    [rightNeedlePath fill];

    [self drawNeedleScrew:context];
}

- (void)drawNeedleScrew:(CGContextRef)context
{
    // Screw
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)@[iCGRGB(171, 171, 171), iCGRGB(255, 255, 255), iCGRGB(171, 171, 171)], (const CGFloat[]){0.05, 0.9, 1.00});
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextAddEllipseInRect(context, CGRectMake(center.x - _needleScrewRadius, center.y - _needleScrewRadius, _needleScrewRadius * 2.0, _needleScrewRadius * 2.0));
    CGContextClip(context);
    CGContextDrawRadialGradient(context, gradient, center, 0, center, _needleScrewRadius * 2.0, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Border
    CGContextSetLineWidth(context, 0.005);
    CGContextSetStrokeColorWithColor(context, CGRGBA(81, 84, 89, 100));
    CGContextAddEllipseInRect(context, CGRectMake(center.x - _needleScrewRadius, center.y - _needleScrewRadius, _needleScrewRadius * 2.0, _needleScrewRadius * 2.0));
    CGContextStrokePath(context);
}

- (void)initScale
{
    scaleRotation = (int)(_scaleStartAngle + 180) % 360;
    divisionValue = (_maxValue - _minValue) / _scaleDivisions;
    subdivisionValue = divisionValue / _scaleSubdivisions;
    subdivisionAngle = (360 - 2 * _scaleStartAngle) / (_scaleDivisions * _scaleSubdivisions);
}

- (float)valueForTick:(int)tick
{
    return tick * (divisionValue / _scaleSubdivisions);
}

- (void)computeCurrentValue
{
    if (!(abs(currentValue - _value) > 0.1))
    {
        return;
    }

    if (-1 != needleLastMoved)
    {
        NSTimeInterval time = ([[NSDate date] timeIntervalSince1970] - needleLastMoved);
        double direction = (needleVelocity < 0.0) ? -1.0 : ((needleVelocity > 0.0) ? 1.0 : 0.0);
 
        needleAcceleration = 5.0 * (_value - currentValue);
        currentValue += needleVelocity * time;
        needleVelocity += needleAcceleration * time * 2.0;
        
        if ((_value - currentValue) * direction < 0.1 * direction)
        {
            currentValue = _value;
            needleVelocity = 0.0;
            needleAcceleration = 0.0;
            needleLastMoved = -1;
        }
        else
        {
            needleLastMoved =  [[NSDate date] timeIntervalSince1970];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self setNeedsDisplay];
        });
    }
    else
    {
        needleLastMoved =  [[NSDate date] timeIntervalSince1970];
        [self computeCurrentValue];
    }
}

- (UIColor*)rangeColorForValue:(float)value
{
    NSInteger length = _rangeValues.count;
    for (int i = 0; i < length - 1; i++)
    {
        if (value < [_rangeValues[i] floatValue])
            return _rangeColors[i];
    }
    if (value <= [_rangeValues[length - 1] floatValue])
        return _rangeColors[length - 1];
    return nil;
}

- (void)invalidateBackground
{
    background = nil;
    [self initDrawingRects];
    [self initScale];
    [self setNeedsDisplay];
}

#pragma mark - Properties

- (void)setValue:(float)value
{
    if (value > _maxValue)
        _value = _maxValue;
    else if (value < _minValue)
        _value = _minValue;
    else
        _value = value;
    
    needleVelocity = 0.0;
    needleAcceleration = 0.0;
    needleLastMoved = -1;
    
    [self setNeedsDisplay];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    self.value = value;
    if (!animated)
        currentValue = _value;
}

- (void)setShowInnerBackground:(bool)showInnerBackground
{
    _showInnerBackground = showInnerBackground;
    [self invalidateBackground];
}

- (void)setShowInnerRim:(bool)showInnerRim
{
    _showInnerRim = showInnerRim;
    [self invalidateBackground];
}

- (void)setInnerRimWidth:(CGFloat)innerRimWidth
{
    _innerRimWidth = innerRimWidth;
    [self invalidateBackground];
}

- (void)setInnerRimBordeWidth:(CGFloat)innerRimBorderWidth
{
    _innerRimBorderWidth = innerRimBorderWidth;
    [self invalidateBackground];
}

- (void)setNeedleWidth:(CGFloat)needleWidth
{
    _needleWidth = needleWidth;
    [self setNeedsDisplay];
}

- (void)setNeedleHeight:(CGFloat)needleHeight
{
    _needleHeight = needleHeight;
    [self setNeedsDisplay];
}

- (void)setNeedleScrewRadius:(CGFloat)needleScrewRadius
{
    _needleScrewRadius = needleScrewRadius;
    [self setNeedsDisplay];
}

- (void)setScalePosition:(CGFloat)scalePosition
{
    _scalePosition = scalePosition;
    [self invalidateBackground];
}

- (void)setScaleStartAngle:(CGFloat)scaleStartAngle
{
    _scaleStartAngle = scaleStartAngle;
    [self invalidateBackground];
}

- (void)setScaleEndAngle:(CGFloat)scaleEndAngle
{
    _scaleEndAngle = scaleEndAngle;
    [self invalidateBackground];
}

- (void)setScaleDivisions:(CGFloat)scaleDivisions
{
    _scaleDivisions = scaleDivisions;
    [self invalidateBackground];
}

- (void)setScaleSubdivisions:(CGFloat)scaleSubdivisions
{
    _scaleSubdivisions = scaleSubdivisions;
    [self invalidateBackground];
}

- (void)setRangeLabelsWidth:(CGFloat)rangeLabelsWidth
{
    _rangeLabelsWidth = rangeLabelsWidth;
    [self invalidateBackground];
}

- (void)setMinValue:(float)minValue
{
    _minValue = minValue;
    [self invalidateBackground];
}

- (void)setMaxValue:(float)maxValue
{
    _maxValue = maxValue;
    [self invalidateBackground];
}

- (void)setRangeValues:(NSArray *)rangeValues
{
    _rangeValues = rangeValues;
    [self invalidateBackground];
}

- (void)setRangeColors:(NSArray *)rangeColors
{
    _rangeColors = rangeColors;
    [self invalidateBackground];
}

- (void)setRangeLabels:(NSArray *)rangeLabels
{
    _rangeLabels = rangeLabels;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    _unitOfMeasurement = unitOfMeasurement;
    [self invalidateBackground];
}

@end
