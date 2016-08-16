//
//  MainMonitorViewController.m
//  nirsit
//
//  Created by admin on 15/9/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "MainMonitorViewController.h"
#import "NCISimpleChartView.h"
#import "Speedometer.h"
#import "THProgressView.h"
#import "Constants.h"

#define DENOMINATOR 1000.0

@interface MainMonitorViewController()<updateDelegate>{
    NSMutableArray * graphViewSeriesArr1, * graphViewSeriesArr2;
    NSMutableArray * replayData;
    NSMutableArray * allChartViews;
    NSTimer * timer;
    NCISimpleChartView *chart;
    
    double maxOxyAtMoment;
    double maxdeOxyAtMoment;
    double maxOxyForEntireTime;
    double maxdeOxyForEntireTime;
    int maxOxyChAtMoment;
    int maxOxyChForEntireTime;
    int maxdeOxyChAtMoment;
    int maxdeOxyChForEntireTime;
    Speedometer * peakMotor;
    
    THProgressView *progressView;
    UIButton * playBtn;
    NSUInteger maxCount;
    UILabel * timetotalLabel;
    BOOL replayFlag;
    
    NSString * tableName;
    dispatch_queue_t chartConcurrentDispatchcQuene;
    //dispatch_queue_t handleDataDispatchcQuene;
    NSTimer * replayTimer;
    int playIndex;
    int rowDataCount;
}
@property (weak, nonatomic) IBOutlet UIButton *dspBtn;
@property (weak, nonatomic) IBOutlet UIButton *mapBtn;

@property (weak, nonatomic) IBOutlet UIView *dspView;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *lpfBtn;
@property (weak, nonatomic) IBOutlet UIButton *mbllBtn;
@property (weak, nonatomic) IBOutlet UIButton *surConBtn;
@property (weak, nonatomic) IBOutlet UIButton *moCaliBtn;
@property (weak, nonatomic) IBOutlet UIButton *moComBtn;
@property (weak, nonatomic) IBOutlet UIButton *naCRBtn;
@property (weak, nonatomic) IBOutlet UIButton *heartBeatBtn;
@property (weak, nonatomic) IBOutlet UIButton *baseReBtn;

@property (weak, nonatomic) IBOutlet UIButton *biliIntBtn;
@property (weak, nonatomic) IBOutlet UIButton *simuDotBtn;
@property (weak, nonatomic) IBOutlet UIButton *alterDotBtn;
@property (weak, nonatomic) IBOutlet UIView *threValueView;
@property (weak, nonatomic) IBOutlet UIView *disDataView;
@property (weak, nonatomic) IBOutlet UIButton *actiModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *averModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *linMapBtn;
@property (weak, nonatomic) IBOutlet UIButton *comMapBtn;

@property (weak, nonatomic) IBOutlet UIButton *hboBtn;
@property (weak, nonatomic) IBOutlet UIButton *hbRBtn;
@property (weak, nonatomic) IBOutlet UIButton *hbTBtn;
@end

