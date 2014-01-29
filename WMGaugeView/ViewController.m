//
//  ViewController.m
//  WMGaugeView
//
//  Created by William Markezana on 28/01/14.
//  Copyright (c) 2014 Will™. All rights reserved.
//

#import "ViewController.h"
#import "WMGaugeView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(gaugeUpdateTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)gaugeUpdateTimer:(NSTimer *)timer
{
    _gaugeView.value = rand()%(int)_gaugeView.maxValue;
}

@end
