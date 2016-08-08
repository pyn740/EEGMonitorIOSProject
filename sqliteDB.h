//
//  sqliteDB.h
//  scenehouseios
//
//  Created by cqupt cqupt on 13-8-20.
//  Copyright (c) 2013年 roselife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sqliteDB : NSObject

@property (nonatomic, retain) NSString * dbPath;

- (void)createInfoTable;
- (void)createRawDataTable:(NSString *)tableName;

- (BOOL)insertTable:(NSString *)tablename  andXvalue:(NSTimeInterval)xvalue andRawdata:(NSString *)rawdata andMarker:(NSString *)marker;
- (BOOL)insertAdminWithEmail:(NSString *)email andPwd:(NSString *)pwd;
- (BOOL)insertUserWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAge:(NSString *)age andGender:(NSString *)gender andRace:(NSString *)race andWeight:(NSString *)weight andHeight:(NSString *)height andMaxbloodPressure:(NSString *)maxbloodPressure andMinbloodPressure:(NSString *)minbloodPressure andExercise:(NSString *)exercise andCoffee:(NSString *)coffee andAlcohol:(NSString *)alcohol andSmoking:(NSString *)smoking andPriorIllness:(NSString *)priorIllness andAllDisease:(NSString *)allDisease andAdminEmail:(NSString *)adminEmail;
- (void)deleteRowdataTable:(NSString *)rowDataTableName;

- (NSInteger)getCurrentRowDataTableCount;
- (NSMutableArray *)getReplayNameFromTableList;
- (NSMutableArray *)getUserListThrounghEmail:(NSString *)email;
//- (NSMutableArray *)getReplayDataFromDataBase:(NSString *)rowDataTableName;
- (NSDictionary *)getReplayDataFromDataBase:(NSString *)rowDataTableName andIndex:(int)index;
- (NSInteger)getReplayDataCount:(NSString *)rowName;

- (NSInteger)detectIfAlreadyExistEmail:(NSString *)emailStr;
- (NSInteger)detectAdminIfCanLoginWithEmail:(NSString *)email andPwd:(NSString *)pwd;

@end
