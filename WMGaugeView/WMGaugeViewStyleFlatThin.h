/*
 * WMGaugeViewStyleFlatThin.h
 *
 * Copyright (C) 2015 William Markezana <william.markezana@me.com>
 *
 */

#import <Foundation/Foundation.h>
#import "WMGaugeViewStyle.h"

@interface WMGaugeViewStyleFlatThin : NSObject<WMGaugeViewStyle>

@property (nonatomic) CGFloat needleWidth;
@property (nonatomic) CGFloat needleHeight;
@property (nonatomic) CGFloat needleScrewRadius;

@property (nonatomic) UIColor* needleColor;
@property (nonatomic) UIColor* needleScrewColor;

@property (nonatomic) CGFloat externalRingRadius;
@property (nonatomic) CGFloat internalRingRadius;

@property (nonatomic) UIColor* externalFaceColor;
@property (nonatomic) UIColor* internalFaceColor;

@property (nonatomic) UIColor* borderColor;
@property (nonatomic) CGFloat borderWidth;

@end
