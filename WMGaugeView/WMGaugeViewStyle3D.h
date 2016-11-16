/*
 * WMGaugeViewStyle3D.h
 *
 * Copyright (C) 2015 William Markezana <william.markezana@me.com>
 *
 */

#import <Foundation/Foundation.h>
#import "WMGaugeViewStyle.h"

@interface WMGaugeViewStyle3D : NSObject<WMGaugeViewStyle>

@property (nonatomic) CGFloat needleWidth;
@property (nonatomic) CGFloat needleHeight;
@property (nonatomic) CGFloat needleScrewRadius;

@property (nonatomic) UIColor* leftNeedleColor;
@property (nonatomic) UIColor* rightNeedleColor;

@property (nonatomic) UIColor* screwFillColor;
@property (nonatomic) UIColor* screwStrokeColor;

@property (nonatomic) UIColor* borderColor;
@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) NSArray<UIColor*>* faceGradientColors;
@property (nonatomic) NSArray<NSNumber*>* faceGradientPositions;
@property (nonatomic) NSArray<UIColor*>* faceShadowColors;
@property (nonatomic) NSArray<NSNumber*>* faceShadowPositions;

@end

