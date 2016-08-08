//
//  ReplayViewController.h
//  nirsit
//
//  Created by admin on 15/10/3.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface ReplayViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property(nonatomic,strong)NSString * lastTitle;

@end
