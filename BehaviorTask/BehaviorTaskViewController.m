//
//  BehaviorTaskViewController.m
//  nirsit
//
//  Created by admin on 15/7/28.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BehaviorTaskViewController.h"

#define TASKNUM 3

@interface BehaviorTaskViewController (){
    int selectFlag[TASKNUM];
}

@end

@implementation BehaviorTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.behaviorScroll setContentSize:CGSizeMake(268*TASKNUM + 28*(TASKNUM-1), 301)];
    for (int i = 0; i < TASKNUM; i ++) {
        selectFlag[i] = -1;
    }
    
    [self modifyRightLabel:@"START"];
    [self disableRightBottomView];
    
    [self leftOrRightBtnEnabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"TaskSelect";
}

#pragma mark - button click event

- (IBAction)behaviorBtnSelected:(id)sender {
    
    UIButton * theBtn = (UIButton *)sender;
    if (theBtn.selected) {
        theBtn.selected = NO;
        selectFlag[theBtn.tag-1] = -1;
        self.titleLabel.text = @"BEHAVIOR TASK";
        self.introductionTextView.text = @"With NIRSIT placed on head, NIRSIT User can see how body and brain react to simple behavior exercises.";
        [self disableRightBottomView];
    }else{
        for (int i = 0; i < TASKNUM; i ++) {
            selectFlag[i] = -1;
            
            UIButton *preSelectBtn = (UIButton *)[self.view viewWithTag:i+1];
            preSelectBtn.selected = NO;
            
        }
        theBtn.selected = YES;
        selectFlag[theBtn.tag-1] = 1;
        if (theBtn.tag == 1) {
            self.titleLabel.text = @"BALANCE TASK";
            self.introductionTextView.text = @"When doing Balance Task, NIRSIT User balances on one foot, with eyes open and then with eyes closed, to compare differences in brain function.";
            
        }else if (theBtn.tag == 2) {
            self.titleLabel.text = @"SQUAT TASK";
            self.introductionTextView.text = @"When doing Squat Task, NIRSIT User can see how the cerebral blood circulation system performs its autoregulation.";
            
        }else{
            self.titleLabel.text = @"BEHAVIOR TASK";
            self.introductionTextView.text = @"With NIRSIT placed on head, NIRSIT User can see how body and brain react to simple behavior exercises.";
        }
        [self ableRightBottomView];
    }
    self.introductionTextView.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:22];
    self.introductionTextView.textColor = [UIColor whiteColor];
}

- (IBAction)goNextPage:(id)sender {
    [self.behaviorScroll setContentOffset:CGPointMake(self.behaviorScroll.contentSize.width-self.behaviorScroll.frame.size.width,0) animated:YES];
}

- (IBAction)goLastPage:(id)sender {
    [self.behaviorScroll setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self leftOrRightBtnEnabled];
}

-(void)leftOrRightBtnEnabled{
    if (self.behaviorScroll.contentSize.width <= self.behaviorScroll.frame.size.width) {
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = NO;
    }else
    if (self.behaviorScroll.contentOffset.x == 0) {
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = YES;
    }else if(self.behaviorScroll.contentOffset.x == self.behaviorScroll.contentSize.width-self.behaviorScroll.frame.size.width){
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = NO;
    }else{
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
    }
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    if ([[ApplicationInfo sharedInstance].currentMode isEqualToString:@"testMode"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
        [self performSegueWithIdentifier:@"testMode1" sender:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"BaselineTraining"];
        [self performSegueWithIdentifier:@"behaviorSegue" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int i;
    for (i = 0; i < TASKNUM; i ++) {
        if(selectFlag[i] == 1){
            break;
        }
    }
    UIViewController *destination = segue.destinationViewController;
    [destination setValue:@"Behavior" forKey:@"taskType"];
    [destination setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"taskID"];
}

@end