@implementation MainMonitorViewController


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        maxOxyAtMoment = -99999999;
        maxdeOxyAtMoment = -99999999;
        maxOxyForEntireTime = -99999999;
        maxdeOxyForEntireTime = -99999999;
        [ApplicationInfo sharedInstance].LPFOption = NO;
        [ApplicationInfo sharedInstance].MBLLOption = YES;
        [ApplicationInfo sharedInstance].InitHemo = YES;
        [ApplicationInfo sharedInstance].SurfaceContaminationOption = NO;
        [ApplicationInfo sharedInstance].MotionArtifactOption = NO;
        [ApplicationInfo sharedInstance].NAChannelRejection = YES;
        [ApplicationInfo sharedInstance].BilinearInterpolationOption = NO;
        [ApplicationInfo sharedInstance].SimultaneousDOTOption = NO;
        [ApplicationInfo sharedInstance].IterativeDOTOption = NO;
        [ApplicationInfo sharedInstance].peakingMotorOption = NO;
        [ApplicationInfo sharedInstance].NAFinish = NO;
        [ApplicationInfo sharedInstance].HeartBeat = NO;
        [ApplicationInfo sharedInstance].UpdateThreshold_linear = NO;
        [ApplicationInfo sharedInstance].Threshold_linear = 0.01;
        [ApplicationInfo sharedInstance].Dpdata = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    chartConcurrentDispatchcQuene = dispatch_queue_create("com.nirsit.chartConcurrentDispatchcQuene", DISPATCH_QUEUE_CONCURRENT);
    rowDataCount = 0;
    
    peakMotor = [[Speedometer alloc] initWithOrigin:CGPointMake(18, 485)];
    [self.view addSubview:peakMotor];
    
    NSLog(@"richard main monitor view controller ----viewDidLoad");   //richard
    
    [_dView.layer setCornerRadius:6.0];
    [_dView.layer setBorderWidth:2];
    [_dView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_taskView.layer setCornerRadius:6.0];
    [_taskView.layer setBorderWidth:2];
    [_taskView.layer setBorderColor:[UIColor whiteColor].CGColor];
    ((UIButton *)[_dView viewWithTag:5]).selected = YES;
    
    [self initChart];
    
    _yaxisBtn.selected = YES;
    GetAppController().unityView.frame = self.unityView.frame;
    [self.unityView addSubview:(UIView*)GetAppController().unityView];
    [self.unityView setNeedsLayout];

    _dspView.hidden = YES;
    _mapView.hidden = YES;
    
    [_lpfBtn.layer setCornerRadius:6.0];
    [_lpfBtn.layer setBorderWidth:2];
    [_lpfBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_mbllBtn.layer setCornerRadius:6.0];
    [_mbllBtn.layer setBorderWidth:2];
    [_mbllBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_surConBtn.layer setCornerRadius:6.0];
    [_surConBtn.layer setBorderWidth:2];
    [_surConBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_moCaliBtn.layer setCornerRadius:6.0];
    [_moCaliBtn.layer setBorderWidth:2];
    [_moCaliBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_moComBtn.layer setCornerRadius:6.0];
    [_moComBtn.layer setBorderWidth:2];
    [_moComBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_naCRBtn.layer setCornerRadius:6.0];
    [_naCRBtn.layer setBorderWidth:2];
    [_naCRBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_heartBeatBtn.layer setCornerRadius:6.0];
    [_heartBeatBtn.layer setBorderWidth:2];
    [_heartBeatBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_baseReBtn.layer setCornerRadius:6.0];
    [_baseReBtn.layer setBorderWidth:2];
    [_baseReBtn.layer setBorderColor:[UIColor whiteColor].CGColor];

    [_biliIntBtn.layer setCornerRadius:6.0];
    [_biliIntBtn.layer setBorderWidth:2];
    [_biliIntBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_simuDotBtn.layer setCornerRadius:6.0];
    [_simuDotBtn.layer setBorderWidth:2];
    [_simuDotBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_alterDotBtn.layer setCornerRadius:6.0];
    [_alterDotBtn.layer setBorderWidth:2];
    [_alterDotBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_threValueView.layer setCornerRadius:6.0];
    [_threValueView.layer setBorderWidth:2];
    [_threValueView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_disDataView.layer setCornerRadius:6.0];
    [_disDataView.layer setBorderWidth:2];
    [_disDataView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_actiModeBtn.layer setCornerRadius:6.0];
    [_actiModeBtn.layer setBorderWidth:2];
    [_actiModeBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_averModeBtn.layer setCornerRadius:6.0];
    [_averModeBtn.layer setBorderWidth:2];
    [_averModeBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_linMapBtn.layer setCornerRadius:6.0];
    [_linMapBtn.layer setBorderWidth:2];
    [_linMapBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_comMapBtn.layer setCornerRadius:6.0];
    [_comMapBtn.layer setBorderWidth:2];
    [_comMapBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    _hboBtn.selected = YES;
    if ([self.whoComeIn isEqualToString:@"ReplayMonitor"]) {
        [self.rightBottomView setHidden:YES];
        
        [_timeLabel setHidden:YES];
        replayFlag = YES;
        
        maxCount = [[ApplicationInfo sharedInstance].myDB getReplayDataCount:[self.replayDataInfo objectForKey:@"table_name"]];
        NSLog(@"maxCount:%lu",(unsigned long)maxCount);
        progressView = [[THProgressView alloc] initWithFrame:CGRectMake((1024-PROGRESSLENGTH)/2.0 , 690, PROGRESSLENGTH, 20)];
        progressView.borderTintColor = [UIColor whiteColor];
        progressView.progressTintColor = [UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0];
        [self.view addSubview:progressView];
        [progressView setProgress:0.0 animated:YES];
        
        playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setFrame:CGRectMake((1024-PROGRESSLENGTH)/2.0 - 40, 690, 20, 20)];
        [playBtn setImage:[UIImage imageNamed:@"whiteTri"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"whiteRect"] forState:UIControlStateSelected];
        [playBtn addTarget:self action:@selector(replayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playBtn];
        
        timetotalLabel = [[UILabel alloc] initWithFrame:CGRectMake((1024-PROGRESSLENGTH)/2.0 + PROGRESSLENGTH, 690, 100, 20)];
        timetotalLabel.text = @"00:00:00";
        timetotalLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:17];
        timetotalLabel.textAlignment = NSTextAlignmentCenter;
        timetotalLabel.textColor = [UIColor whiteColor];
        [self.view  addSubview:timetotalLabel];
    }else{
        
        [ApplicationInfo sharedInstance].someData.delegate = self;
        [[ApplicationInfo sharedInstance].someData readyToStart];
        [self startReadDataBase];
        [self modifyRightLabel:@"SAVE"];
    }
}

