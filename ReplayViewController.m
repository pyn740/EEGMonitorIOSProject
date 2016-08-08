//
//  ReplayViewController.m
//  nirsit
//
//  Created by admin on 15/10/3.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "ReplayViewController.h"
#import "MainMonitorViewController.h"

@interface ReplayViewController (){
    NSMutableArray * dataArray;
    NSDictionary * selectedRow;
    NSMutableArray * replayData;
}


@end

@implementation ReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableRightBottomView];
    [ApplicationInfo sharedInstance].currentTitle = @"Replay";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Replay"];
    [self.dataTable setBackgroundColor:[UIColor clearColor]];
    self.dataTable.delegate = self;
    self.dataTable.dataSource = self;
    //[self.userTable setBackgroundView:nil];
    //[self.dataTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"dataCell"];

    dataArray = [[NSMutableArray alloc] init];
    dataArray = [[ApplicationInfo sharedInstance].myDB getReplayNameFromTableList];
    //NSLog(@"dataArray:%@",dataArray);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[btnArray removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:_lastTitle];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainMonitorViewController * monitorVC =[board instantiateViewControllerWithIdentifier:@"mainMonitorID"];
    [monitorVC setValue:@"ReplayMonitor" forKey:@"whoComeIn"];
    [monitorVC setValue:selectedRow forKey:@"replayDataInfo"];
    
    [self.navigationController pushViewController:monitorVC  animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary * dic = (NSDictionary *)[dataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"   %@                                  %@",[[dic objectForKey:@"create_date"] uppercaseString],[dic objectForKey:@"table_name"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:28];
    
    if (![cell viewWithTag:57]) {
        UIImageView * lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, 601, 2)];
        lineImg.tag = 57;
        [lineImg setBackgroundColor:[UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3]];
        [cell addSubview:lineImg];
    }
    
    UIImageView * selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 601, 74)];
    [selectImage setContentMode:UIViewContentModeScaleAspectFit];
    [selectImage setImage:[UIImage imageNamed:@"highlight_blue"]];
    UIImageView * lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74, 601, 2)];
    [lineImg setBackgroundColor:[UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3]];
    [selectImage addSubview:lineImg];
    [selectImage setBackgroundColor:[UIColor clearColor]];
    [cell setSelectedBackgroundView:selectImage];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected:%ld",(long)indexPath.row);
    selectedRow = (NSDictionary *)[dataArray objectAtIndex:indexPath.row];
    [self ableRightBottomView];
    //[[ApplicationInfo sharedInstance].myDB getCurrentRowDataTable:[selectedRow valueForKey:@"table_name"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
