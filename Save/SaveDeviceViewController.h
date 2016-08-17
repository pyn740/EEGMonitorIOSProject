//
//  SaveDeviceViewController.h
//  nirsit
//
//  Created by admin on 15/10/3.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface SaveDeviceViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (strong, nonatomic) NSString * itsTableName;
@property (strong, nonatomic) NSString * whoComeIn;
@end
