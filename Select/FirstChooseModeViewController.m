//
//  FirstChooseModeViewController.m
//  nirsit
//
//  Created by admin on 15/7/22.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "FirstChooseModeViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "GetDataFromDevice.h"

@interface FirstChooseModeViewController (){
    NSDictionary * currentWiFiInfo;
}

@end

@implementation FirstChooseModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rightBottomView setHidden:YES];
    [_taskBtn.layer setCornerRadius:6.0];
    [_taskBtn.layer setBorderWidth:2];
    [_taskBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_monitorBtn.layer setCornerRadius:6.0];
    [_monitorBtn.layer setBorderWidth:2];
    [_monitorBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationInfo sharedInstance].currentTitle = @"FirstMode";
}


#pragma mark - back or next event

-(void)backToLastMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"AdminLogin"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - button click event

- (IBAction)oneModeBeClicked:(id)sender {
    
    [[ApplicationInfo sharedInstance].someData stopGetDataFromDevice];
    
    UIButton * senderBtn = (UIButton *)sender;
    if (senderBtn.tag == 19) {
        [[ApplicationInfo sharedInstance].someData startGetDataFromDevice];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
        [self performSegueWithIdentifier:@"toTaskModeSegue" sender:self];
    }else{
        [self fetchSSIDInfo];
        NSLog(@"%@",[[currentWiFiInfo objectForKey:@"SSID"] uppercaseString] );
        if ([[currentWiFiInfo objectForKey:@"SSID"] length] && [[[currentWiFiInfo objectForKey:@"SSID"] uppercaseString] rangeOfString:@"NIRSIT"].location!= NSNotFound) {
            [[ApplicationInfo sharedInstance].someData startGetDataFromDevice];
            
            [self performSegueWithIdentifier:@"toMonitorModeSegue" sender:self];
        }else{
            UIAlertView * toSettingAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please open “Setting” and then connect Wi-Fi whose name contain “NIRSIT”." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [toSettingAlert show];
        }
    }
    
    /*
    UIButton * senderBtn = (UIButton *)sender;
    [self fetchSSIDInfo];
    //NSLog(@"%@",[@"NirsIT" uppercaseString]);
    //if ([[currentWiFiInfo objectForKey:@"SSID"] isEqualToString:@"NIRSIT-PF2 AP"]) {
    if ([[[currentWiFiInfo objectForKey:@"SSID"] uppercaseString] rangeOfString:@"NIRSIT"].location != NSNotFound) {
           if (senderBtn.tag == 19) {
            [self performSegueWithIdentifier:@"toTaskModeSegue" sender:self];
        }else if(senderBtn.tag == 21){
            [self performSegueWithIdentifier:@"toMonitorModeSegue" sender:self];
        }
    }else{
        UIAlertView * toSettingAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please open “Setting” and then connect Wi-Fi whose name contain “NIRSIT”" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [toSettingAlert show];
    }
    */
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    //NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        //NSLog(@"%@ => %@", ifnam, info);
        currentWiFiInfo = [NSDictionary dictionaryWithDictionary:(NSDictionary *)info];
        NSLog(@"current--->%@",currentWiFiInfo);
        if (info && [info count]) { break; }
    }
    return info;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTaskModeSegue"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
        [ApplicationInfo sharedInstance].currentMode = @"oneTabletMode";
    }else if ([segue.identifier isEqualToString:@"toMonitorModeSegue"]) {
        UIViewController *destination = segue.destinationViewController;
        [destination setValue:@"FirstModeSelect" forKey:@"whoComeIn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Measure"];
        [ApplicationInfo sharedInstance].currentMode = @"twoTabletMode";
    }
}


@end
