//
//  NCISimpleGridView.m
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCISimpleGridView.h"

@interface NCISimpleGridView(){

}

@end

@implementation NCISimpleGridView


- (id)initWithGraph:(NCISimpleGraphView *) ncigraph{
    self = [self initWithFrame:CGRectZero];
    if (self){
        self.graph = ncigraph;
        [self setBgColor];
    }
    return self;
}

- (void)setBgColor{
    if (self.graph.chart.nciGridColor){
        self.backgroundColor = self.graph.chart.nciGridColor;
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self setBgColor];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [self.graph.chart.yAxis drawBoundary:currentContext];
    [self.graph.chart.xAxis drawBoundary:currentContext];
    
    [self drawGraphLine:[self.graph getFirstLast]];
    
    [self setHorizontalGrid:currentContext];
    [self setVerticalGrid:currentContext];
}

//pragma draw grid
- (void)setVerticalGrid:(CGContextRef) currentContext{
    [self.graph.chart.nciGridVertical setUpLine:currentContext];
    float labelWidth = 0;
    if (_graph.chart.xAxis.xlabels.count > 0){
        
         labelWidth = ((UILabel *)_graph.chart.xAxis.xlabels[0]).frame.size.width;
    }
    for (int i=0; i < _graph.chart.xAxis.xlabels.count; i++){
        UILabel *xLabel = _graph.chart.xAxis.xlabels[i];
        if (xLabel.frame.origin.x - _graph.chart.nciGridLeftMargin + labelWidth/2 == 0)
            continue;
        CGContextMoveToPoint(currentContext, xLabel.frame.origin.x - _graph.chart.nciGridLeftMargin
                             + labelWidth/2, _graph.chart.graph.frame.size.height);
        CGContextAddLineToPoint(currentContext, xLabel.frame.origin.x - _graph.chart.nciGridLeftMargin
                                + labelWidth/2, 0);
    }
    CGContextStrokePath(currentContext);
}

- (void)setHorizontalGrid:(CGContextRef) currentContext{
    [self.graph.chart.nciGridHorizontal setUpLine:currentContext];
    float labelHeight = 0;
    if (_graph.chart.yAxis.ylabels.count > 0){
        labelHeight = ((UILabel *)_graph.chart.yAxis.ylabels[0]).frame.size.height;
    }
      for (int i=1; i < _graph.chart.yAxis.ylabels.count; i++){
        UILabel *yLabel = _graph.chart.yAxis.ylabels[i];
        CGContextMoveToPoint(currentContext, 0, yLabel.frame.origin.y + labelHeight/2 - self.graph.chart.nciGridTopMargin);
        CGContextAddLineToPoint(currentContext, self.frame.size.width, yLabel.frame.origin.y + labelHeight/2 - self.graph.chart.nciGridTopMargin);
    }
    CGContextStrokePath(currentContext);
}

