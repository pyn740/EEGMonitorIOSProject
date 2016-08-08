//
//  Speedometer.h
//  nirsit
//
//  Created by admin admin on 15/11/24.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface Speedometer : UIView

@property(nonatomic)int PeakingMode;
@property(nonatomic,strong)CAShapeLayer * shapeLayer;
@property(nonatomic,strong)NSMutableArray * legendArr;
@property(nonatomic,strong)UILabel * currentSpeedLabel;
@property(nonatomic,strong)UILabel * maxChLabel;

@property (nonatomic)float currentSpeed;
@property (nonatomic)int peakingMode;
@property (nonatomic)int holdFlag;

-(instancetype)initWithOrigin:(CGPoint)origin;
-(void)speedChangedWithNewSpeed:(float)newSpeedValue andMaxCh:(int)maxChannel;

@end