-(void)startReadDataBase{
    long num =[[ApplicationInfo sharedInstance].myDB getCurrentRowDataTableCount];
    //NSLog(@"num:%ld",num);
    tableName =[NSString stringWithFormat:@"%ld",++ num];
    NSString * str = @"test_000000";
    tableName = [[str substringToIndex:(11-[tableName length])] stringByAppendingString:tableName];
    [[ApplicationInfo sharedInstance].myDB createRawDataTable:tableName];
}

-(void)replayBtnClicked:(UIButton *)btn{
    if (!btn.selected) {
        playIndex = 0;
        btn.selected = YES;
        UnitySendMessage("BluethoothRecv","setX","0");
        UnitySendMessage("BluethoothRecv","resetBrain","1");
        UnitySendMessage("BluethoothRecv","replayStart","");
        replayTimer = [NSTimer scheduledTimerWithTimeInterval:0.1228 target:self selector:@selector(displayReplay:) userInfo:nil repeats:YES];
    
    }else{
        btn.selected = NO;
        [replayTimer invalidate];
        timetotalLabel.text = @"00:00:00";
        [progressView setProgress:0.0 animated:YES];
        //[self resetOptions];
        UnitySendMessage("BluethoothRecv","resetBrain","0");
        UnitySendMessage("BluethoothRecv","stopMeasure","");
    }
}

-(void)displayReplay:(NSTimer*)tim{
    
    NSDictionary * dic;
    dic = [[ApplicationInfo sharedInstance].myDB getReplayDataFromDataBase:[self.replayDataInfo objectForKey:@"table_name"] andIndex:++playIndex];
    UnitySendMessage("BluethoothRecv","read",[[dic valueForKey:@"raw_data"] UTF8String]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressView setProgress:(float)playIndex/maxCount animated:YES];
        //NSLog(@"playIndex:%d,",playIndex);
        //int num = (int)(playIndex * 0.1228);
        timetotalLabel.text = [self timeFormatted:(int)playIndex];
        if (playIndex == maxCount) {
            [tim invalidate];
            UnitySendMessage("BluethoothRecv","stopMeasure","");
        }
    });
}

-(void)resetOptions{
    [ApplicationInfo sharedInstance].LPFOption = NO;
    [ApplicationInfo sharedInstance].MBLLOption = NO;
    [ApplicationInfo sharedInstance].InitHemo = NO;
    [ApplicationInfo sharedInstance].SurfaceContaminationOption = NO;
    [ApplicationInfo sharedInstance].MotionArtifactOption = NO;
    [ApplicationInfo sharedInstance].NAChannelRejection = YES;
    [ApplicationInfo sharedInstance].BilinearInterpolationOption = NO;
    [ApplicationInfo sharedInstance].SimultaneousDOTOption = NO;
    [ApplicationInfo sharedInstance].IterativeDOTOption = NO;
    [ApplicationInfo sharedInstance].peakingMotorOption = NO;
    [ApplicationInfo sharedInstance].NAFinish = NO;
  
    maxOxyAtMoment = -99999999;
    maxdeOxyAtMoment = -99999999;
    maxOxyForEntireTime = -99999999;
    maxdeOxyForEntireTime = -99999999;
}

