//
//  Speedometer.m
//  nirsit
//
//  Created by admin admin on 15/11/24.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "Speedometer.h"

#define OFF_COLOR [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1]
#define ON_COLOR [UIColor whiteColor]
#define DEFAULT_MAX_SPEED 300

@interface Speedometer(){
    float centerX;
    float centerY;
    float radius;
    
    int maxCh;
    float maxScale;

    float maxSpeed;
    CGSize curSpdSize;
    UIBezierPath * offPath;
    UIBezierPath * onPath;
    
    CAShapeLayer *onshapeLayer;
}

@end

@implementation Speedometer

-(void)setCurrentSpeed:(float)currentSpeed{
  
    if (currentSpeed > maxScale) {
        _currentSpeed = maxScale;
    }else if(currentSpeed < 0){
        _currentSpeed = 0;
    }else{
        _currentSpeed = currentSpeed;
    }
}

-(instancetype)initWithOrigin:(CGPoint)origin{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.frame = CGRectMake(origin.x, origin.y, 184, 116);
        maxSpeed = DEFAULT_MAX_SPEED;
        _currentSpeed = 0;
        maxCh = 0;
        maxScale = 0.1;
        _peakingMode = 0;
        _holdFlag = 0;
        
        _legendArr = [[NSMutableArray alloc] init];
        
        [[self layer] setBorderColor:ON_COLOR.CGColor];
        [[self layer] setBorderWidth:2];
        [[self layer] setCornerRadius:5];
        
        offPath = [UIBezierPath bezierPath];
        offPath.lineWidth = 20.0;
        [offPath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 16) radius:65 startAngle:M_PI endAngle:0 clockwise:YES];
        onPath = [UIBezierPath bezierPath];
        
        [self drawLegend];
        [self drawHold];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    [self drawScaleBackground:self.bounds];
    [self drawScale:rect];
    [self drawReading1];
    [self drawReading2];
}


-(void)drawScaleBackground:(CGRect)rect{
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
     if (_PeakingMode == 0) {
     
     }else if (_PeakingMode == 1){
     
     }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, rect.size.width/2, rect.size.height - 16);
    CGContextScaleCTM(context, 1, -1);
    
    for (int i = 0; i < 90; i += 2) {
        CGContextAddArc(context, 0, 0, 65, M_PI-M_PI*i/90, M_PI-M_PI*(i+1)/90, 1);
        CGContextSetLineWidth(context, 20);
        CGContextSetStrokeColorWithColor(context, WHITECOLOR.CGColor);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    */
    
    /*
    [WHITECOLOR set];
    _offPath.lineWidth = 20.0;
    
    [_offPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height - 16) radius:65 startAngle:M_PI endAngle:0 clockwise:YES];
    
    CGFloat dash[]= {65*M_PI/90,65*M_PI/90};
    [_offPath setLineDash:dash count:2 phase:0];
    [_offPath stroke];
    */
    
    /*
    if (_PeakingMode == 0) {
        [self setBackgroundColor:[UIColor clearColor]];
    }else if (_PeakingMode == 1){
        [self setBackgroundColor:[UIColor colorWithRed:0 green:158.0/255 blue:219.0/255 alpha:1]];
    }
     */
    
    [self setBackgroundColor:[UIColor clearColor]];
    [OFF_COLOR set];
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = [offPath CGPath];
    [_shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithDouble:65*M_PI/90],nil]];
    _shapeLayer.lineDashPhase = 0;
    _shapeLayer.strokeColor = OFF_COLOR.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 20.0;
    [self.layer addSublayer:_shapeLayer];
}

-(void)drawScale:(CGRect)rect{
    
    onPath = [UIBezierPath bezierPath];
    onPath.lineWidth = 20.0;
    [onPath addArcWithCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 16) radius:65 startAngle:M_PI endAngle:M_PI+_currentSpeed/maxScale*M_PI clockwise:YES];
    [ON_COLOR set];
    onshapeLayer = [CAShapeLayer layer];
    onshapeLayer.path = [onPath CGPath];
    [onshapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithDouble:65*M_PI/90],nil]];
    onshapeLayer.lineDashPhase = 0;
    onshapeLayer.strokeColor = ON_COLOR.CGColor;
    onshapeLayer.fillColor = [UIColor clearColor].CGColor;
    onshapeLayer.lineWidth = 20.0;
    [self.layer addSublayer:onshapeLayer];

}

