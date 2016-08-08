//
//  sqliteDB.m
//  scenehouseios
//
//  Created by cqupt cqupt on 13-8-20.
//  Copyright (c) 2013年 roselife. All rights reserved.
//

#import "sqliteDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface sqliteDB()

@end

@implementation sqliteDB

@synthesize dbPath;


- (void)createInfoTable{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            
            //NSString * sql1 = @"CREATE TABLE 'table_list' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT ,'table_name' text, 'create_date' text)";
            NSString * sql1 = @"CREATE TABLE 'table_list' ('table_name' text, 'create_date' text)";
            BOOL res1 = [db executeUpdate:sql1];
            
            if (!res1) {
                NSLog(@"error when creating table_list table");
            } else {
                NSLog(@"succ to creating table_list table");
            }
            NSString * sql2 = @"CREATE TABLE 'adminInfo' ('email' text ,'password' text)";
            BOOL res2 = [db executeUpdate:sql2];
            if (!res2) {
                NSLog(@"error when creating AdminInfoTable");
            } else {
                NSLog(@"succ to creating AdminInfoTable");
            }
            NSString * sql3 = @"CREATE TABLE 'userInfo' ('age' text ,'gender' text,'maxbloodPressure' text ,'minbloodPressure' text ,'priorIllness' text ,'coffee' text ,'race' text ,'exercise' text ,'smoking' text ,'alcohol' text ,'firstName' text,'lastName' text,'otherDiseases' text,'height' text,'weight' text,'adminEmail' text)";
            //NSString * sql3 = @"CREATE TABLE 'userInfo' ('age' text ,'gender' text,'firstName' text,'adminEmail' text)";
            BOOL res3 = [db executeUpdate:sql3];
            if (!res3) {
                NSLog(@"error when creating UserInfoTable");
            } else {
                NSLog(@"succ to creating UserInfoTable");
            }

            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }else{
        NSLog(@"exist database");
    }
}

- (void)createRawDataTable:(NSString *)tableName{
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        
        NSString * sql =[NSString stringWithFormat:@"CREATE TABLE '%@' ('pid' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'x_value' real ,'raw_data' text,'marker' text)",tableName];
        
        
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"error when creating rawdata table");
        } else {
            NSLog(@"succ to creating rawdata table %@",tableName);
            [self insertTableListWithTableName:tableName];
        }
        [db close];
    } else {
        NSLog(@"error when open db");
    }
}

- (BOOL)insertTable:(NSString *)tablename  andXvalue:(NSTimeInterval)xvalue andRawdata:(NSString *)rawdata andMarker:(NSString *)marker{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (x_value,raw_data,marker) values(?,?,?)",tablename];
        BOOL res = [db executeUpdate:sql,[NSNumber numberWithDouble:xvalue],rawdata,marker,nil];
        
        if (!res) {
            NSLog(@"error to insert data");
            [db close];
            return NO;
        } else {
            //NSLog(@"succ to insert data");
            [db close];
            return YES;
        }
    }else{
        return NO;
    }
}

//inline
- (BOOL)insertTableListWithTableName:(NSString *)rawtablename{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into 'table_list' ('table_name','create_date') values(?,?)"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"LLL dd, yyyy"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSString * str = [formatter stringFromDate:[NSDate date]];
        
        BOOL res = [db executeUpdate:sql,rawtablename,str];
        
        if (!res) {
            NSLog(@"error to insert tableList data");
            [db close];
            return NO;
        } else {
            NSLog(@"succ to insert tableList data");
            [db close];
            return YES;
        }
    }else{
        return NO;
    }
}

- (BOOL)insertAdminWithEmail:(NSString *)email andPwd:(NSString *)pwd{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"insert into adminInfo ('email','password') values(?,?)";
        
        BOOL res = [db executeUpdate:sql,email,pwd];
        
        if (!res) {
            NSLog(@"error to insert data");
            [db close];
            return NO;
        } else {
            //NSLog(@"succ to insert data");
            [db close];
            return YES;
        }
    }else{
        return NO;
    }
}

- (BOOL)insertUserWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andAge:(NSString *)age andGender:(NSString *)gender andRace:(NSString *)race andWeight:(NSString *)weight andHeight:(NSString *)height andMaxbloodPressure:(NSString *)maxbloodPressure andMinbloodPressure:(NSString *)minbloodPressure andExercise:(NSString *)exercise andCoffee:(NSString *)coffee andAlcohol:(NSString *)alcohol andSmoking:(NSString *)smoking andPriorIllness:(NSString *)priorIllness andAllDisease:(NSString *)allDisease andAdminEmail:(NSString *)adminEmail{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"insert into userInfo ('age' ,'gender','maxbloodPressure' ,'minbloodPressure' ,'priorIllness' ,'coffee','race' ,'exercise' ,'smoking' ,'alcohol','firstName','lastName','otherDiseases','height','weight' ,'adminEmail')  values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        BOOL res = [db executeUpdate:sql,age,gender,maxbloodPressure,minbloodPressure,priorIllness,coffee,race,exercise,smoking,alcohol,firstName,lastName,allDisease,height,weight,adminEmail];
        
        if (!res) {
            NSLog(@"error to insert data");
            [db close];
            return NO;
        } else {
            //NSLog(@"succ to insert data");
            [db close];
            return YES;
        }
    }else{
        return NO;
    }
}