-(NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)initChart{
    self.myScroll.contentSize = CGSizeMake(3192, 645);
    allChartViews = [[NSMutableArray alloc] init];
    graphViewSeriesArr1 = [[NSMutableArray alloc] init];
    graphViewSeriesArr2 = [[NSMutableArray alloc] init];
    
    NSLog(@"richard main monitor view controller ----initChart");   //richard
    
    for (int i = 0; i < 48; i ++) {
        NSMutableArray * arr1 = [[NSMutableArray alloc] init];
        NSMutableArray * arr2 = [[NSMutableArray alloc] init];
        [graphViewSeriesArr1 addObject:arr1];
        [graphViewSeriesArr2 addObject:arr2];
    }
    //for (int i = 1; i < 2; i ++) {
    for (int i = 1; i < 49; i ++) {
        chart = [[NCISimpleChartView alloc] initWithFrame:CGRectMake(0, 0, 213, 150) andOptions:@{
                                                                                                  nciIsSmooth:@[@(NO),@(NO)],
                                                                                                  nciLineColor:@[[UIColor blueColor],[UIColor redColor]],
                                                                                                  nciShowPoints:@"NO",
                                                                                                  nciHasSelection:@YES,
                                                                                                  nciIsFill:@[@(NO),@(NO)],
                                                                                                  nciLineWidths:@[@(2),@(2)],
                                                                                                  nciGridHorizontal:@{
                                                                                                          nciLineColor:[UIColor whiteColor],
                                                                                                          nciLineDashes:@[@0],
                                                                                                          },
                                                                                                  nciGridVertical:@{
                                                                                                          nciLineColor:[UIColor whiteColor],
                                                                                                          nciLineDashes:@[@0],
                                                                                                          },
                                                                                                  nciXAxis:@{
                                                                                                          nciLineColor:[UIColor whiteColor],
                                                                                                          nciLabelsColor:[UIColor whiteColor],
                                                                                                          nciLineWidth:@2,
                                                                                                          nciLabelsDistance:@20,
                                                                                                          nciLineDashes:@[@0],
                                                                                                          nciLabelsFont:[UIFont systemFontOfSize:9],
                                                                                                          nciLabelRenderer:^(double value){
            return [NSString stringWithFormat:@"%.1f",value];}
                                                                                                          },
                                                                                                  nciYAxis:@{
                                                                                                          nciLineColor:[UIColor whiteColor],
                                                                                                          nciLabelsColor:[UIColor whiteColor],
                                                                                                          nciLineWidth:@2,
                                                                                                          nciLabelsDistance:@20,
                                                                                                          nciLineDashes:@[@0],
                                                                                                          nciLabelsFont:[UIFont systemFontOfSize:9],
                                                                                                          },
                                                                                                  nciGridTopMargin:@40,
                                                                                                  nciGridBottomMargin:@30,
                                                                                                  nciGridLeftMargin:@35,
                                                                                                  nciGridRightMargin:@18
                                                                                                  }];
        [(UIView *)[self.myScroll viewWithTag:i] addSubview:chart];
        [allChartViews addObject:chart];
    }
   /*
    for (int times = 0; times <= 80; times ++) {
        
        for (int channelNum = 0; channelNum < 48; channelNum ++) {
            [allChartViews[channelNum] addPoint:0   val:@[@(0),@(0)]];
        }
        
    }
    */
}


//random data
-(void)initChartData{
    
      NSLog(@"richard main monitor view controller ----initChartData");   //richard
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"richard main monitor view controller ----didReceiveMemoryWarning");   //richard
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"richard main monitor view controller ----animated");   //richard
    
    [ApplicationInfo sharedInstance].currentTitle = @"Measure";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGraphData:) name:@"UpdateGraphData" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
     //timer = [NSTimer scheduledTimerWithTimeInterval:0.1228 target:self selector:@selector(info) userInfo:nil repeats:YES];
    
    
    NSLog(@"richard main monitor view controller ----animated  2");   //richard
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"richard main monitor view controller ----animated  3");   //richard
    [playBtn setSelected:NO];
    [replayTimer invalidate];
    [[ApplicationInfo sharedInstance].someData stopGetDataFromDevice];
    [[ApplicationInfo sharedInstance].someData stopMeasure];
    //[[ApplicationInfo sharedInstance].myDB deleteRowdataTable:tableName];
    [ApplicationInfo sharedInstance].someData.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateGraphData" object:nil];
}

-(void)handleGraphData:(NSNotification *)dataSource{
    NSString * theString = [dataSource object];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self drawGraphData:theString];
    });
}

