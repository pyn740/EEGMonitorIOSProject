//
//  StroopViewController.m
//  nirsit
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "StroopViewController.h"
#import "StroopPreScene.h"
#import "StroopGameScene.h"
#import "TriDicView.h"
#import "THProgressView.h"
#import "Constants.h"

@interface StroopViewController ()<updateDelegate>{
    SKView *gameView;
    int startFlag;
    int progress;
    NSTimer * timer;
    UIView * tabProcessView;
    UILabel * timeProcessLabel;
    THProgressView *progressView;
    NSString * tableName;
}

@end

@implementation StroopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ableRightBottomView];
    [self modifyRightLabel:@"START"];
    [self modifyRightImg:@"startImg"];
    
    tabProcessView = [[UIView alloc] initWithFrame:CGRectMake((1024-PROGRESSLENGTH-120)/2.0, 675, PROGRESSLENGTH+120, 70)];
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
    timetotalLabel.text = @"01:35";
    timetotalLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Medium" size:17];
    timetotalLabel.textAlignment = NSTextAlignmentCenter;
    timetotalLabel.textColor = [UIColor whiteColor];
    [tabProcessView addSubview:timetotalLabel];
    
    TriDicView * taskStartPop = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/95.0*30-10/2.0, 5, 10, 10)];
    taskStartPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskStartPop];
    
    TriDicView * taskEndPop = [[TriDicView alloc] initWithFrame:CGRectMake(60+PROGRESSLENGTH/95.0*75-10/2.0, 5, 10, 10)];
    taskEndPop.backgroundColor = [UIColor clearColor];
    [tabProcessView addSubview:taskEndPop];
    
    tabProcessView.hidden = YES;
    [self allInit];
    
    if ([[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
        _brainBtn.enabled = NO;
        tabProcessView.hidden = YES;
    }
    
//#if 0  //richard
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
    [progressView setProgress:0.0f animated:YES]; // floating-point value between 0.0 and 1.0
    [gameView removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addSKView];
    });
}

-(void)addSKView{
    
    gameView = [[SKView alloc] initWithFrame:CGRectMake(328, 35, 668, 605)];
    [self.view addSubview:gameView];
    
//    gameView.showsFPS = YES;
//    gameView.showsNodeCount = YES;
    gameView.ignoresSiblingOrder = YES;
    gameView.allowsTransparency =YES;
    
    // Create and configure the scene.
    StroopPreScene *scene = [StroopPreScene sceneWithSize:gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [gameView presentScene:scene];
    
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

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [timer invalidate];
    if (![[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
        [ApplicationInfo sharedInstance].someData.delegate = nil;
        [[ApplicationInfo sharedInstance].myDB deleteRowdataTable:tableName];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    
    if (startFlag == 0) {
        [self modifyRightLabel:@"STOP"];
        [self modifyRightImg:@"stopImg"];
        startFlag = 1;
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

#pragma mark - button click event

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
    }else{
        timeProcessLabel.text = [@"01:" stringByAppendingFormat:@"%d",progress%60];
    }
    [progressView setProgress:progress/95.0 animated:YES];
    
    if (progress == 95) {
        [timer invalidate];
        startFlag = 2;
        [self modifyRightLabel:@"DONE"];
        [self modifyRightImg:@"right_arrow"];
        [ApplicationInfo sharedInstance].someData.delegate = nil;
    }
    if (progress == 31) {
        StroopGameScene *scene = [StroopGameScene sceneWithSize:gameView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [gameView presentScene:scene];
    }
    
    if (progress == 76) {
        StroopPreScene *scene = [StroopPreScene sceneWithSize:gameView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.flag = 1;
        
        // Present the scene.
        [gameView presentScene:scene];
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
