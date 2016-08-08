//
//  MainViewController.m
//  obelab
//
//  Created by admin on 15/7/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "MainViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImage(UIImageScale).h"
#import "HYSegmentedControl.h"
#import "ReplayViewController.h"

@interface MainViewController (){
    UINavigationController * nav;
    
}

@property (strong, nonatomic)HYSegmentedControl *segmentedControl;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self otherMainLine];
    
    self.gussView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.gussImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:self.gussView];
    [self.gussView addSubview:self.gussImgView];
    [self.gussView setHidden:YES];
    
    self.settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,360, 768)];
    [self.settingView setBackgroundColor:[UIColor colorWithRed:0.0 green:6.0/255 blue:36.0/255 alpha:0.3]];
    [self.view addSubview:self.settingView];
    
    for (int i = 0; i < 5; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60, 94 + 62 * i, 240, 54);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTintColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont fontWithName:@"NotoSansCJKkr-Medium" size:28]];
        [btn setBackgroundImage:[UIImage imageNamed:@"highlight_blue"] forState:UIControlStateHighlighted];
        btn.tag = i;
        switch (i) {
            case 0:
            {
                [btn setTitle:@"  DATA" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(goToReplayPage) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
            case 1:
                [btn setTitle:@"  SETTING" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"  NOTICE" forState:UIControlStateNormal];
                break;
            case 3:
                [btn setTitle:@"  INFORMATION" forState:UIControlStateNormal];
                break;
            case 4:
                [btn setTitle:@"  USER" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [self.settingView addSubview:btn];
    }
    

    [self.settingView setHidden:YES];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideSettingView:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.settingView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSettingView:)];
    gesture2.numberOfTouchesRequired = 1;
    gesture2.numberOfTouchesRequired = 1;
    [self.gussView addGestureRecognizer:gesture2];
}

- (void)otherMainLine
{
    self.segmentedControl = [[HYSegmentedControl alloc] initWithOriginY:0 Titles:@[@"REPALY",@"LOG IN", @"SELECT MODE", @"SELECT USER", @"PLOT SETTING", @"CALIBRATION", @"SELECT MODE", @"SELECT TASK", @"BASELINE TRAINNING", @"SAVE"] delegate:nil] ;
    [self.view addSubview:_segmentedControl];
    [self.segmentedControl changeBtnFrame];
    [self.segmentedControl changeSegmentedControlWithIndex:1];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTitleScroll:) name:@"UpdateTitle" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NSNotificationCenter event

-(void)handleTitleScroll:(NSNotification *)notification{
    NSString * theString = [notification object];
    if (theString != nil) {
        if ([theString isEqualToString:@"Replay"]) {
            [self.segmentedControl changeBtnTitle:@"REPLAY" withIndex:0];
            [self.segmentedControl changeSegmentedControlWithIndex:0];
        }else if ([theString isEqualToString:@"AdminLogin"]) {
            [self.segmentedControl changeBtnTitle:@"LOG IN" withIndex:1];
            [self.segmentedControl changeSegmentedControlWithIndex:1];
        }else if([theString isEqualToString:@"SignUp"]){
            [self.segmentedControl changeBtnTitle:@"SIGN UP" withIndex:1];
            [self.segmentedControl changeSegmentedControlWithIndex:1];
        }else if([theString isEqualToString:@"FirstMode"]){
            [self.segmentedControl changeBtnTitle:@"SELECT MODE" withIndex:2];
            [self.segmentedControl changeSegmentedControlWithIndex:2];
        }else if([theString isEqualToString:@"SelectUser"]){
            [self.segmentedControl changeBtnTitle:@"SELECT USER" withIndex:3];
            [self.segmentedControl changeSegmentedControlWithIndex:3];
        }else if([theString isEqualToString:@"Questionnaire"]){
            [self.segmentedControl changeBtnTitle:@"QUESTIONNAIRE" withIndex:3];
            [self.segmentedControl changeSegmentedControlWithIndex:3];
        }else if([theString isEqualToString:@"PlotSetting"]){
            [self.segmentedControl changeBtnTitle:@"PLOT SETTING" withIndex:4];
            [self.segmentedControl changeSegmentedControlWithIndex:4];
        }else if([theString isEqualToString:@"Calibration"]){
            [self.segmentedControl changeBtnTitle:@"CALIBRATION" withIndex:5];
            [self.segmentedControl changeSegmentedControlWithIndex:5];
        }else if([theString isEqualToString:@"SecondMode"]){
            [self.segmentedControl changeBtnTitle:@"SELECT MODE" withIndex:6];
            [self.segmentedControl changeSegmentedControlWithIndex:6];
        }else if([theString isEqualToString:@"TaskSelect"]){
            [self.segmentedControl changeBtnTitle:@"SELECT TASK" withIndex:7];
            [self.segmentedControl changeSegmentedControlWithIndex:7];
        }else if([theString isEqualToString:@"BaselineTraining"]){
            [self.segmentedControl changeBtnTitle:@"BASELINE TRAINING" withIndex:8];
            [self.segmentedControl changeSegmentedControlWithIndex:8];
        }else if([theString isEqualToString:@"Measure"]){
            [self.segmentedControl changeBtnTitle:@"MEASURE" withIndex:8];
            [self.segmentedControl changeSegmentedControlWithIndex:8];
        }else if([theString isEqualToString:@"TakeTask"]){
            [self.segmentedControl changeBtnTitle:@"TASK" withIndex:8];
            [self.segmentedControl changeSegmentedControlWithIndex:8];
        }else if([theString isEqualToString:@"Save"]){
            [self.segmentedControl changeBtnTitle:@"SAVE" withIndex:9];
            [self.segmentedControl changeSegmentedControlWithIndex:9];
        }else if([theString isEqualToString:@"Summary"]){
            [self.segmentedControl changeBtnTitle:@"SUMMARY" withIndex:9];
            [self.segmentedControl changeSegmentedControlWithIndex:9];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    nav = [segue destinationViewController];
}

#pragma mark - button click event

- (IBAction)openSettingViewBtnSelected:(id)sender {
    @autoreleasepool {
        UIImage * img = [[UIImage alloc] init];
        img = [img getImageFromView:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getGussBackGround:img];
        });
    }
    CATransition * transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    [self.settingView.layer addAnimation:transition forKey:@"animation"];
    [self.settingView setHidden:NO];
}

-(void)getGussBackGround:(UIImage *)img{
    img = [img blurImage:img];
    self.gussImgView.image = img;
    [self.gussView setHidden:NO];
}

-(void)hideSettingView:(UIGestureRecognizer *)gesture{
    
    CATransition * transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.settingView.layer addAnimation:transition forKey:@"animation"];
    [self.settingView setHidden:YES];
    
    CATransition * transition2 = [CATransition animation];
    transition2.duration = 0.1;
    transition2.type = kCATransitionFade;
    [self.gussView.layer addAnimation:transition2 forKey:@"animation"];
    [self.gussView setHidden:YES];
}

-(void)goToReplayPage{
    UIGestureRecognizer * ges = [[UIGestureRecognizer alloc] init];
    [self hideSettingView:ges];
    
    if (![[ApplicationInfo sharedInstance].currentTitle isEqualToString:@"Replay"]) {
        ReplayViewController * rvc = [[ReplayViewController alloc] initWithNibName:@"ReplayViewController" bundle:[NSBundle mainBundle]];
        rvc.lastTitle = [ApplicationInfo sharedInstance].currentTitle;
        UINavigationController * childVC = (UINavigationController *)[self.childViewControllers objectAtIndex:0];
        [childVC pushViewController:rvc animated:YES];
    }
    }

@end
