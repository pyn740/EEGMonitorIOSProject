//
//  AdminLoginViewController.m
//  nirsit
//
//  Created by admin on 15/7/21.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "AdminLoginViewController.h"
#import "AppDelegate.h"

@interface AdminLoginViewController ()

@property(nonatomic,weak)AppDelegate * appDelegate;

@end

@implementation AdminLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.leftBottomView setHidden:YES];
    [self disableRightBottomView];
    
    [self.emailInputTextField setPlaceholder:@"Please input your email"];
    [self.emailInputTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdInputTextField setPlaceholder:@"Please input your password"];
    [self.pwdInputTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self readFromNSUserDefault]) {
        [self ableRightBottomView];
    }else{
        [self disableRightBottomView];
    }
    [ApplicationInfo sharedInstance].currentTitle = @"AdminLogin";
}


#pragma mark - to get userDefault

-(void)writeToNSUserDefault{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:self.emailInputTextField.text forKey:@"defaultEmail"];
    [userDefaultes setObject:self.pwdInputTextField.text forKey:@"defaultPwd"];
}

-(BOOL)readFromNSUserDefault{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSString * email = [userDefaultes stringForKey:@"defaultEmail"];
    NSString * pwd = [userDefaultes stringForKey:@"defaultPwd"];
    if ([email length] != 0 && [pwd length] != 0) {
        [self.emailInputTextField setText:email];
        [self.pwdInputTextField setText:pwd];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - back or next event

-(void)toNextMenu:(id)sender{
    NSInteger canLogin = [[ApplicationInfo sharedInstance].myDB detectAdminIfCanLoginWithEmail:self.emailInputTextField.text andPwd:self.pwdInputTextField.text];
    if (canLogin == 1) {
        UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Login Success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [toAlert show];
    }else{
        UIAlertView * toAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The email or password is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [toAlert show];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self writeToNSUserDefault];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"FirstMode"];
    [self performSegueWithIdentifier:@"ToFirstModeSegue" sender:self];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.emailInputTextField.text length]&& [self.pwdInputTextField.text length]) {
        [self ableRightBottomView];
    }else{
        [self disableRightBottomView];
    }
}

#pragma mark - button click event

- (void)buttonChangeBGHighlighted:(UIButton *)sender {
    sender.backgroundColor = [UIColor colorWithRed:4.0/255 green:71.0/255 blue:144.0/255 alpha:1];
}

- (void)buttonChangeBGNormal:(UIButton *)sender{
   
    sender.backgroundColor = [UIColor clearColor];
    if (sender.tag == 21) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SignUp"];
        [self performSegueWithIdentifier:@"toSignUpSegue" sender:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
        [self performSegueWithIdentifier:@"testModeToTaskSegue" sender:self];
    }
}

- (void)buttonChangeBGCancel:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

//- (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}


#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"testModeToTaskSegue"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"TaskSelect"];
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:@"TestMode" forKey:@"whoComeIn"];
        [ApplicationInfo sharedInstance].currentMode = @"testMode";
    }else if ([segue.identifier isEqualToString:@"toSignUpSegue"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SignUp"];
    }
    
}
@end
