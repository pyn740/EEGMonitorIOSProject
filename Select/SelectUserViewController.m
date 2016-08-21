//
//  SelectUserViewController.m
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "SelectUserViewController.h"
#import "AppDelegate.h"


@interface SelectUserViewController (){
    NSMutableArray * userArray;
}

@property(nonatomic,weak)AppDelegate * appDelegate;

@end

@implementation SelectUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.rightBottomView setHidden:YES];
    [self.userTable setBackgroundColor:[UIColor clearColor]];
    //[self.userTable setBackgroundView:nil];
    userArray = [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [userArray removeAllObjects];
    [userArray addObjectsFromArray:[NSArray arrayWithObjects:@"New",@"Guest",nil]];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * email = [userDefaultes stringForKey:@"defaultEmail"];
    [userArray addObjectsFromArray:[[ApplicationInfo sharedInstance].myDB getUserListThrounghEmail:email]];
    
    
    [_userTable reloadData];
    [ApplicationInfo sharedInstance].currentTitle = @"SelectUser";
}


#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"FirstMode"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
//    for (UIView * vw in  cell.subviews) {
//        [vw removeFromSuperview];
//    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [@" " stringByAppendingString:[userArray objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:28];
    if (![cell viewWithTag:57]) {
        UIImageView * lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, cell.frame.size.width, 2)];
        lineImg.tag = 57;
        [lineImg setBackgroundColor:[UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3]];
        [cell addSubview:lineImg];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    //cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:91.0/255 green:155.0/255 blue:213.0/255 alpha:1];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0];
    
   /*
    for (UIView * vw in  cell.subviews) {
        [vw removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(27, 10, cell.frame.size.width-54, 54)];
    [btn.layer setCornerRadius:5.0];
    btn.tag = indexPath.row;
    [btn setTitle:[@"    " stringByAppendingString:[userArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn.titleLabel setFont:[UIFont fontWithName:@"NotoSansCJKkr-Regular" size:28]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setBackgroundImage:[UIImage imageNamed:@"highlight_blue"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(toPlotPage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(27, 74, cell.frame.size.width-54, 2)];
    [lineImg setBackgroundColor:[UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3]];
   
    [cell addSubview:btn];
    [cell addSubview:lineImg];
   */
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

-(void)changeBgColor:(UIButton *)btn{
    [btn setBackgroundColor:[UIColor colorWithRed:0.0 green:157.0/255 blue:220.0/255 alpha:1.0]];
}

-(void)toPlotPage:(UIButton *)btn{
    //NSLog(@"%d",btn.tag);
    if (btn.tag == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Questionnaire"];
        [self performSegueWithIdentifier:@"toUserQuestionnaireSegue" sender:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"PlotSetting"];
        [self performSegueWithIdentifier:@"toPlotSettingSegue1" sender:self];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Questionnaire"];
        [self performSegueWithIdentifier:@"toUserQuestionnaireSegue" sender:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"PlotSetting"];
        [self performSegueWithIdentifier:@"toPlotSettingSegue1" sender:self];
    }
    /*
     UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
     if (cell.accessoryType) {
     cell.accessoryType = UITableViewCellAccessoryNone;
     }else{
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }
     */
}

#pragma mark - Navigation

//1-new 2-patient
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toPlotSettingSegue1"]) {
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:[NSString stringWithFormat:@"%d",1] forKey:@"whoComeIn"];
    }
}


@end
