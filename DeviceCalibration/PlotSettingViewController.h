//
//  PlotSettingViewController.h
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface PlotSettingViewController : BaseViewController

@property(weak,nonatomic)NSString * whoComeIn;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UIImageView *preView;

- (IBAction)cameraBtnSelected:(id)sender;
@end
