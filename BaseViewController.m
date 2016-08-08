//
//  BaseViewController.m
//  nirsit
//
//  Created by admin on 15/7/21.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBottomView = [[UIView alloc] init];
    [self.leftBottomView setBackgroundColor:[UIColor clearColor]];
    self.leftBottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.leftBottomView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10]];
    [self.leftBottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:50]];
    [self.leftBottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBottomView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:100]];
    
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 70, 20)];
    [leftLabel setText:@"BACK"];
    [leftLabel setTag:14];
    [leftLabel setTextColor:[UIColor whiteColor]];
    [leftLabel setFont:[UIFont fontWithName:@"NotoSansCJKkr-Medium" size:23]];
    [leftLabel setTextAlignment:NSTextAlignmentLeft];
    
    UIImageView * leftDic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 20, 20)];
    leftDic.tag  = 15;
    leftDic.image = [UIImage imageNamed:@"left_arrow"];
    
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    leftBtn.tag = 16;
    [leftBtn setShowsTouchWhenHighlighted:YES];
    [leftBtn addTarget:self action:@selector(backToLastMenu:) forControlEvents:UIControlEventTouchUpInside];
 
    [self.leftBottomView addSubview:leftDic];
    [self.leftBottomView addSubview:leftLabel];
    [self.leftBottomView addSubview:leftBtn];
    
    self.rightBottomView = [[UIView alloc] init];
    [self.rightBottomView setBackgroundColor:[UIColor clearColor]];
    self.rightBottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.rightBottomView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:-10]];
    [self.rightBottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:50]];
    [self.rightBottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBottomView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:100]];
    
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 70, 20)];
    [rightLabel setText:@"DONE"];
    [rightLabel setTag:14];
    [rightLabel setTextColor:[UIColor whiteColor]];
    [rightLabel setFont:[UIFont fontWithName:@"NotoSansCJKkr-Medium" size:23]];
    [rightLabel setTextAlignment:NSTextAlignmentRight];
    
    UIImageView * rightDic = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 20, 20)];
    rightDic.tag  = 15;
    [rightDic setImage:[UIImage imageNamed:@"right_arrow"]];
   
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    rightBtn.tag = 16;
    [rightBtn setShowsTouchWhenHighlighted:YES];
    [rightBtn addTarget:self action:@selector(toNextMenu:) forControlEvents:UIControlEventTouchUpInside];

    [self.rightBottomView addSubview:rightDic];
    [self.rightBottomView addSubview:rightLabel];
    [self.rightBottomView addSubview:rightBtn];
}

-(void)disableRightBottomView{
    [(UIButton *)[self.rightBottomView viewWithTag:16] setEnabled:NO];
    [(UIImageView *)[self.rightBottomView viewWithTag:15] setImage:[UIImage imageNamed:@"right_arrow_disable"]];
    [(UILabel *)[self.rightBottomView viewWithTag:14] setTextColor:[UIColor grayColor]];
}

-(void)ableRightBottomView{
    [(UIButton *)[self.rightBottomView viewWithTag:16] setEnabled:YES];
    [(UIImageView *)[self.rightBottomView viewWithTag:15] setImage:[UIImage imageNamed:@"right_arrow"]];
    [(UILabel *)[self.rightBottomView viewWithTag:14] setTextColor:[UIColor whiteColor]];
}

-(void)disableLeftBottomView{
    [(UIButton *)[self.leftBottomView viewWithTag:16] setEnabled:NO];
    [(UIImageView *)[self.leftBottomView viewWithTag:15] setImage:[UIImage imageNamed:@"left_arrow_disable"]];
    [(UILabel *)[self.leftBottomView viewWithTag:14] setTextColor:[UIColor grayColor]];
}

-(void)ableLeftBottomView{
    [(UIButton *)[self.leftBottomView viewWithTag:16] setEnabled:YES];
    [(UIImageView *)[self.leftBottomView viewWithTag:15] setImage:[UIImage imageNamed:@"left_arrow"]];
    [(UILabel *)[self.leftBottomView viewWithTag:14] setTextColor:[UIColor whiteColor]];
}

-(void)modifyRightLabel:(NSString *)str{
    [(UILabel *)[self.rightBottomView viewWithTag:14] setText:str];
}

-(void)modifyRightImg:(NSString *)str{
    [(UIImageView *)[self.rightBottomView viewWithTag:15] setImage:[UIImage imageNamed:str]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    
}

@end
