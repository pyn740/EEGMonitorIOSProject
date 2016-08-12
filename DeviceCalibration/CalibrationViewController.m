//
//  CalibrationViewController.m
//  nirsit
//
//  Created by admin on 15/7/24.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "CalibrationViewController.h"
#import "THProgressView.h"

# define EDGELENGTH 30
# define INTERVALLENGTH 20


@interface CalibrationViewController (){
    NSMutableArray * MyimageView;
    int twinkleFlag[4*16];
    CGFloat progress;
    THProgressView *progressView;
    NSArray *hideView;
    CGFloat process;
}

@end

@implementation CalibrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self modifyRightLabel:@"NEXT"];
    [self disableRightBottomView];
    
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"retry"] forState:UIControlStateSelected];
    
    progressView = [[THProgressView alloc] initWithFrame:CGRectMake(250, 690, 524, 20)];
    progressView.borderTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0];
    //[progressView setProgress:0.0f animated:YES];
    [self.view addSubview:progressView];
   
    NSUInteger twinkleLength = ([self.view bounds].size.width-EDGELENGTH*2-INTERVALLENGTH*15)/16;
    MyimageView = [[NSMutableArray alloc] initWithCapacity:4*16];
    hideView = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:14],[NSNumber numberWithInt:15],[NSNumber numberWithInt:300],[NSNumber numberWithInt:301],[NSNumber numberWithInt:314],[NSNumber numberWithInt:315], nil];
    for (int i = 0; i <4*16; i ++) {
        twinkleFlag[i] = -1;
    }
    
    for (NSUInteger i = 0; i < 4; i ++) {
        for (NSUInteger j = 0; j < 16; j ++) {
            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(EDGELENGTH + (twinkleLength + INTERVALLENGTH)* j, [self.view bounds].size.height/3.5 + (twinkleLength + INTERVALLENGTH) * i, twinkleLength, twinkleLength)];
            [img setImage:[UIImage imageNamed:@"twinkle0"]];
            img.tag = i*100+j;
            [MyimageView addObject:img];
            [self.view addSubview:img];
            for (NSNumber * shouldHideViewTag in hideView ) {
                if (img.tag == [shouldHideViewTag intValue]){
                    //[img setImage:[UIImage imageNamed:@"twinkle3"]];
                    [img setHidden:YES];
                }
            }
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"Calibration";
}

-(void)viewDidDisappear:(BOOL)animated{
    MyimageView = nil;
}


#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"PlotSetting"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SecondMode"];
    [self performSegueWithIdentifier:@"toSecondModeSegue" sender:self];
}

#pragma mark - button click event

- (IBAction)startBtnSelected:(id)sender {
    
    process = 0;
    [progressView setProgress:0.0f animated:YES];
    self.startBtn.enabled = NO;
    
    for (UIImageView * img in MyimageView) {
        NSArray * myImages = [NSArray arrayWithObjects:[UIImage imageNamed:[@"twinkle" stringByAppendingFormat:@"%d",arc4random()%3]],[UIImage imageNamed:[@"twinkle" stringByAppendingFormat:@"%d",arc4random()%3]],[UIImage imageNamed:[@"twinkle" stringByAppendingFormat:@"%d",arc4random()%3]], nil];
        img.animationImages = myImages;
        img.animationDuration = 0.25;
        img.animationRepeatCount = 0;
        [img startAnimating];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(info:) userInfo:nil repeats:YES];
}

-(void)info:(NSTimer *)timer{
    
    process += 0.1;
    [progressView setProgress:process/1.0 animated:YES];
    
    for (int i = 0; i < 4*16; i ++) {
        twinkleFlag[i] = 0;
    }
    
    if (process >= 1.0) {
        [timer invalidate];
        
        twinkleFlag[5] = arc4random()%2;
        twinkleFlag[40] = arc4random()%2;
        twinkleFlag[61] = arc4random()%2;
        
        for ( int i = 0; i <4*16; i ++) {
            if (i != 0 && i != 1 && i != 14 && i != 15 && i != 48 && i != 49 && i != 62 && i != 63) {
                switch (twinkleFlag[i]) {
                    case 0:
                    {
                        UIImageView * img = (UIImageView *)(MyimageView[i]);
                        [img stopAnimating];
                        [img setImage:[UIImage imageNamed:@"twinkle3"]];
                        break;
                    }
                    case 1:
                    {
                        UIImageView * img = (UIImageView *)(MyimageView[i]);
                        [img stopAnimating];
                        [img setImage:[UIImage imageNamed:@"twinkle4"]];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        
        [self.startBtn setSelected:YES];
        [self.startBtn setEnabled:YES];

        [self ableRightBottomView];
    }
}



@end
