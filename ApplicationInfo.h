//
//  ApplicationInfo.h
//  nirsit
//
//  Created by admin on 15/9/5.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqliteDB.h"
#import "GetDataFromDevice.h"


@interface ApplicationInfo : NSObject

@property(nonatomic,strong)NSString * currentMode;
@property(nonatomic,strong)NSString * currentTitle;
@property(nonatomic,strong)sqliteDB * myDB;
@property(nonatomic,strong)GetDataFromDevice * someData;
@property(nonatomic)BOOL measureFlag;

//by richard
@property(nonatomic)BOOL LPFOption;
@property(nonatomic)BOOL InitHemo;
@property(nonatomic)BOOL MBLLOption;
@property(nonatomic)BOOL SurfaceContaminationOption;
@property(nonatomic)BOOL MotionArtifactOption;
@property(nonatomic)BOOL NAChannelRejection;
@property(nonatomic)BOOL NAFinish;
@property(nonatomic)BOOL BilinearInterpolationOption;
@property(nonatomic)BOOL SimultaneousDOTOption;
@property(nonatomic)BOOL IterativeDOTOption;
@property(nonatomic)BOOL UpdateThreshold_linear;
@property(nonatomic)float Threshold_linear;
@property(nonatomic)BOOL UpdataThreshold_comp;
@property(nonatomic)float Threshold_comp;
@property(nonatomic)BOOL UpdateCurvature_comp;
@property(nonatomic)float Curvature_comp;
@property(nonatomic)BOOL UpdateOffset_comp;
@property(nonatomic)float Offset_comp;
@property(nonatomic)int UnitIntervalNanoSec;
@property(nonatomic)int Dpdata;
@property(nonatomic)BOOL HeartBeat;
@property(nonatomic)BOOL MotionCalibrationOption;
@property(nonatomic)BOOL MotionFirstCalibration;
@property(nonatomic)BOOL MotionRestStartFlag;
@property(nonatomic)BOOL MotionTiltStartFlag;
@property(nonatomic)BOOL MotionTiltStopFlag;
@property(nonatomic)BOOL ActivationModeOption;
@property(nonatomic)BOOL AverageModeOption;
@property(nonatomic)BOOL MotionCompensationOption;
@property(nonatomic)BOOL DriftOption;
@property(nonatomic)BOOL DriftInitDC;
@property(nonatomic)BOOL isTaskMode;
@property(nonatomic)int ColoringModeOption;

@property(nonatomic)BOOL peakingMotorOption;

+(ApplicationInfo *)sharedInstance;

@end
