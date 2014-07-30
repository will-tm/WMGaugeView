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
@property (nonatomic, readwrite, assign) bool showInnerBackground;
@property (nonatomic, readwrite, assign) bool showInnerRim;
@property (nonatomic, readwrite, assign) CGFloat innerRimWidth;
@property (nonatomic, readwrite, assign) CGFloat innerRimBorderWidth;
@property (nonatomic, readwrite, assign) WMGaugeViewInnerBackgroundStyle innerBackgroundStyle;
@property (nonatomic, readwrite, assign) CGFloat needleWidth;
@property (nonatomic, readwrite, assign) CGFloat needleHeight;
@property (nonatomic, readwrite, assign) CGFloat needleScrewRadius;
@property (nonatomic, readwrite, assign) WMGaugeViewNeedleStyle needleStyle;
@property (nonatomic, readwrite, assign) WMGaugeViewNeedleScrewStyle needleScrewStyle;
@property (nonatomic, readwrite, assign) CGFloat scalePosition;
@property (nonatomic, readwrite, assign) CGFloat scaleStartAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleEndAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisions;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisions;
@property (nonatomic, readwrite, assign) bool showScaleShadow;
@property (nonatomic, readwrite, assign) bool showScale;
@property (nonatomic, readwrite, assign) WMGaugeViewSubdivisionsAlignment scalesubdivisionsAligment;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsWidth;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsWidth;
@property (nonatomic, readwrite, strong) UIColor *scaleDivisionColor;
@property (nonatomic, readwrite, strong) UIColor *scaleSubDivisionColor;
@property (nonatomic, readwrite, strong) UIFont *scaleFont;
@property (nonatomic, readwrite, assign) float value;
@property (nonatomic, readwrite, assign) float minValue;
@property (nonatomic, readwrite, assign) float maxValue;
@property (nonatomic, readwrite, assign) bool showRangeLabels;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsWidth;
@property (nonatomic, readwrite, strong) UIFont *rangeLabelsFont;
@property (nonatomic, readwrite, strong) UIColor *rangeLabelsFontColor;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsFontKerning;
@property (nonatomic, readwrite, strong) NSArray *rangeValues;
@property (nonatomic, readwrite, strong) NSArray *rangeColors;
@property (nonatomic, readwrite, strong) NSArray *rangeLabels;
@property (nonatomic, readwrite, strong) UIColor *unitOfMeasurementColor;
@property (nonatomic, readwrite, assign) CGFloat unitOfMeasurementVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, readwrite, strong) NSString *unitOfMeasurement;
@property (nonatomic, readwrite, assign) bool showUnitOfMeasurement;

/**
 * WMGaugeView public functions
 */
- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

@end
