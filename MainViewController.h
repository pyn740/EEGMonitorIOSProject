//
//  MainViewController.h
//  obelab
//
//  Created by admin on 15/7/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (strong, nonatomic) UIButton *settingBtn;
@property (strong, nonatomic) UIView *gussView;
@property (strong, nonatomic) UIImageView *gussImgView;
@property (strong, nonatomic) UIView *settingView;


- (IBAction)openSettingViewBtnSelected:(id)sender;
@end