-(void)drawGraphData:(NSString *)theString{
    //NSLog(@"currentThread:%@",[NSThread currentThread]);
    //NSLog(@"Begin to draw chart:%f",[[NSDate date] timeIntervalSince1970]);
    
    //NSLog(@"richard main monitor view controller ----notification");   //richard
    NSString * arg;
    
    arg = theString;

    NSArray * args = [arg componentsSeparatedByString:@"/"];

    double x = [args[0] doubleValue];
    NSArray * y1 = [args[1] componentsSeparatedByString:@","];
    NSArray * y2 = [args[2] componentsSeparatedByString:@","];
    
    maxOxyAtMoment = -99999999;
    maxdeOxyAtMoment = -99999999;
    maxOxyChAtMoment = -99999999;
    maxdeOxyChAtMoment = -99999999;
    
    double startTime = [[NSDate date] timeIntervalSince1970];
    
#if 1   //richard
    for (int channelNum = 0;channelNum < 48;channelNum ++)  {
        
        double y1Value = [y1[channelNum] doubleValue];
        double y2Value = [y2[channelNum] doubleValue];
        //         NSLog(@"x,y1,y2:%f,%f,%f",x,y1Value,y2Value);
        if (maxOxyAtMoment < y1Value) {
            maxOxyAtMoment = y1Value;
            maxOxyChAtMoment = channelNum + 1;
        }
        if (maxdeOxyAtMoment < y2Value) {
            maxdeOxyAtMoment = y2Value;
            maxdeOxyChAtMoment = channelNum + 1;
        }
        
        [self appendDataToSeries:graphViewSeriesArr1[channelNum] andValue:[NSDictionary dictionaryWithObjectsAndKeys:args[0],@"x",[NSNumber numberWithDouble:y1Value],@"y", nil] andMaxLength:50];
        [self appendDataToSeries:graphViewSeriesArr2[channelNum] andValue:[NSDictionary dictionaryWithObjectsAndKeys:args[0],@"x",[NSNumber numberWithDouble:y2Value],@"y", nil] andMaxLength:50];
        
        double largest = 0.0;
          
        NSMutableArray * value1 = graphViewSeriesArr1[channelNum];
        for (int i = 0 ; i < [value1 count]; i ++) {

            if(fabs([[value1[i] objectForKey:@"y"] doubleValue]) > largest){
                largest = fabs([[value1[i] objectForKey:@"y"] doubleValue]);
            }
        }

        NSMutableArray * value2 = graphViewSeriesArr2[channelNum];
        for (int i = 0 ; i < [value2 count]; i ++) {
            if(fabs([[value2[i] objectForKey:@"y"] doubleValue]) > largest){
                largest = fabs([[value2[i] objectForKey:@"y"] doubleValue]);
            }
        }
        if (largest >= 0.02) {
            ((NCISimpleChartView *)allChartViews[channelNum]).largest = largest;
        }else{
            ((NCISimpleChartView *)allChartViews[channelNum]).largest = 0.02;
        }
#if 0
        
        NSOperationQueue *quene=[[NSOperationQueue alloc] init];
        quene.maxConcurrentOperationCount=28;
        
        NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{dispatch_async(dispatch_get_main_queue(), ^{
            
                [allChartViews[channelNum] addPoint:x  val:@[@(y1Value),@(y2Value)]];
                
                [self performSelectorOnMainThread:@selector(updateUI:) withObject:[NSNumber numberWithInt:channelNum] waitUntilDone:NO];

            });
            
        }];
        [quene addOperation:operation];
#endif
        /*
        dispatch_async(chartConcurrentDispatchcQuene, ^{
            [allChartViews[channelNum] addPoint:x  val:@[@(y1Value),@(y2Value)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUI:[NSNumber numberWithInt:channelNum]];
            });
        });
         */
        
        dispatch_async(chartConcurrentDispatchcQuene, ^{
            [allChartViews[channelNum] addPoint:x  val:@[@(y1Value),@(y2Value)]];
        });

        if (maxOxyForEntireTime < maxOxyAtMoment && peakMotor != nil) {
            [peakMotor setHoldFlag:0];
            maxOxyForEntireTime = maxOxyAtMoment;
            maxOxyChForEntireTime = maxOxyChAtMoment;
        }else if(peakMotor != nil){
            [peakMotor setHoldFlag:1];
        }
        if (maxdeOxyForEntireTime < maxdeOxyAtMoment && peakMotor != nil) {
            
            maxdeOxyForEntireTime = maxdeOxyAtMoment;
            maxdeOxyChForEntireTime = maxdeOxyChAtMoment;
        }
        
        if (![ApplicationInfo sharedInstance].peakingMotorOption && peakMotor != nil) {
           [peakMotor setHoldFlag:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [peakMotor speedChangedWithNewSpeed:(float)maxOxyAtMoment andMaxCh:maxOxyChAtMoment];
            });
            
        }else if(peakMotor != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
            [peakMotor speedChangedWithNewSpeed:(float)maxOxyForEntireTime andMaxCh:maxOxyChForEntireTime];
            });
        }
    }
#endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
    
    double endTime = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"drawTime:%fms",(endTime-startTime)*1000);
}

-(void)appendDataToSeries:(NSMutableArray *)series andValue:(NSDictionary *)value andMaxLength:(int)maxDataCount{
    int currentCount = [series count];
    //NSLog(@"currentCount:%d",currentCount);
    if (currentCount < maxDataCount) {
        [series addObject:value];
    }else{
        [series removeObjectAtIndex:0];
        [series addObject:value];
    }
}

-(void)updateUI:(NSNumber*)number{
    int i=[number intValue];
    [allChartViews[i] drawChart];
}

-(void)updateUI{
    NSEnumerator * iterator = [allChartViews objectEnumerator];
    id arrayObj = nil;
    while (arrayObj = [iterator nextObject]) {
        [arrayObj drawChart];
    }
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    if ([self.whoComeIn isEqualToString:@"FirstModeSelect"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"FirstMode"];
    }else if ([self.whoComeIn isEqualToString:@"SecondModeSelect"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SecondMode"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Replay"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Save"];
    [self performSegueWithIdentifier:@"toSaveInDeviceSegue" sender:self];
}


- (IBAction)firstBtnViewClicked:(UIButton *)sender {
    if (sender.tag == 5) {
        if (!sender.selected) {
            sender.selected = YES;
            ((UIButton *)[_dView viewWithTag:6]).selected = NO;
            _frontView.hidden = NO;
            _myScroll.hidden = YES;
        }
    }else{
        if (!sender.selected) {
            sender.selected = YES;
            ((UIButton *)[_dView viewWithTag:5]).selected = NO;
        }
        _frontView.hidden = YES;
        _myScroll.hidden = NO;
    }
}
- (IBAction)dspBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _mapBtn.selected =  NO;
        _dspView.hidden = NO;
        _mapView.hidden = YES;
    }else{
        sender.selected = NO;
        _dspView.hidden = YES;
        _mapView.hidden = YES;
    }
    
}
- (IBAction)mapBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _dspBtn.selected =  NO;
        _dspView.hidden = YES;
        _mapView.hidden = NO;
    }else{
        sender.selected = NO;
        _dspView.hidden = YES;
        _mapView.hidden = YES;
    }
}

- (IBAction)thirdBtnViewClicked:(UIButton *)sender {
    if (sender.tag == 5) {
        if (!sender.selected) {
            sender.selected = YES;
            ((UIButton *)[_taskView viewWithTag:6]).selected = NO;
        }
    }else{
        if (!sender.selected) {
            sender.selected = YES;
            ((UIButton *)[_taskView viewWithTag:5]).selected = NO;
        }
    }
}
/*
-(void)info{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [allDataArr removeObjectAtIndex:0];
    NSMutableDictionary * sth;
    
    for (int i = 0; i < 2; i ++) {
        int b1 = rand()%10;
        
        switch ( rand()%2) {
            case 0:
                fuhao = 1;
                break;
            case 1:
                fuhao = -1;
                break;
            default:
                break;
        }
        float realB = fuhao * b1/DENOMINATOR;
        if (realB < -1 * lmt) {
            realB = -1 * lmt;
        }
        if (realB > lmt) {
            realB = lmt;
        }
        if (i%2 == 0) {
            float a1 = [[[allDataArr lastObject] objectForKey:@"x"] floatValue];
            a1 = a1 + 0.1228;
            sth = [[NSMutableDictionary alloc] init];
            [sth setObject:[NSNumber numberWithFloat:a1]  forKey:@"x"];
            [sth setObject:[NSNumber numberWithFloat:realB]  forKey:@"y1"];
        }else{
            [sth setObject:[NSNumber numberWithFloat:realB]  forKey:@"y2"];
            [allDataArr addObject:sth];
        }
        
    }
    for (int i = 0; i < 56; i ++) {
        if(![set1 containsObject:[NSNumber numberWithInt:i]]){
            [allChartViews[i] addPoint:[[sth objectForKey:@"x"] floatValue]   val:@[@([[sth objectForKey:@"y1"] floatValue]),@([[sth objectForKey:@"y2"] floatValue])]];
            // dispatch_async(dispatch_get_main_queue(), ^{
            [allChartViews[i] drawChart];
            // });
        }
    }
    
    
    // });
}
 */

