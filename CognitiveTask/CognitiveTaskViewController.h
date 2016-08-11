//
//  CognitiveTaskViewController.h
//  nirsit
//
//  Created by admin on 15/7/29.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"

@interface CognitiveTaskViewController : BaseViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *introductionTextView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *cognitiveScroll;
- (IBAction)cognitiveBtnSelected:(id)sender;
- (IBAction)goNextPage:(id)sender;
- (IBAction)goLastPage:(id)sender;

@end