- (void)deleteRowdataTable:(NSString *)rowDataTableName {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    [db closeOpenResultSets];
    if ([db open]) {
        
        NSString * sql =[NSString stringWithFormat:@"drop table if exists %@",rowDataTableName];
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            [db close];
            NSLog(@"error to delete all rowData");
        } else {
            [db close];
            NSLog(@"succ to delete all rowData");
            [self deletelistInfo:rowDataTableName];
        }
        
    }
}

//inline
- (void)deletelistInfo:(NSString *)rowDataTableName {
    
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    [db closeOpenResultSets];
    if ([db open]) {
        NSString * sql =[NSString stringWithFormat:@"delete from table_list where table_name = '%@'",rowDataTableName];
        
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"error to delete data");
        } else {
            NSLog(@"succ to delete data");
            
        }
        [db close];
    }
}

-(NSInteger)detectIfAlreadyExistEmail:(NSString *)emailStr{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:@"select count(*) from adminInfo where email = '%@'",emailStr];
        FMResultSet * res = [db executeQuery:sql];
        
        if ([res next]) {
            int totalCount = [res intForColumnIndex:0];
            [db close];
            if (totalCount) {
                return 1;
            }else{
                return 0;
            }
        }else{
            [db close];
            return -1;
        }
    }else{
        NSLog(@"error when open db");
        return -1;
    }
}

-(NSInteger)detectAdminIfCanLoginWithEmail:(NSString *)email andPwd:(NSString *)pwd{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:@"select count(*) from adminInfo where email = '%@' and password = '%@'",email,pwd];
        FMResultSet * res = [db executeQuery:sql];
        
        if ([res next]) {
            int totalCount = [res intForColumnIndex:0];
            [db close];
            if (totalCount == 1) {
                return 1;
            }else{
                return 0;
            }
        }else{
            [db close];
            return -1;
        }
    }else{
        NSLog(@"error when open db");
        return -1;
    }
}

-(NSMutableArray *)getUserListThrounghEmail:(NSString *)email{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select firstName from userInfo where adminEmail = '%@'",email];
        FMResultSet * res = [db executeQuery:sql];
        
        while([res next]) {
            NSString * firstName = [res stringForColumn:@"firstName"];
            [result addObject:firstName];
        }
        [db close];
        return result;
    }else{
        return nil;
    }
}

-(NSInteger)getCurrentRowDataTableCount{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        /*
        NSString * sql = [NSString stringWithFormat:@"select name from sqlite_master where type = 'table'"];
        FMResultSet * res = [db executeQuery:sql];
        int i = 0;
        while([res next]) {
            NSString * totalCount = [res stringForColumnIndex:0];//sqlite_sequence , table_list
            NSLog(@"%@",totalCount);
            i++;
        }
        NSLog(@"count is %d",i);
        return 0;
     */
     
        NSString * sql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table'"];
        FMResultSet * res = [db executeQuery:sql];
        if ([res next]) {
            int totalCount = [res intForColumnIndex:0]-4;//sqlite_sequence , table_list
            [db close];
            if (totalCount < 0) {
                totalCount = 0;
            }
            return totalCount;
        }
        else{
            [db close];
            return -1;
        }
    
    }else{
        return -1;
    }
}

-(NSMutableArray *)getReplayNameFromTableList{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select create_date,table_name from table_list"];
        FMResultSet * res = [db executeQuery:sql];
        
        while([res next]) {
            NSString * createtime = [res stringForColumn:@"create_date"];
            NSString * tablename = [res stringForColumn:@"table_name"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tablename,@"table_name",createtime,@"create_date",nil];
            [result addObject:dic];
        }
        [db close];
        return result;
    }else{
        return nil;
    }
}

-(NSDictionary *)getReplayDataFromDataBase:(NSString *)rowDataTableName andIndex:(int)index{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    //NSMutableArray * result = [[NSMutableArray alloc] init];
    NSDictionary * dic;
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:@"select raw_data from %@ where pid = %d",rowDataTableName,index];
        //NSLog(@"%@",sql);
        FMResultSet * res = [db executeQuery:sql];
        
        if([res next]) {
            //double  x_value = [res doubleForColumn:@"x_value"];
            NSString * raw_data = [res stringForColumn:@"raw_data"];
            //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:x_value,@"x_value",raw_data,@"raw_data",nil];
            //NSLog(@"%f,%@",x_value,raw_data);
            dic = [NSDictionary dictionaryWithObjectsAndKeys:raw_data,@"raw_data",nil];
            //[result addObject:dic];
        }
        //NSLog(@"%@",result);
        [db close];
        return dic;
    }else{
        return nil;
    }
}

-(NSInteger)getReplayDataCount:(NSString *)rowName{

    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
         NSString * sql = [NSString stringWithFormat:@"select count(*) from %@",rowName];
         FMResultSet * res = [db executeQuery:sql];
        if ([res next]) {
            int totalCount = [res intForColumnIndex:0];
            [db close];
            return totalCount;
        }
        else{
            [db close];
            return -1;
        }
    }else{
        return -1;
    }
}


@end
