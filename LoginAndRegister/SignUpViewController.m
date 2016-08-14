//
//  SignUpViewController.m
//  nirsit
//
//  Created by admin on 15/7/21.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"

@interface SignUpViewController (){
    BOOL keyboardIsShown;
}

@property(nonatomic,weak)AppDelegate * appDelegate;

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self disableRightBottomView];

    [self.emailInputTextField setPlaceholder:@"Please input your email"];
    [self.emailInputTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdInputTextField setPlaceholder:@"Please input your password"];
    [self.pwdInputTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmTextField setPlaceholder:@"Please confirm your password"];
    [self.confirmTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"SignUp";
    
    //键盘弹起的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:self.view.window];
    //键盘隐藏的通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"AdminLogin"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toNextMenu:(id)sender{
    if (![self.pwdInputTextField.text isEqualToString:self.confirmTextField.text]) {
        UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The two passwords you typed do not match!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [toAlert show];
        
    }else{
        if ([self isValidateEmail:self.emailInputTextField.text]) {
            NSInteger exist = [[ApplicationInfo sharedInstance].myDB detectIfAlreadyExistEmail:self.emailInputTextField.text];
            if (exist == 1) {
                UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The email already exists!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [toAlert show];
            }else if(exist == 0){
                if ([[ApplicationInfo sharedInstance].myDB insertAdminWithEmail:self.emailInputTextField.text andPwd:self.pwdInputTextField.text]) {
                    UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sign Up Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [toAlert show];
                    NSLog(@"添加成功");
                }else{
                    NSLog(@"添加失败");
                }
            }
        }else{
            UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input correct email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [toAlert show];
        }
    }
}

-(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self writeToNSUserDefault];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"AdminLogin"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - to get userDefault

-(void)writeToNSUserDefault{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:self.emailInputTextField.text forKey:@"defaultEmail"];
    [userDefaultes setObject:self.pwdInputTextField.text forKey:@"defaultPwd"];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.emailInputTextField.text length] && [self.pwdInputTextField.text length] && [self.confirmTextField.text length]) {
        [self ableRightBottomView];
    }else{
        [self disableRightBottomView];
    }
}

#pragma mark - NSNotificationCenter event

//键盘弹起后处理scrollView的高度使得textfield可见
-(void)keyboardDidShow:(NSNotification *)notification{
    /*
    if (keyboardIsShown) {
        return;
    }
     */
    NSDictionary * info = [notification userInfo];
    NSValue *avalue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[avalue CGRectValue] fromView:nil];
    float height = self.signUpScroll.frame.origin.y+self.signUpScroll.frame.size.height-(self.view.frame.size.height-keyboardRect.size.height);
    [self.signUpScroll setContentSize:CGSizeMake(self.signUpScroll.frame.size.width, self.signUpScroll.frame.size.height+height)];
    [self.signUpScroll setContentOffset:CGPointMake(0, height)];
    
    keyboardIsShown = YES;
}

//键盘隐藏后处理scrollview的高度，使其还原为本来的高度
-(void)keyboardDidHide:(NSNotification *)notification{
    [self.signUpScroll setContentOffset:CGPointMake(0, 0)];
    [self.signUpScroll setContentSize:CGSizeMake(self.signUpScroll.frame.size.width, self.signUpScroll.frame.size.height)];
    keyboardIsShown = NO;
}

@end
