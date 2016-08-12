//
//  MeasureViewController.h
//  nirsit
//
//  Created by admin on 15/7/30.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface MeasureViewController : BaseViewController

@property(nonatomic,strong)NSString * taskType;
@property(nonatomic)int taskID;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

- (IBAction)goToTask:(id)sender;
- (IBAction)quitMeasure:(id)sender;
@end
