/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

#import <UIKit/UIKit.h>

/**
 * Styling enumerations
 */
typedef enum
{
    WMGaugeViewSubdivisionsAlignmentTop,
    WMGaugeViewSubdivisionsAlignmentCenter,
    WMGaugeViewSubdivisionsAlignmentBottom
}
WMGaugeViewSubdivisionsAlignment;

typedef enum
{
    WMGaugeViewNeedleStyle3D,
    WMGaugeViewNeedleStyleFlatThin
}
WMGaugeViewNeedleStyle;

typedef enum
{
    WMGaugeViewNeedleScrewStyleGradient,
    WMGaugeViewNeedleScrewStylePlain
}
WMGaugeViewNeedleScrewStyle;

typedef enum
{
    WMGaugeViewInnerBackgroundStyleGradient,
    WMGaugeViewInnerBackgroundStyleFlat
}
WMGaugeViewInnerBackgroundStyle;

/**
 * WMGaugeView class
 */
@interface WMGaugeView : UIView

/**
 * WMGaugeView properties
 */
@property (nonatomic) bool showInnerBackground;
@property (nonatomic) bool showInnerRim;
@property (nonatomic) CGFloat innerRimWidth;
@property (nonatomic) CGFloat innerRimBorderWidth;
@property (nonatomic) WMGaugeViewInnerBackgroundStyle innerBackgroundStyle;

@property (nonatomic) CGFloat needleWidth;
@property (nonatomic) CGFloat needleHeight;
@property (nonatomic) CGFloat needleScrewRadius;
@property (nonatomic) WMGaugeViewNeedleStyle needleStyle;
@property (nonatomic) WMGaugeViewNeedleScrewStyle needleScrewStyle;

@property (nonatomic) CGFloat scalePosition;
@property (nonatomic) CGFloat scaleStartAngle;
@property (nonatomic) CGFloat scaleEndAngle;
@property (nonatomic) CGFloat scaleDivisions;
@property (nonatomic) CGFloat scaleSubdivisions;
@property (nonatomic) bool showScaleShadow;
@property (nonatomic) WMGaugeViewSubdivisionsAlignment scalesubdivisionsaligment;
@property (nonatomic) CGFloat scaleDivisionsLength;
@property (nonatomic) CGFloat scaleDivisionsWidth;
@property (nonatomic) CGFloat scaleSubdivisionsLength;
@property (nonatomic) CGFloat scaleSubdivisionsWidth;

@property (nonatomic, strong) UIColor *scaleDivisionColor;
@property (nonatomic, strong) UIColor *scaleSubDivisionColor;

@property (nonatomic, strong) UIFont *scaleFont;


@property (nonatomic) float value;
@property (nonatomic) float minValue;
@property (nonatomic) float maxValue;

@property (nonatomic) bool showRangeLabels;
@property (nonatomic) CGFloat rangeLabelsWidth;
@property (nonatomic, strong) UIFont *rangeLabelsFont;
@property (nonatomic, strong) UIColor *rangeLabelsFontColor;
@property (nonatomic) CGFloat rangeLabelsFontKerning;
@property (nonatomic, strong) NSArray *rangeValues;
@property (nonatomic, strong) NSArray *rangeColors;
@property (nonatomic, strong) NSArray *rangeLabels;

@property (nonatomic, strong) UIColor *unitOfMeasurementColor;
@property (nonatomic) CGFloat unitOfMeasurementVerticalOffset;
@property (nonatomic, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, strong) NSString *unitOfMeasurement;
@property (nonatomic) bool showUnitOfMeasurement;

/**
 * WMGaugeView public functions
 */
- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
