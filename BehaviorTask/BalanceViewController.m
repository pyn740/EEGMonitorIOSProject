//
//  BalanceViewController.m
//  nirsit
//
//  Created by admin on 15/10/4.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "BalanceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "THProgressView.h"
#import "TriDicView.h"
#import "Constants.h"

@interface BalanceViewController ()<updateDelegate>{
    UIView * tabProcessView;
    UILabel * timeProcessLabel;
    THProgressView *progressView;
    int progress;
    NSTimer * timer;
    int startFlag;
    NSString * tableName;
    AVPlayer * player;
}

@end

@implementation BalanceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ableRightBottomView];
    [self modifyRightLabel:@"START"];
    [self modifyRightImg:@"startImg"];
    
    
    tabProcessView = [[UIView alloc] initWithFrame:CGRectMake((1024-PROGRESSLENGTH-120)/2.0, 675, PROGRESSLENGTH+120, 50)];
    [self.view addSubview:tabProcessView];
    
    timeProcessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 60, 20)];
    timeProcessLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Medium" size:17];
    timeProcessLabel.textAlignment = NSTextAlignmentCenter;
    timeProcessLabel.textColor = [UIColor whiteColor];
    [tabProcessView addSubview:timeProcessLabel];
    
    progressView = [[THProgressView alloc] initWithFrame:CGRectMake(60, 15, PROGRESSLENGTH, 20)];
    progressView.borderTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0];
    [tabProcessView addSubview:progressView];
    
    UILabel * timetotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(PROGRESSLENGTH+60, 15, 60, 20)];
    timetotalLabel.text = @"02:25";
    timetotalLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:17];
    timetotalLabel.textAlignment = NSTextAlignmentCenter;
    timetotalLabel.textColor = [UIColor whiteColor];
    [tabProcessView addSubview:timetotalLabel];
    
    TriDicView * taskStartPop = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/145.0*30-10/2.0, 5, 10, 10)];
    taskStartPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskStartPop];
    
    TriDicView * taskEndPop = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/145.0*53-10/2.0, 5, 10, 10)];
    taskEndPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskEndPop];
    
    TriDicView * taskStartPop1 = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/145.0*87-10/2.0, 5, 10, 10)];
    taskStartPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskStartPop1];
    
    TriDicView * taskEndPop1 = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/145.0*110-10/2.0, 5, 10, 10)];
    taskEndPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskEndPop1];
    
    tabProcessView.hidden = YES;
    [self allInit];
    
    if ([[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
        _brainBtn.enabled = NO;
        tabProcessView.hidden = YES;
    }
    
    NSURL * movieUrl =[[NSBundle mainBundle] URLForResource:@"balanceTask" withExtension:@"mp4"];
    player = [AVPlayer playerWithURL:movieUrl];
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.movieView.bounds;
    [self.movieView.layer addSublayer:playerLayer];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });

//#if 0   //richard
    [[ApplicationInfo sharedInstance].someData readyToStart];
    self.unityView.hidden = YES;
    //GetAppController().unityView.frame = self.unityView.frame;
    [GetAppController().unityView setFrame:CGRectMake(self.unityView.frame.origin.x-28, self.unityView.frame.origin.y-75, self.unityView.frame.size.width, self.unityView.frame.size.height)];
    // This adds the UnityView finally
    [self.unityView addSubview:(UIView*)GetAppController().unityView];
    [self.unityView setNeedsLayout];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBrainBtn)];
    gesture.numberOfTouchesRequired = 1;
    [self.unityView addGestureRecognizer:gesture];
//#endif
}

