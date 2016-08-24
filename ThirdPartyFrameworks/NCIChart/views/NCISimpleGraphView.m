//
//  NCISimpleGraphView.m
//  NCIChart
//
//  Created by Ira on 12/20/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleGraphView.h"
#import "NCISimpleGridView.h"
#import "NCISimpleChartView.h"

@interface NCISimpleGraphView(){
    
}

@end

@implementation NCISimpleGraphView

- (void)addSubviews{
    self.grid = [[NCISimpleGridView alloc] initWithGraph:self];
    [self addSubview:self.grid];
    [self.chart.yAxis initXAndYLabel:80];
    [self.chart.xAxis initXAndYLabel:160];
}

- (id)initWithChart: (NCISimpleChartView *)chartHolder{
    self = [self initWithFrame:CGRectZero];
    if (self){
        _chart = chartHolder;
    
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
    }
    return  self;
}

- (void)layoutSubviews{
    _gridHeigth = self.frame.size.height;
    _gridWidth = self.frame.size.width;
    
    if ([_chart.chartData queueLength] > 0){
        _minXVal = [((NSArray *)[_chart.chartData currentItemWithNum:0])[0] doubleValue];
        //NSLog(@"minXVal:%f",_minXVal);
        _maxXVal = [((NSArray *)[_chart.chartData currentItemWithNum:[_chart.chartData queueLength]-1])[0] doubleValue];
        //NSLog(@"maxXVal:%f",_maxXVal);
        if (_maxXVal == _minXVal){
            _minXVal = _minXVal - 1;
            _maxXVal = _maxXVal + 1;
        }

        [self detectRanges];
        
        _yStep = _gridHeigth/(_maxYVal - _minYVal);
        [self.chart.yAxis redrawLabels:_gridHeigth min:_minYVal max:_maxYVal];
        _xStep = _gridWidth/8;
        [self.chart.xAxis redrawLabels:_gridWidth min:_minXVal max:_maxXVal];
    } else {

    }

    _grid.frame = CGRectMake(0, 0, _gridWidth, _gridHeigth);
   [_grid setNeedsDisplay];
}

- (void)detectRanges{
    _minYVal = -1 * _chart.largest;
    _maxYVal = _chart.largest;
}


- (CGPoint)pointByValueInGrid:(NSArray *)data{
    double argument = [data[0] doubleValue];
    if ([data[1] isKindOfClass:[NSNull class]] )
        return CGPointMake(NAN, NAN);
    float yVal;
    if (self.chart.yAxis.nciAxisDecreasing){
        yVal = (([data[1] floatValue] - _minYVal)*_yStep);
    } else {
        yVal = _gridHeigth - (([data[1] floatValue] - _minYVal)*_yStep);
    }
    
    float xVal = [self getXByArgument: argument];
    return CGPointMake(xVal, yVal);
}

- (double)getArgumentByX:(float) pointX{
    if (self.chart.xAxis.nciAxisDecreasing){
        return (_maxXVal - (pointX)/_xStep);
    } else {
        return (_minXVal + (pointX)/_xStep);
    }
}

- (float)getXByArgument:(double )arg{
    if (self.chart.xAxis.nciAxisDecreasing){
        return (_maxXVal  - arg)*_xStep;
    } else {
        return (arg  - _minXVal)*_xStep;
    }
}

- (float )getValByY:(float) pointY{
    if (self.chart.yAxis.nciAxisDecreasing){
        return _maxYVal - (pointY)/_yStep;
    } else {
        return _minYVal + (pointY)/_yStep;
    }
}

- (NSArray *)getFirstLast{
    return @[@(0), @([self.chart.chartData queueLength])];
}

@end
