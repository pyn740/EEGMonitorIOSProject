//
//  AdminLoginViewController.h
//  nirsit
//
//  Created by admin on 15/7/21.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface AdminLoginViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdInputTextField;

@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *testModeRunBtn;


@end
