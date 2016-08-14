//
//  QuestionnaireTableViewController.h
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireTableViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)NSArray * otherItems;
@property (strong, nonatomic)NSMutableArray * otherItemsIndex;

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;

@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegement;
@property (weak, nonatomic) IBOutlet UISegmentedControl *raceSegment;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *height;

@property (weak, nonatomic) IBOutlet UITextField *maxBloodPressure;
@property (weak, nonatomic) IBOutlet UITextField *minBloodPressure;

@property (weak, nonatomic) IBOutlet UITextField *exercise;
@property (weak, nonatomic) IBOutlet UITextField *coffee;
@property (weak, nonatomic) IBOutlet UITextField *alcohol;
@property (weak, nonatomic) IBOutlet UITextField *smoking;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorSegment;
@property (weak, nonatomic) IBOutlet UICollectionView *otherDisease;

@end
