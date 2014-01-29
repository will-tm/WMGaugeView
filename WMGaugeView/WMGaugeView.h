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

#import <UIKit/UIKit.h>

@interface WMGaugeView : UIView

@property (nonatomic) bool showInnerBackground;
@property (nonatomic) bool showInnerRim;
@property (nonatomic) CGFloat innerRimWidth;
@property (nonatomic) CGFloat innerRimBorderWidth;

@property (nonatomic) CGFloat needleWidth;
@property (nonatomic) CGFloat needleHeight;
@property (nonatomic) CGFloat needleScrewRadius;

@property (nonatomic) CGFloat scalePosition;
@property (nonatomic) CGFloat scaleStartAngle;
@property (nonatomic) CGFloat scaleEndAngle;
@property (nonatomic) CGFloat scaleDivisions;
@property (nonatomic) CGFloat scaleSubdivisions;

@property (nonatomic) CGFloat rangeLabelsWidth;

@property (nonatomic) float value;
@property (nonatomic) float minValue;
@property (nonatomic) float maxValue;

@property (nonatomic, strong) NSArray *rangeValues;
@property (nonatomic, strong) NSArray *rangeColors;
@property (nonatomic, strong) NSArray *rangeLabels;

@property (nonatomic, strong) NSString *unitOfMeasurement;

- (void)setValue:(float)value animated:(BOOL)animated;

@end
