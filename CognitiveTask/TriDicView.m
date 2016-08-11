//
//  TriDicView.m
//  suanshu
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "TriDicView.h"

@implementation TriDicView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    CGPoint myPoint[3];
     myPoint[0] =CGPointMake(rect.origin.x, rect.origin.y);
     myPoint[1] =CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
     myPoint[2] =CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
    
     CGContextAddLines(ctx, myPoint, 3);
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, 8.0/255, 186.0/255, 78.0/255, 1);
    
    CGContextFillPath(ctx);

}


@end