- (IBAction)dspViewBtnClicked:(id)sender {
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (_lpfBtn.selected) {
                _lpfBtn.selected = NO;
                [ApplicationInfo sharedInstance].LPFOption = NO;   //by richard
            }else{
                _lpfBtn.selected = YES;
                [ApplicationInfo sharedInstance].LPFOption = YES;  //by richard
            }
            break;
        }
        case 1:
        {
            if (_mbllBtn.selected) {
                _mbllBtn.selected = NO;
                [ApplicationInfo sharedInstance].MBLLOption = NO;
            }else{
                _mbllBtn.selected = YES;
                [ApplicationInfo sharedInstance].MBLLOption = YES;
            }
            break;
        }
        case 2:
        {
            if (_surConBtn.selected) {
                _surConBtn.selected = NO;
                [ApplicationInfo sharedInstance].SurfaceContaminationOption = NO;
            }else{
                _surConBtn.selected = YES;
                [ApplicationInfo sharedInstance].SurfaceContaminationOption = YES;
            }
            break;
        }
        case 3:
        {
            if (_moCaliBtn.selected) {
                _moCaliBtn.selected = NO;
                [ApplicationInfo sharedInstance].MotionCalibrationOption = NO;
            }else{
                _moCaliBtn.selected = YES;
                [ApplicationInfo sharedInstance].MotionCalibrationOption = YES;
            }
            break;
        }
        case 4:
        {
            if (_moComBtn.selected) {
                _moComBtn.selected = NO;
                [ApplicationInfo sharedInstance].MotionCompensationOption = NO;
            }else{
                _moComBtn.selected = YES;
                [ApplicationInfo sharedInstance].MotionCompensationOption = YES;
            }
            break;
        }
        case 5:
        {
            if (_naCRBtn.selected) {
                _naCRBtn.selected = NO;
                [ApplicationInfo sharedInstance].NAChannelRejection = NO;
            }else{
                _naCRBtn.selected = YES;
                [ApplicationInfo sharedInstance].NAChannelRejection = YES;
            }
            break;
        }
        case 6:
        {
            if (_heartBeatBtn.selected) {
                _heartBeatBtn.selected = NO;
                [ApplicationInfo sharedInstance].HeartBeat = NO;
            }else{
                _heartBeatBtn.selected = YES;
                [ApplicationInfo sharedInstance].HeartBeat = YES;
            }
            break;
        }
        case 7:
        {
            if (_baseReBtn.selected) {
                _baseReBtn.selected = NO;
                //[ApplicationInfo sharedInstance].NAChannelRejection = NO;
            }else{
                _baseReBtn.selected = YES;
                //[ApplicationInfo sharedInstance].NAChannelRejection = YES;
            }
            break;
        }
        default:
            break;
    }
}


- (IBAction)mapViewBtnClicked:(id)sender {
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (_biliIntBtn.selected) {
                _biliIntBtn.selected = NO;
                [ApplicationInfo sharedInstance].BilinearInterpolationOption = NO;
            }else{
                _biliIntBtn.selected = YES;
                [ApplicationInfo sharedInstance].BilinearInterpolationOption = YES;
            }
            break;
        }
        case 1:
        {
            if (_simuDotBtn.selected) {
                _simuDotBtn.selected = NO;
                [ApplicationInfo sharedInstance].SimultaneousDOTOption = NO;
            }else{
                _simuDotBtn.selected = YES;
                [ApplicationInfo sharedInstance].SimultaneousDOTOption = YES;
            }
            break;
        }
        case 2:
        {
            if (_alterDotBtn.selected) {
                _alterDotBtn.selected = NO;
                [ApplicationInfo sharedInstance].IterativeDOTOption = NO;
            }else{
                _alterDotBtn.selected = YES;
                [ApplicationInfo sharedInstance].IterativeDOTOption = YES;
            }
            break;
        }
        case 3:
        {
            if (_actiModeBtn.selected) {
                _actiModeBtn.selected = NO;
                [ApplicationInfo sharedInstance].ActivationModeOption = NO;
            }else{
                _actiModeBtn.selected = YES;
                [ApplicationInfo sharedInstance].ActivationModeOption = YES;
            }
            break;
        }
        case 4:
        {
            if (_averModeBtn.selected) {
                _averModeBtn.selected = NO;
                [ApplicationInfo sharedInstance].AverageModeOption = NO;
            }else{
                _averModeBtn.selected = YES;
                [ApplicationInfo sharedInstance].AverageModeOption = YES;
            }
            break;
        }
        case 5:
        {
            if (_linMapBtn.selected) {
                _linMapBtn.selected = NO;
                //[ApplicationInfo sharedInstance].AverageModeOption = NO;
            }else{
                _linMapBtn.selected = YES;
                //[ApplicationInfo sharedInstance].AverageModeOption = YES;
            }
            break;
        }
        case 6:
        {
            if (_comMapBtn.selected) {
                _comMapBtn.selected = NO;
            }else{
                _comMapBtn.selected = YES;
            }
            break;
        }
        default:
            break;
    }

}