-(void)allInit{
    startFlag = 0;
    progress = 0;
    timeProcessLabel.text = @"00:00";
    self.hintTextView.text = @"";
    [progressView setProgress:0.0f animated:YES]; // floating-point value between 0.0 and 1.0
    /*
    for (CALayer * layer in _movieView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"TakeTask";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ApplicationInfo sharedInstance].someData stopMeasure];
}

-(void)backToLastMenu:(id)sender{
    [timer invalidate];
    if (![[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
        [ApplicationInfo sharedInstance].someData.delegate = nil;
        if ([tableName length]) {
            [[ApplicationInfo sharedInstance].myDB deleteRowdataTable:tableName];
        }
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    if (startFlag == 0) {
        [self modifyRightLabel:@"STOP"];
        [self modifyRightImg:@"stopImg"];
        startFlag = 1;
        [player play];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(info) userInfo:nil repeats:YES];
        
        if (![[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
            long num =[[ApplicationInfo sharedInstance].myDB getCurrentRowDataTableCount];
            //NSLog(@"num:%ld",num);
            tableName =[NSString stringWithFormat:@"%ld",++ num];
            NSString * str = @"test_000000";
            tableName = [[str substringToIndex:(11-[tableName length])] stringByAppendingString:tableName];
            [[ApplicationInfo sharedInstance].myDB createRawDataTable:tableName];
            
            [ApplicationInfo sharedInstance].someData.delegate = self;
        }
    }else if (startFlag == 1) {
        [self modifyRightLabel:@"START"];
        [self modifyRightImg:@"startImg"];
        [timer invalidate];
        [self allInit];
        
        [player seekToTime:CMTimeMake(0, 1)];
        [player pause];
        
        if (![[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
            [ApplicationInfo sharedInstance].someData.delegate = nil;
            [[ApplicationInfo sharedInstance].myDB deleteRowdataTable:tableName];
        }
        
    }else if(startFlag == 2){
        if ([[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Summary"];
            [self performSegueWithIdentifier:@"testModeToSummary" sender:self];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Save"];
            [self performSegueWithIdentifier:@"toSaveDevice" sender:self];
        }
    }
    
}

- (IBAction)brainBtnSelected:(id)sender {
    _brainBtn.hidden = YES;
    self.unityView.hidden = NO;
    tabProcessView.hidden = NO;
}

-(void)showBrainBtn{
    _brainBtn.hidden = NO;
    self.unityView.hidden = YES;
    tabProcessView.hidden = YES;
}

-(void)info{
    
    progress += 1;
    
    if (progress <= 9) {
        timeProcessLabel.text = [@"00:0" stringByAppendingFormat:@"%d",progress];
    }else if (progress <= 59) {
        timeProcessLabel.text = [@"00:" stringByAppendingFormat:@"%d",progress];
    }else if (progress <= 69) {
        timeProcessLabel.text = [@"01:0" stringByAppendingFormat:@"%d",progress%60];
    }else  if (progress <= 119) {
        timeProcessLabel.text = [@"01:" stringByAppendingFormat:@"%d",progress%60];
    }else  if (progress <= 129) {
        timeProcessLabel.text = [@"02:0" stringByAppendingFormat:@"%d",progress%120];
    }else{
        timeProcessLabel.text = [@"02:" stringByAppendingFormat:@"%d",progress%120];
    }
    [progressView setProgress:progress/145.0 animated:YES];
    
    if (progress == 145) {
        [timer invalidate];
        startFlag = 2;
        [self modifyRightLabel:@"DONE"];
        [self modifyRightImg:@"right_arrow"];
        [ApplicationInfo sharedInstance].someData.delegate = nil;
    }
    switch (progress) {
        case 1:
        {
            self.hintTextView.text = @"BREATHE NORMALLY AT ALL TIMES";
            break;
        }
        case 30:
        {
            self.hintTextView.text = @"STAND ON ONE LEG AND BALANCE WITH EYES OPEN";
            break;
        }
        case 54:
        {
            self.hintTextView.text = @"PUT DOWN YOUR LEG AND STAND ON ALL TWO LEGS";
            break;
        }
        case 88:
        {
            self.hintTextView.text = @"STAND ON ONE LEG AND BALANCE WITH EYES CLOSED";
            break;
        }
        case 111:
        {
            self.hintTextView.text = @"STAND STILL";
            break;
        }
        default:
            break;
    }
}


-(void)getData:(NSString *)sth{
    
    [[ApplicationInfo sharedInstance].myDB insertTable:tableName andXvalue:[[NSDate date] timeIntervalSince1970] andRawdata:sth andMarker:0];
}

-(void)showTimeInfo:(double)time{
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]){
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:tableName forKey:@"itsTableName"];
        [destination setValue:@"task" forKey:@"whoComeIn"];
    }
}


@end
