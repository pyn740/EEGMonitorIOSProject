//
//  UserQuestionnaireViewController.m
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "UserQuestionnaireViewController.h"
#import "QuestionnaireTableViewController.h"
#import "AppDelegate.h"


@interface UserQuestionnaireViewController ()

@property(nonatomic,weak)AppDelegate * appDelegate;

@end

@implementation UserQuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self disableRightBottomView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"Questionnaire";
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPlotSettingSegue2"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"PlotSetting"];
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:[NSString stringWithFormat:@"%d",2] forKey:@"whoComeIn"];
    }

}

-(void)toNextMenu:(id)sender{
    QuestionnaireTableViewController * childVC = (QuestionnaireTableViewController *)[self.childViewControllers objectAtIndex:0];
    if (![childVC.firstName.text length]  || ![childVC.lastName.text length] || ![childVC.age.text length] || ![childVC.weight.text length] || ![childVC.height.text length] || ![childVC.maxBloodPressure.text length] || ![childVC.minBloodPressure.text length] || ![childVC.exercise.text length] || ![childVC.coffee.text length] || ![childVC.alcohol.text length] || ![childVC.smoking.text length]) {
        UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"All items are not nullable!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [toAlert show];
    }else{
        if(![self isNumber:childVC.age.text] || ![self isNumber:childVC.weight.text] || ![self isNumber:childVC.height.text] || ![self isNumber:childVC.maxBloodPressure.text] || ![self isNumber:childVC.minBloodPressure.text] || ![self isNumber:childVC.exercise.text] || ![self isNumber:childVC.coffee.text] || ![self isNumber:childVC.alcohol.text] || ![self isNumber:childVC.smoking.text]){
            UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some items just receive number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [toAlert show];
        }else{
            
            
            NSString * allDisease = @"";
            //            NSLog(@"%@,%@",childVC.otherItemsIndex,childVC.otherItems);
            for (int i = 0;i < [childVC.otherItemsIndex count]; i ++) {
                allDisease = [[allDisease stringByAppendingString:[childVC.otherItems objectAtIndex:[[childVC.otherItemsIndex objectAtIndex:i] integerValue]]] stringByAppendingString:@"|"];
            }
            allDisease = [allDisease substringToIndex:[allDisease length]];
            //NSLog(@"allDisease:%@",allDisease);
            
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString * email = [userDefaultes stringForKey:@"defaultEmail"];
            
            if ([[ApplicationInfo sharedInstance].myDB insertUserWithFirstName:childVC.firstName.text andLastName:childVC.lastName.text andAge:[NSString stringWithFormat:@"%@",childVC.age.text] andGender:[NSString stringWithFormat:@"%li",(long)childVC.sexSegement.selectedSegmentIndex] andRace:[NSString stringWithFormat:@"%li",(long)childVC.raceSegment.selectedSegmentIndex] andWeight:[NSString stringWithFormat:@"%@",childVC.weight.text] andHeight:[NSString stringWithFormat:@"%@",childVC.height.text] andMaxbloodPressure:[NSString stringWithFormat:@"%@",childVC.maxBloodPressure.text] andMinbloodPressure:[NSString stringWithFormat:@"%@",childVC.minBloodPressure.text] andExercise:[NSString stringWithFormat:@"%@",childVC.exercise.text] andCoffee:[NSString stringWithFormat:@"%@",childVC.coffee.text] andAlcohol:[NSString stringWithFormat:@"%@",childVC.alcohol.text] andSmoking:[NSString stringWithFormat:@"%@",childVC.smoking.text] andPriorIllness:[NSString stringWithFormat:@"%li",(long)childVC.priorSegment.selectedSegmentIndex] andAllDisease:allDisease andAdminEmail:email]) {
                UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Add User Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [toAlert show];
                NSLog(@"添加成功");
            }else{
                NSLog(@"添加失败");
            }
        }
    }
    
}


#pragma mark - button click event

- (IBAction)agreeAll:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        [self ableRightBottomView];
    }else{
        sender.selected = NO;
        [self disableRightBottomView];
    }
}


-(BOOL)isNumber:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val1;
    float val2;
    BOOL isPureInt,isPureFloat;
    isPureInt = [scan scanInt:&val1] && [scan isAtEnd];
    isPureFloat = [scan scanFloat:&val2] && [scan isAtEnd];
    if (isPureInt || isPureFloat) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self performSegueWithIdentifier:@"toPlotSettingSegue2" sender:self];
}



@end
