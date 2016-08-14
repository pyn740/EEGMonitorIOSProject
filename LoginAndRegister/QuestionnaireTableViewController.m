//
//  QuestionnaireTableViewController.m
//  nirsit
//
//  Created by admin on 15/7/23.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "QuestionnaireTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface QuestionnaireTableViewController (){
 
}

@end

@implementation QuestionnaireTableViewController

@synthesize otherItems,otherItemsIndex;

static NSString * const reuseIdentifier = @"CollectViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //UIImageView * vi = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_bg"]];
    //[self.tableView setBackgroundView:vi];
    
    _firstName.layer.cornerRadius = 8.0;
    _firstName.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _firstName.layer.borderWidth = 1.5;
    _lastName.layer.cornerRadius = 8.0;
    _lastName.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _lastName.layer.borderWidth = 1.5;
    _age.layer.cornerRadius = 8.0;
    _age.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _age.layer.borderWidth = 1.5;
    _weight.layer.cornerRadius = 8.0;
    _weight.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _weight.layer.borderWidth = 1.5;
    _height.layer.cornerRadius = 8.0;
    _height.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _height.layer.borderWidth = 1.5;
    _maxBloodPressure.layer.cornerRadius = 8.0;
    _maxBloodPressure.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _maxBloodPressure.layer.borderWidth = 1.5;
    _minBloodPressure.layer.cornerRadius = 8.0;
    _minBloodPressure.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _minBloodPressure.layer.borderWidth = 1.5;
    _exercise.layer.cornerRadius = 8.0;
    _exercise.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _exercise.layer.borderWidth = 1.5;
    _coffee.layer.cornerRadius = 8.0;
    _coffee.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _coffee.layer.borderWidth = 1.5;
    _alcohol.layer.cornerRadius = 8.0;
    _alcohol.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _alcohol.layer.borderWidth = 1.5;
    _smoking.layer.cornerRadius = 8.0;
    _smoking.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    _smoking.layer.borderWidth = 1.5;

    
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"NotoSansCJKkr-Regular" size:25],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                             };
    
    [self.sexSegement setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    [self.raceSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    [self.priorSegment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"NotoSansCJKkr-Regular" size:25],
                                               NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.sexSegement setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [self.raceSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [self.priorSegment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    [self.otherDisease registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    otherItems = [NSArray arrayWithObjects:@"Blood Disorder",@"Breast Disease",@"Digestive Disease",@"Endocrine,nutrition,Metabolic Disease",@"Diseases of Eye and Adnexa",@"Foot Disease",@"Musculoskeletal Disorders",@"Orthopedic Problems",@"Respiratory Diseases",@"Voice Disorder", nil];
    otherItemsIndex = [[NSMutableArray alloc] init];
    /*
     selectFlags = [[NSMutableArray alloc] initWithCapacity:[otherItems count]];
     for (int i = 0; i < [otherItems count]; i ++) {
     [selectFlags insertObject:[NSNumber numberWithInt:-1] atIndex:i];
     }
     */
    
    self.otherDisease.allowsMultipleSelection = YES;
    self.otherDisease.delegate = self;
    self.otherDisease.dataSource = self;

}

-(void)viewWillDisappear:(BOOL)animated{

//    for (NSIndexPath * indexPath in self.otherDisease.indexPathsForSelectedItems) {
//        NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
//    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return otherItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    for (UIView * aView in [cell.contentView subviews]) {
        [aView removeFromSuperview];
    }
    /*
     if ([selectFlags[indexPath.row] isEqualToNumber:[NSNumber numberWithInt:1]]) {
     cell.contentView.backgroundColor = [UIColor grayColor];
     }else{
     cell.contentView.backgroundColor = nil;
     }
     */
    if (cell.selected == YES) {
        cell.contentView.backgroundColor = [UIColor lightTextColor];
        cell.contentView.alpha = 0.3;
    }else{
        cell.contentView.backgroundColor = nil;
    }
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    title.text = [otherItems objectAtIndex:indexPath.row];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"NotoSansCJKkr-Regular" size:25];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    title.layer.cornerRadius = 8;
    title.layer.borderColor = [UIColor colorWithRed:142.0/255 green:216.0/255 blue:248.0/255 alpha:0.3].CGColor;
    title.layer.borderWidth = 1.5;
    [cell.contentView addSubview:title];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    cell.contentView.backgroundColor = [UIColor colorWithRed:9.0/255 green:121.0/255 blue:179.0/255 alpha:1.0];
    [otherItemsIndex addObject:[NSNumber numberWithInteger:indexPath.row]];
    
    /*
     if ([selectFlags[indexPath.row] isEqualToNumber:[NSNumber numberWithInt:1]]) {
     selectFlags[indexPath.row] = [NSNumber numberWithInt:-1];
     }else{
     selectFlags[indexPath.row] = [NSNumber numberWithInt:1];
     }
     [collectionView reloadData];
     */
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [otherItemsIndex removeObject:[NSNumber numberWithInteger:indexPath.row]];
    cell.selected =NO;
    cell.contentView.backgroundColor = nil;
    /*
     selectFlags[indexPath.row] = [NSNumber numberWithInt:-1];
     [collectionView reloadData];
     */
}

@end
