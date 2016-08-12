//
//  PlotSettingViewController.m
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "PlotSettingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+UIImageScale.h"
#import "SelectUserViewController.h"

@interface PlotSettingViewController (){
    UIActivityIndicatorView * dicatorView;
}

@property(nonatomic,strong)AVCaptureSession * captureSession;
@property(nonatomic,strong)AVCaptureDeviceInput * captureDeviceInput;
@property(nonatomic,strong)AVCaptureStillImageOutput * captureStillImageOutput;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;

@end

@implementation PlotSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self disableRightBottomView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    dicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    dicatorView.frame = CGRectMake(0, 65, 1024, 703);
    [dicatorView setCenter:CGPointMake(512, 352)];
    [self.view addSubview:dicatorView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    
    AVCaptureDevice * captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    if (!captureDevice) {
        NSLog(@"can't get front camera!");
        return;
    }
    
    NSError * error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"get device input occur error, reason is:%@",error.localizedDescription);
        return;
    }
    
    _captureStillImageOutput =[[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImageOutput setOutputSettings:outputSettings];
    
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    CALayer * layer = self.liveView.layer;
    layer.masksToBounds = YES;
    
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    captureConnection.videoOrientation = (AVCaptureVideoOrientation)orientation;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer addSublayer:_captureVideoPreviewLayer];
    [ApplicationInfo sharedInstance].currentTitle = @"PlotSetting";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    AVCaptureConnection *captureConnection = [self.captureVideoPreviewLayer connection];
    captureConnection.videoOrientation = (AVCaptureVideoOrientation)toInterfaceOrientation;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    _captureVideoPreviewLayer.frame = self.liveView.bounds;
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position{
    NSArray * cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice * camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}


#pragma mark - back or next event

-(void)toNextMenu:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Calibration"];
    [self performSegueWithIdentifier:@"toCalibrationSegue" sender:self];
}

-(void)backToLastMenu:(id)sender{
//    if ([self.whoComeIn isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"Questionnaire"];
//    }
    SelectUserViewController * selectUserVC;
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SelectUserViewController class]]) {
            selectUserVC = (SelectUserViewController *)vc;
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTitle" object:@"SelectUser"];
    [self.navigationController popToViewController:selectUserVC animated:YES];
}

#pragma mark - button click event

- (IBAction)cameraBtnSelected:(id)sender {
    
    [dicatorView startAnimating];
    
    AVCaptureConnection * captureConnection = [self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [captureConnection setVideoOrientation:(AVCaptureVideoOrientation)[[UIApplication sharedApplication] statusBarOrientation]];
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            @autoreleasepool {
                NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage * image;
                image = [UIImage imageWithData:imageData];
                image = [image fixOrientation:image];
                image = [image getSubImage:CGRectMake((image.size.width-image.size.height*400.0/412.0)/2.0, 0.0, image.size.height*400.0/412.0, image.size.height)];
                
                UIImageOrientation flip = UIImageOrientationUpMirrored;
                image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:flip];
                
                self.preView.image = image;
                //            CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
                //            self.preView.layer.transform = transform;
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            
            [dicatorView stopAnimating];
            
            self.preView.layer.borderWidth = 2;
            self.preView.layer.borderColor = [UIColor greenColor].CGColor;
            [self ableRightBottomView];
        }
    }];
    
//    [(UIButton *)[self.rightBottomView viewWithTag:15] setEnabled:YES];
//    [(UIImageView *)[self.rightBottomView viewWithTag:16] setImage:[UIImage imageNamed:@"arrow_right_focus"]];
}

@end