- (void)drawGraphLine:(NSArray *)firstLast{
    for (UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    
    int lastMoveInd = [firstLast[0] intValue] - 1;
    int firstInd = [firstLast[0] intValue];
    
    for (int ind = firstInd; ind < [firstLast[1] integerValue]; ind++){
        
        NSArray *points = (NSArray *)[_graph.chart.chartData currentItemWithNum:ind];
        NSUInteger point1Count = ((NSArray *)points[1]).count;
        for (int i = 0; i< point1Count; i++){
            id val = points[1][i];
            UIBezierPath *path;
            if (paths.count <= i){
                path = [UIBezierPath bezierPath];
                [path setLineWidth: [self lineWidth:i]];
                [paths addObject:path];
            } else {
                path = paths[i];
            };
            CGPoint pointP = [_graph pointByValueInGrid:@[points[0], val]];
            if ([val isKindOfClass:[NSNull class]] ){
                if (lastMoveInd != (ind -1) && [self fillSeries:i]){
                    [path addLineToPoint:CGPointMake(path.currentPoint.x, self.frame.size.height)];
                    [path moveToPoint: pointP];
                }
                lastMoveInd = ind;
            } else {
//                if (self.graph.chart.nciShowPoints)
//                    [self createPoint:pointP num:i];
                if (lastMoveInd == (ind -1)){
                    if ([self fillSeries:i]){
                        [path moveToPoint: CGPointMake(pointP.x, self.frame.size.height)];
                    } else {
                        [path moveToPoint:pointP];
                    }
                }
                
                if ([self smoothSeries:i]){
                    CGPoint nextPoint = (ind >= ([_graph.chart.chartData queueLength] -1)) ? pointP :
                    [_graph pointByValueInGrid:@[((NSArray *)[_graph.chart.chartData currentItemWithNum:ind+1])[0], ((NSArray *)[_graph.chart.chartData currentItemWithNum:ind+1])[1][i]]];
                    
                    CGPoint prevPoint = (ind < 1) ? pointP :
                    [_graph pointByValueInGrid:@[((NSArray *)[_graph.chart.chartData currentItemWithNum:ind-1])[0], ((NSArray *)[_graph.chart.chartData currentItemWithNum:ind-1])[1][i]]];
                    float y;
                    
                    if (nextPoint.y > pointP.y){
                        y = (pointP.y  +nextPoint.y)/2 - fabs(pointP.y - nextPoint.y)/2;
                    } else {
                        y = (pointP.y  +nextPoint.y)/2  + fabs(pointP.y - nextPoint.y)/2;
                    }
                    CGPoint nextControlPoint = CGPointMake( pointP.x + (pointP.x - nextPoint.x)/2, y);
                    
                    if (prevPoint.y < pointP.y){
                        y = (pointP.y  +prevPoint.y)/2  - fabs(pointP.y - prevPoint.y)/2;
                    } else {
                        y = (pointP.y  +prevPoint.y)/2  + fabs(pointP.y - prevPoint.y)/2;
                    }
                    CGPoint prevControlPoint  = CGPointMake(prevPoint.x + (pointP.x - prevPoint.x)/2,  y);
                    
                    [path addCurveToPoint:pointP controlPoint1:prevControlPoint controlPoint2:nextControlPoint];
                    
                } else {
                    [path addLineToPoint:pointP];
                    //NSLog(@"%@",[NSThread currentThread]);
                }

            }
        }
    }
    
    for (int i= 0; i < paths.count; i++){
        UIBezierPath *path = paths[i];
        UIColor *color = [self getColor:i];
        if ([self fillSeries:i] && !path.empty){
            [[color colorWithAlphaComponent:0.1] setFill];
            if (path.currentPoint.x == path.currentPoint.x)
                [path addLineToPoint:CGPointMake( path.currentPoint.x, self.frame.size.height)];
            [path fill];
            [path closePath];
        }
        [color setStroke];
        [path stroke];
    }
}

- (bool)smoothSeries:(int)seriesNum{
    if (self.graph.chart.nciIsSmooth.count <= seriesNum){
        [self.graph.chart.nciIsSmooth addObject:@NO];
    }
    return [self.graph.chart.nciIsSmooth[seriesNum] boolValue];
}

- (bool)fillSeries:(int)seriesNum{
    if (self.graph.chart.nciIsFill.count <= seriesNum){
        [self.graph.chart.nciIsFill addObject:@YES];
    }
    return [self.graph.chart.nciIsFill[seriesNum] boolValue];
}

- (void)createPoint:(CGPoint )point num:(int)num{
    float dim = 4;
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(point.x - dim/2, point.y - dim/2, dim, dim)];
    pointView.backgroundColor = [self getColor:num];
    [self addSubview:pointView];
}

//@pragma series properties
- (float )lineWidth:(int) i{
    float returnWidth;
    if (self.graph.chart.nciLineWidths &&
        (self.graph.chart.nciLineWidths.count > i) &&
        (![self.graph.chart.nciLineWidths[i] isKindOfClass:[NSNull class]])){
        returnWidth = [self.graph.chart.nciLineWidths[i] floatValue];
    } else {
        returnWidth = [self.graph.chart.nciLineWidths[0] floatValue];
    }
    return returnWidth;
}

- (UIColor *)getColor:(int) i{
    if (self.graph.chart.nciLineColors.count > i && ![self.graph.chart.nciLineColors[i] isKindOfClass:[NSNull class]]){
       return self.graph.chart.nciLineColors[i];
    } else {
        UIColor *newColor = [UIColor colorWithRed:(arc4random() % 255)/255.0f
                                            green:(arc4random() % 255)/255.0f
                                             blue:(arc4random() % 255)/255.0f alpha:1.0];
        if (self.graph.chart.nciLineColors.count > i){
             [self.graph.chart.nciLineColors replaceObjectAtIndex:i withObject:newColor];
        } else {
            [self.graph.chart.nciLineColors addObject:newColor];
        }
        return newColor;
    }
}

@end
