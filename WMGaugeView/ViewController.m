//
//  ViewController.m
//  WMGaugeView
//
//  Created by William Markezana on 28/01/14.
//  Copyright (c) 2014 Will™. All rights reserved.
//

#import "ViewController.h"
#import "WMGaugeView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface ViewController ()

@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gaugeView.maxValue = 240.0;
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeValues = @[ @50,                  @90,                @130,               @240.0              ];
    _gaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(232, 231, 33),  RGB(27, 202, 33),   RGB(231, 32, 43)    ];
    _gaugeView.rangeLabels = @[ @"VERY LOW",          @"LOW",             @"OK",              @"OVER FILL"        ];
    _gaugeView.unitOfMeasurement = @"psi";
    _gaugeView.showUnitOfMeasurement = YES;
    
    _gaugeView2.maxValue = 100.0;
    _gaugeView2.scaleDivisions = 10;
    _gaugeView2.scaleSubdivisions = 5;
    _gaugeView2.scaleStartAngle = 30;
    _gaugeView2.scaleEndAngle = 280;
    _gaugeView2.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    _gaugeView2.showScaleShadow = NO;
    _gaugeView2.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    _gaugeView2.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter;
    _gaugeView2.scaleSubdivisionsWidth = 0.002;
    _gaugeView2.scaleSubdivisionsLength = 0.04;
    _gaugeView2.scaleDivisionsWidth = 0.007;
    _gaugeView2.scaleDivisionsLength = 0.07;
    _gaugeView2.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    _gaugeView2.needleWidth = 0.012;
    _gaugeView2.needleHeight = 0.4;
    _gaugeView2.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    _gaugeView2.needleScrewRadius = 0.05;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(gaugeUpdateTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)gaugeUpdateTimer:(NSTimer *)timer
{
    _gaugeView.value = rand()%(int)_gaugeView.maxValue;
    [_gaugeView2 setValue:rand()%(int)_gaugeView2.maxValue animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView2 animation complete");
    }];
}

@end
