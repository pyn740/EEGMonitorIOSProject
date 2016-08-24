//
//  NCIAxis.m
//  NCIChart
//
//  Created by Ira on 4/15/14.
//  Copyright (c) 2014 FlowForwarding.Org. All rights reserved.
//

#import "NCIAxis.h"
#import "NCIChartOptions.h"
#import "NCISimpleGraphView.h"
#import "NCISimpleGridView.h"

//TODO make 2 objects for NCIXAxis and NCIYAxis
@interface NCIAxis()

@property(nonatomic)bool invertedLabes;
@property(nonatomic, strong)UIFont* labelsFont;
@property(nonatomic, strong)UIColor* labelsColor;
@property(nonatomic, copy) NSString* (^labelRenderer)(double);
@property(nonatomic)bool nciUseDateFormatter;
@property(nonatomic)float labelsDistance;
@property(nonatomic)float nciAxisShift;

@property(nonatomic)float labelWidth;
@property(nonatomic)float labelHeight;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic) double dimention;
@property(nonatomic) double step;

@end

@implementation NCIAxis

- (id)initWithOptions:(NSDictionary *)options{
    if (self = [super initWithOptions:options]){
        _nciAxisShift = NAN;
        _dateFormatter = [[NSDateFormatter alloc] init];
        _labels = [[NSMutableArray alloc] init];
        _xlabels = [[NSMutableArray alloc] init];
        _ylabels = [[NSMutableArray alloc] init];
        
        if ([options objectForKey:nciInvertedLabes])
            _invertedLabes = [[options objectForKey:nciInvertedLabes] boolValue];
        
        if ([options objectForKey:nciUseDateFormatter])
            _nciUseDateFormatter = [[options objectForKey:nciUseDateFormatter] boolValue];
        
        if ([options objectForKey:nciLabelRenderer])
            _labelRenderer = [options objectForKey:nciLabelRenderer] ;
        
        if ([options objectForKey:nciAxisDecreasing])
            _nciAxisDecreasing = [[options objectForKey:nciAxisDecreasing] boolValue];
        
        if ([options objectForKey:nciLabelsFont]){
            _labelsFont = [options objectForKey:nciLabelsFont];
        } else {
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
               _labelsFont = [UIFont italicSystemFontOfSize:14];
             } else {
                _labelsFont = [UIFont italicSystemFontOfSize:10];
             }
        }
        
        if ([options objectForKey:nciLabelsColor]){
            _labelsColor = [options objectForKey:nciLabelsColor];
        } else {
            _labelsColor = [UIColor blackColor];
        }
        
        
        if ([options objectForKey:nciAxisShift])
            _nciAxisShift = [[options objectForKey:nciAxisShift] floatValue];
        
        if ([options objectForKey:nciLabelsDistance]){
            _labelsDistance = [[options objectForKey:nciLabelsDistance] floatValue];
        } else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                 _labelsDistance = 150;
            } else {
                 _labelsDistance = 60;
            }
        }
    }
    return self;
}

- (void)setChart:(NCISimpleChartView *)chart{
    _chart = chart;
    if (self.vertical){
        _labelHeight = _labelsDistance;
        
        if (_nciAxisShift == _nciAxisShift){
            
            _labelWidth = _nciAxisShift + self.chart.nciGridLeftMargin;
        } else {
            _labelWidth = self.chart.nciGridLeftMargin-5;
        }
    } else {
        _labelHeight =  self.chart.nciGridBottomMargin;
        _labelWidth =  _labelsDistance;
    }
}

-(void)initXAndYLabel:(float)length{
    _dimention = length;
    if (self.vertical){
        if (!self.chart.nciHasHorizontalGrid)
            return;
        for(int i = 0; i < 5; i++){
            float yPos = length - i*_labelsDistance - _labelsDistance/2 + self.chart.nciGridTopMargin;
            
            double curVal = -0.02 + 0.01 *i;
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, yPos, _labelWidth - 4, _labelHeight)];
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = _labelsColor;
            label.font = _labelsFont;
            label.text = [NSString stringWithFormat:@"%0.2f", curVal];
            
            [self.ylabels addObject:label];
            [self.chart addSubview:label];
        }
    }else {
        for(int i = 0; i< 9; i++){
            float xPos = self.chart.nciGridLeftMargin+10-20 + _labelsDistance *i;
            if (xPos > (length + self.chart.nciGridLeftMargin - _labelsDistance/2))
                continue;
            float yPos = self.chart.nciGridTopMargin + 80;
            UILabel *label = [[UILabel alloc] initWithFrame:
                         CGRectMake(xPos, yPos, _labelWidth, _labelHeight)];
            double curVal = i;
            
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = _labelsColor;
            label.font = _labelsFont;
            
            label.text = [NSString stringWithFormat:@"%0.1f", curVal];
            [self.xlabels addObject:label];
            [self.chart addSubview:label];
        }
    }
}

- (void)redrawLabels:(float)length min:(double)min max:(double)max{
    _step = length/(max - min);
    
    if (self.vertical){
        if (!self.chart.nciHasHorizontalGrid)
            return;
        for(int i = 0; i < 5; i++){
            //NSLog(@"_labelsDistance:%f",_labelsDistance);
            double curVal = [self.chart.graph getValByY: _labelsDistance*i];
            if (fabs(curVal) >= 1 || fabs(curVal) == 0) {
                [((UILabel *)self.ylabels[i]) setText:[NSString stringWithFormat:@"%d",(int)curVal]];
            }else{
                [((UILabel *)self.ylabels[i]) setText:[NSString stringWithFormat:@"%0.2f",curVal]];
            }
            
        }
    } else {
        for(int i = 0; i< 9; i++){
            
            double curVal;
            if ([_chart.chartData queueLength] < 50) {
                curVal = i;
            }else{
                
                curVal = i +[((NSArray *)[_chart.chartData currentItemWithNum:0])[0] doubleValue];
                
                
            }
            [((UILabel *)self.xlabels[i]) setText:[NSString stringWithFormat:@"%.1f",curVal]];
        }
    }
    
}

- (void)formatDateForDistance{
    if ((1/_step * _labelsDistance) < 60*60*24){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm"];
    } else if ((1/_step * _labelsDistance) < 60*60*24*30){
        [_dateFormatter setDateFormat:@"yyyy-MMM-dd"];
    } else {
        [_dateFormatter setDateFormat:@"yyyy-MMM"];
    }
}

- (void)drawBoundary:(CGContextRef ) currentContext{
    [self setUpLine:currentContext];
    if (_vertical){
        if (_nciAxisShift != _nciAxisShift){
             _nciAxisShift = 0;
        }
        CGContextMoveToPoint(currentContext, _nciAxisShift, 0);
        CGContextAddLineToPoint(currentContext, _nciAxisShift, _dimention);
        CGContextStrokePath(currentContext);
    } else {
        if (_nciAxisShift != _nciAxisShift)
            _nciAxisShift = self.chart.graph.grid.frame.size.height;
        CGContextMoveToPoint(currentContext, 0, _nciAxisShift);
        CGContextAddLineToPoint(currentContext, _dimention, _nciAxisShift);
        CGContextStrokePath(currentContext);
    }
}

@end
