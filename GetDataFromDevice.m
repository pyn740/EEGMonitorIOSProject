//
//  GetDataFromDevice.m
//  AgainToGetDataFromNIRSIT
//
//  Created by admin on 15/9/22.
//  Copyright © 2015年 cqupt. All rights reserved.
//

#import "GetDataFromDevice.h"
#import "AsyncSocket.h"
#import "ApplicationInfo.h"


@interface GetDataFromDevice ()<AsyncSocketDelegate>
{
    AsyncSocket * socket;
    BOOL finished;
    //BOOL started;
    int totalNum;
}

@end

@implementation GetDataFromDevice

-(void)startGetDataFromDevice{
    //NSLog(@"%@",[NSThread currentThread]);
    socket = [[AsyncSocket alloc] initWithDelegate:self];
    [socket connectToHost:@"192.168.0.1" onPort:50007 error:nil];
    
}

-(void)readyToStart{
    UnitySendMessage("BluethoothRecv","setX","0");
    UnitySendMessage("BluethoothRecv","resetBrain","1");
    [self performSelector:@selector(startToMeasure) withObject:nil afterDelay:5];
    //[self performSelector:@selector(startToMeasure) withObject:nil afterDelay:5];    //richard
}

-(void)startToMeasure{
    UnitySendMessage("BluethoothRecv","measureStart","");
    [ApplicationInfo sharedInstance].measureFlag = YES;
    [socket writeData:[@"y" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    //[socket readDataToLength:340 withTimeout:-1 tag:0];
    [socket readDataToLength:680 withTimeout:-1 tag:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        double totelTime = 0;
        totalNum = 0;
        //BOOL paused = NO;
        finished = NO;
        while (!finished) {
            if ([ApplicationInfo sharedInstance].measureFlag) {
            totelTime += 0.12288;
            if (totelTime > 15 && totelTime <= 15.2) {
                [ApplicationInfo sharedInstance].LPFOption = YES;
            }
            if (totelTime > 20 && totelTime <= 20.2) {
                [ApplicationInfo sharedInstance].HeartBeat = YES;
            }
            if (totelTime > 22 && totelTime <= 22.2) {
                [ApplicationInfo sharedInstance].DriftInitDC = YES;
            }
            if (totelTime > 25 && totelTime <= 25.2) {
                [ApplicationInfo sharedInstance].NAFinish = YES;
                [ApplicationInfo sharedInstance].InitHemo = YES;
                [ApplicationInfo sharedInstance].MBLLOption = YES;
            }
            
            //[self.delegate showTimeInfo:totalNum];
            [NSThread sleepForTimeInterval:0.12288];
            //NSLog(@"----------------->还在继续:%f",[[NSDate date] timeIntervalSince1970]);
            }
        }
    });

}

-(void)stopMeasure{
    finished = YES;
    UnitySendMessage("BluethoothRecv","stopMeasure","");
   
    [socket writeData:[@"z" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    //[socket readDataToLength:340 withTimeout:-1 tag:0];
    [socket readDataToLength:680 withTimeout:-1 tag:0];
    [ApplicationInfo sharedInstance].measureFlag = NO;
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"did connect to host.");
    [socket writeData:[@"t" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    //[socket readDataToLength:340 withTimeout:-1 tag:0];
    [socket readDataToLength:4 withTimeout:-1 tag:0];    //richard
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //NSLog(@"did read data");
    
    //NSLog(@"Time Check-----");
    NSString * string = [self dataChangeTo16String:data];
    if ([ApplicationInfo sharedInstance].measureFlag) {
        
       // NSLog(@"Time:%f Data:%@",[[NSDate date] timeIntervalSince1970],string);   //richard
        //NSLog(@"Put Row Data to Unity:%f",[[NSDate date] timeIntervalSince1970]);
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               UnitySendMessage("BluethoothRecv","read",[string UTF8String]);

       });
             [self.delegate getData:string];
    }else{
    
        if ([[string substringToIndex:11] isEqualToString:@"DC DC DC DC"]) {
            //NSLog(@"ok");
            [socket writeData:[@"u" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
        }
    }
    //[socket readDataToLength:340 withTimeout:-1 tag:0];
    [socket readDataToLength:680 withTimeout:-1 tag:0];
   
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"close connected");
}

//by richard
-(NSString *)dataChangeTo16String:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString * hexStr=@"";
    
    for(int i = 0;i < [data length] ; i++){
        NSString * newHexStr = [NSString stringWithFormat:@"%02X ",bytes[i] & 0xff];///16进制数
        hexStr = [hexStr stringByAppendingString:newHexStr];
    }
   // NSLog(@"%@",hexStr);
    //NSLog(@"Time Check-----");   //richard
    return hexStr;
}

/*
-(NSString *)dataChangeTo16String:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString * hexStr=@"";
    
    for(int i = 0;i < [data length] ; i++){
        NSString * newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
        if (i ==0) {
            if([newHexStr length]==1)
            {
                hexStr = [NSString stringWithFormat:@"0%@",newHexStr];
                NSLog(@"1: %@", hexStr);
            }
            else
            {
                hexStr = newHexStr;
                NSLog(@"2: %@", hexStr);
            }
        }
        else
        {
            if([newHexStr length]==1)
            {
                hexStr = [NSString stringWithFormat:@"%@ 0%@",hexStr,newHexStr];
                NSLog(@"3: %@", hexStr);
            }
            else
            {
                hexStr = [NSString stringWithFormat:@"%@ %@",hexStr,newHexStr];
                NSLog(@"4: %@", hexStr);
            }
        }
    }
    //NSLog(@"%@",hexStr);
    return hexStr;
}
*/

-(void)stopGetDataFromDevice{
    [socket disconnect];
}


@end