- (IBAction)displayDataBtnClicked:(id)sender {
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            if (_hboBtn.selected) {
                _hboBtn.selected = NO;
            }else{
                _hboBtn.selected = YES;
                _hbRBtn.selected = NO;
                _hbTBtn.selected = NO;
            }
            break;
        }
        case 1:
        {
            if (_hbRBtn.selected) {
                _hbRBtn.selected = NO;
            }else{
                _hbRBtn.selected = YES;
                _hboBtn.selected = NO;
                _hbTBtn.selected = NO;
            }
            break;
        }
        case 2:
        {
            if (_hbTBtn.selected) {
                _hbTBtn.selected = NO;
            }else{
                _hbTBtn.selected = YES;
                _hboBtn.selected = NO;
                _hbRBtn.selected = NO;
            }
            break;
        }
        default:
            break;
    }

}


- (IBAction)xAxisBtnClicked:(id)sender {
    if (_xaxisBtn.selected) {
        _xaxisBtn.selected = NO;
        _yaxisBtn.selected = YES;
        UnitySendMessage("BluethoothRecv","setBrainAlign","1");
    }else{
        _xaxisBtn.selected = YES;
        _yaxisBtn.selected = NO;
        UnitySendMessage("BluethoothRecv","setBrainAlign","0");
    }
}

- (IBAction)yAxisBtnClicked:(id)sender {
    if (_yaxisBtn.selected) {
        _xaxisBtn.selected = YES;
        _yaxisBtn.selected = NO;
        UnitySendMessage("BluethoothRecv","setBrainAlign","0");
    }else{
        _xaxisBtn.selected = NO;
        _yaxisBtn.selected = YES;
        UnitySendMessage("BluethoothRecv","setBrainAlign","1");
    }
    
}

- (IBAction)gridBtnClicked:(id)sender {
    if (_gridBtn.selected) {
        _gridBtn.selected = NO;
    }else{
        _gridBtn.selected = YES;
    }
    UnitySendMessage("BluethoothRecv","setBrainAlign","2");
}

- (IBAction)resetBtnClicked:(id)sender {
    //    if (_resetBtn.selected) {
    //        _resetBtn.selected = NO;
    //    }else{
    //        _resetBtn.selected = YES;
    //    }
    UnitySendMessage("BluethoothRecv","setBrainAlign","3");
}

-(void)getData:(NSString *)sth{
    rowDataCount ++;
   [[ApplicationInfo sharedInstance].myDB insertTable:tableName andXvalue:[[NSDate date] timeIntervalSince1970] andRawdata:sth andMarker:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timeLabel setText:[self timeFormatted:rowDataCount]];
    });
}

-(void)showTimeInfo:(double)time{
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
    [_timeLabel setText:[NSString stringWithFormat:@"%f",time]];
    });
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timeLabel setText:[self timeFormatted:time]];
    });
    
    /*
    int hour = (int)(time/3600);
    int min  = ((int)time % 3600)/60;
    int sec = (int)time % 60;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (hour < 10 && min < 10 && sec < 10) {
            [_timeLabel setText:[NSString stringWithFormat:@"0%d:0%d:0%d",hour,min,sec]];
        }else if (hour < 10 && min < 10 && sec >= 10) {
            [_timeLabel setText:[NSString stringWithFormat:@"0%d:0%d:%d",hour,min,sec]];
        }else if (hour < 10 && min >= 10 && sec >= 10) {
            [_timeLabel setText:[NSString stringWithFormat:@"0%d:%d:%d",hour,min,sec]];
        }else{
            [_timeLabel setText:[NSString stringWithFormat:@"%d:%d:%d",hour,min,sec]];
        }
    });
     */
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ApplicationInfo sharedInstance].currentMode isEqualToString:@"toSaveInDeviceSegue"]){
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:tableName forKey:@"itsTableName"];
        [destination setValue:@"monitor" forKey:@"whoComeIn"];
    }
}


@end
