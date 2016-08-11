//
//  DicLabel.m
//  tryGame
//
//  Created by admin on 15/8/6.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "DicView.h"

@implementation DicView

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    /*
    CGPoint myPoint[7];
    myPoint[0] =CGPointMake(rect.origin.x, rect.origin.y);
    myPoint[1] =CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    myPoint[2] =CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2);
    myPoint[3] =CGPointMake(rect.origin.x+rect.size.width/5*3, rect.origin.y+rect.size.height/2);
    myPoint[4] =CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
    myPoint[5] =CGPointMake(rect.origin.x+rect.size.width/5*2, rect.origin.y+rect.size.height/2);
    myPoint[6] =CGPointMake(rect.origin.x, rect.origin.y+rect.size.height/2);
    CGContextAddLines(ctx, myPoint, 7);
    */
    CGFloat radius = 5,dicHeight = 10;
    CGContextMoveToPoint(ctx, rect.origin.x+radius , rect.origin.y);
    CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width - radius , rect.origin.y);
    CGContextAddArcToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.x+rect.size.width,rect.origin.y+radius, radius);
    CGContextAddLineToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y +rect.size.height-dicHeight - radius);
    CGContextAddArcToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y +rect.size.height-dicHeight, rect.origin.x+rect.size.width -radius, rect.origin.y +rect.size.height-dicHeight, radius);
    CGContextAddLineToPoint(ctx, rect.origin.x +rect.size.width/2+5, rect.origin.y +rect.size.height-dicHeight);
    CGContextAddLineToPoint(ctx, rect.origin.x +rect.size.width/2, rect.origin.y +rect.size.height);
    CGContextAddLineToPoint(ctx, rect.origin.x +rect.size.width/2-5, rect.origin.y +rect.size.height-dicHeight);
    CGContextAddLineToPoint(ctx, rect.origin.x + radius, rect.origin.y +rect.size.height-dicHeight);
    CGContextAddArcToPoint(ctx, rect.origin.x, rect.origin.y +rect.size.height-dicHeight,  rect.origin.x, rect.origin.y +rect.size.height-dicHeight -radius, radius);
    CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y +radius);
    CGContextAddArcToPoint(ctx, rect.origin.x,rect.origin.y, rect.origin.x+radius, rect.origin.y, radius);
    
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 8.0/255, 186.0/255, 78.0/255, 1);
    //CGContextSetRGBStrokeColor(ctx, 1, 0, 1, 1);
    //CGContextSetLineWidth(ctx, 2);
    CGContextFillPath(ctx);
    // CGContextStrokePath(ctx);
}

@end