-(void)drawLegend{
    
    for (int i = 0 ; i <= 10; i ++) {
        NSString * digitText;
        if (i == 0) {
            digitText = @"0";
        }else{
            digitText = [NSString stringWithFormat:@"%.2f",i*0.01];
        }
        
        UIFont *font = [UIFont systemFontOfSize:7];
        CGSize size = [digitText sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
        
        UILabel * digitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, size.width, size.height)];
        [digitLabel setCenter:CGPointMake(-82*cos(M_PI*i/10), -82*sin(M_PI*i/10))];
        digitLabel.text = digitText;
        digitLabel.font = font;
        digitLabel.textColor = ON_COLOR;
        
        digitLabel.transform = CGAffineTransformRotate(CGAffineTransformMakeTranslation(self.bounds.size.width/2, self.bounds.size.height-18), -M_PI/2+M_PI*i/10);
        
        [self addSubview:digitLabel];
        [_legendArr addObject:digitLabel];
    }
}

-(void)drawReading1{
    
    NSString * currentSpeedText = [NSString stringWithFormat:@"%.3f",_currentSpeed];
    UIFont *font = [UIFont systemFontOfSize:28];
    CGSize size = [currentSpeedText sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    
    _currentSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, size.width, size.height)];
    [_currentSpeedLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 12 - size.height/2)];
    
    _currentSpeedLabel.font = font;
    _currentSpeedLabel.text = currentSpeedText;
    _currentSpeedLabel.textColor = ON_COLOR;
    
    [self addSubview:_currentSpeedLabel];
    
    curSpdSize = size;
    
}

-(void)drawReading2{
    NSString * maxChText;
    if (maxCh >= 10) {
        maxChText = [NSString stringWithFormat:@"CH %d",maxCh];
    }else{
        maxChText = [NSString stringWithFormat:@"CH 0%d",maxCh];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [maxChText sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    
    _maxChLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, size.width, size.height)];
    [_maxChLabel setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 10 - size.height/2-curSpdSize.height)];
    
    _maxChLabel.font = font;
    _maxChLabel.text = maxChText;
    _maxChLabel.textColor = ON_COLOR;
    
    [self addSubview:_maxChLabel];
}

-(void)drawHold{
    
    NSString * holdText = @"HOLD";
    
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [holdText sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    
    UILabel * holdLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - size.width-5, 5, size.width, size.height)];
    holdLabel.font = font;
    holdLabel.text = holdText;
    /*
    if (_holdFlag == 0) {
        holdLabel.textColor = [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1];
    }else if(_holdFlag == 1){
        holdLabel.textColor = ON_COLOR;
    }
    */
    holdLabel.textColor = ON_COLOR;
    [self addSubview:holdLabel];
}

-(void)speedChangedWithNewSpeed:(float)newSpeedValue andMaxCh:(int)maxChannel{
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self setCurrentSpeed:newSpeedValue];
    maxCh = maxChannel;
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    [onPath removeAllPoints];
    onPath = nil;
    [onshapeLayer removeFromSuperlayer];
    onshapeLayer = nil;
    /*
     NSEnumerator * iterator = [customView.legendArr objectEnumerator];
     id arrayObj = nil;
     while (arrayObj = [iterator nextObject]) {
     [arrayObj removeFromSuperview];
     }
     [customView.legendArr removeAllObjects];
     */
    
    [self.currentSpeedLabel removeFromSuperview];
    self.currentSpeedLabel = nil;
    [self.maxChLabel removeFromSuperview];
    self.maxChLabel = nil;
    [self setNeedsDisplay];
    //});
}

@end
