//
//  CognitiveTaskViewController.m
//  nirsit
//
//  Created by admin on 15/7/29.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "CognitiveTaskViewController.h"

#define TASKNUM 4

@interface CognitiveTaskViewController (){
    int selectFlag[TASKNUM];
}


@end

@implementation CognitiveTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cognitiveScroll setContentSize:CGSizeMake(268*TASKNUM + 30*(TASKNUM-1), 373)];
    
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

- (IBAction)cognitiveBtnSelected:(id)sender {
    
    UIButton * theBtn = (UIButton *)sender;
    if (theBtn.selected) {
        theBtn.selected = NO;
        selectFlag[theBtn.tag-1] = -1;
        self.titleLabel.text = @"COGNITIVE TASK";
        self.introductionTextView.text = @"With NIRSIT placed on head, NIRSIT User can see how brain functions during performance of the Cognitive Tasks.";
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
            self.titleLabel.text = @"N-BACK TASK";
            self.introductionTextView.text = @"When doing N-BACK Task, NIRSIT User indentifies the alphabet and matches the alphabet with the previous one.";
            
        }else if (theBtn.tag == 2) {
            self.titleLabel.text = @"ARITHMETIC TASK";
            self.introductionTextView.text = @"When doing ARITHMATIC Task, NIRSIT User solves arithmetic problems mentally without having to speak out or write the answers.";
            
        }else if (theBtn.tag == 3) {
            self.titleLabel.text = @"STROOP TASK";
            self.introductionTextView.text = @"When doing STROOP Task, NIRSIT User views the word shown in the screen, and then name the color of the word instead of what the word says.";
            
        }else{
            self.titleLabel.text = @"COGNITIVE TASK";
            self.introductionTextView.text = @"With NIRSIT placed on head, NIRSIT User can see how brain functions during performance of the Cognitive Tasks.";
        }
        [self ableRightBottomView];
    }
    self.introductionTextView.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:22];
    self.introductionTextView.textColor = [UIColor whiteColor];
}

- (IBAction)goNextPage:(id)sender {
    [self.cognitiveScroll setContentOffset:CGPointMake(self.cognitiveScroll.contentSize.width-self.cognitiveScroll.frame.size.width,0) animated:YES];
}

- (IBAction)goLastPage:(id)sender {
    [self.cognitiveScroll setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self leftOrRightBtnEnabled];
}

-(void)leftOrRightBtnEnabled{
    if (self.cognitiveScroll.contentOffset.x == 0) {
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = YES;
    }else if(self.cognitiveScroll.contentOffset.x == self.cognitiveScroll.contentSize.width-self.cognitiveScroll.frame.size.width){
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
        [self performSegueWithIdentifier:@"cognitiveSegue" sender:self];
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
    [destination setValue:@"Cognitive" forKey:@"taskType"];
    [destination setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"taskID"];
}


@end
