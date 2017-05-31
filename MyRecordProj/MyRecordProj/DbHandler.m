//
//  DbHandler.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "DbHandler.h"
#import "MyCommonHeaders.h"
#import "RecordSection.h"
#import "RecordSectionItem.h"

const NSInteger kDbIdDefaultSize = 128;
const NSInteger kDbIdRecordTitleSize = 1024;
const NSInteger kDbIdRecordItemTxtSize = 2048;
const NSInteger kDbIdCategoryTitleSize = 256;

static __strong FMDatabase *dbRecords;

@implementation DbHandler
+(void)initLocalDatabase
{
    if (nil == dbRecords) {
        dbRecords = [FMDatabase databaseWithPath:[DbHandler pathOfRecordsDb]];
        
        if (![dbRecords open]) {
            // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
            dbRecords = nil;
        }
    }
    
    if (nil != dbRecords) {
        //record info
        [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `record_info`"
         @"(`record_id` char(128) PRIMARY KEY NOT NULL,"
         @"`record_title` varchar(1024) NOT NULL,"
         @"`create_time` integer,"
         @"`category_id` char(128))"];
        //record sections
        [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `record_section`"
         @"(`record_id` char(128) NOT NULL,"
         @"`section_id` integer,"
         @"`section_type` char(16),"
         @"PRIMARY KEY (`record_id`,`section_id`))"];
        //record section item
        [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `record_section_item`"
         @"(`record_id` char(128) NOT NULL,"
         @"`section_id` integer,"
         @"`item_id` integer,"
         @"`item_txt` varchar(2048),"
         @"`item_img_thumb_id` char(128),"
         @"`item_img_id` char(128),"
         @"PRIMARY KEY (`record_id`,`section_id`,`item_id`))"];
        //record category
        [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `record_category`"
         @"(`category_id` char(128) PRIMARY KEY NOT NULL,"
         @"`category_title` varchar(256) NOT NULL,"
         @"`create_time` integer)"];
        //setting
        [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `settings`"
         @"(`setting_id` char(128) PRIMARY KEY NOT NULL,"
         @"`setting_value` varchar(1024) NOT NULL)"];
    }
    
    [DbHandler migrateDb];
}

+(void)migrateDb
{
    FMDBMigrationManager * manager=[FMDBMigrationManager managerWithDatabase:dbRecords migrationsBundle:[NSBundle mainBundle]];
    BOOL resultState=NO;
    NSError * error=nil;
    if (!manager.hasMigrationsTable) {
        resultState=[manager createMigrationsTable:&error];
    }
    resultState=[manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
}

+(NSString *)pathOfRecordsDb
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *path2ret=[docDir stringByAppendingPathComponent:@"records.db"];
    return path2ret;
}

+(void)closeLocalDatabase
{
    [dbRecords close];
    
    dbRecords=nil;
}

+(NSMutableArray *)getAllCategoryInfo
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_category` ORDER BY `create_time` DESC"];
    while ([s next]) {
        CategoryInfo *aCategory=[CategoryInfo new];
        
        aCategory.categoryId=[s stringForColumn:@"category_id"];
        aCategory.categoryTitle=[s stringForColumn:@"category_title"];
        aCategory.createTime=[s longLongIntForColumn:@"create_time"];
        
        aCategory.recordCount=[DbHandler getRecordInfoCountForCategory:aCategory.categoryId];
        
        [arr2ret addObject:aCategory];
    }
    
    return arr2ret;
}

+(CategoryInfo *)getCategoryInfoWithId:(NSString *)categoryId
{
    FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_category` WHERE `category_id` = ?",categoryId];
    if ([s next]) {
        CategoryInfo *aCategory=[CategoryInfo new];
        
        aCategory.categoryId=[s stringForColumn:@"category_id"];
        aCategory.categoryTitle=[s stringForColumn:@"category_title"];
        aCategory.createTime=[s longLongIntForColumn:@"create_time"];
        
        aCategory.recordCount=[DbHandler getRecordInfoCountForCategory:aCategory.categoryId];
        
        return aCategory;
    }
    
    return nil;
}

+(void)addOrUpdateCategoryInfo:(CategoryInfo *)info
{
    if ([MyUtility isStringNilOrZeroLength:info.categoryId] ||
        [MyUtility isStringNilOrZeroLength:info.categoryTitle]) {
        return;
    }
    [dbRecords executeUpdate:@"INSERT OR REPLACE INTO `record_category` (`category_id`,`category_title`,`create_time`) VALUES (?,?,?)",
     info.categoryId,
     info.categoryTitle,
     [NSString stringWithFormat:@"%lld",info.createTime]];
    
    [[MyCustomNotificationObserver sharedObserver] reportCustomNotificationWithKey:CUSTOM_NOTIFICATION_FOR_DB_CATEGORY_INFO_UPDATE andContent:@""];
}

+(void)deleteCategoryWithId:(NSString *)categoryId
{
    if ([MyUtility isStringNilOrZeroLength:categoryId]) {
        return;
    }
    [dbRecords executeUpdate:@"DELETE FROM `record_category` WHERE `category_id` = ?",
     categoryId];
    
    [[MyCustomNotificationObserver sharedObserver] reportCustomNotificationWithKey:CUSTOM_NOTIFICATION_FOR_DB_CATEGORY_INFO_UPDATE andContent:@""];
}

+(NSArray *)getRecordInfoWithCategoryId:(NSString *)categoryId
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_info` WHERE `category_id` = ? ORDER BY `create_time` DESC",categoryId];
    while ([s next]) {
        RecordInfo *aRecord=[RecordInfo new];
        
        aRecord.recordId=[s stringForColumn:@"record_id"];
        aRecord.recordTitle=[s stringForColumn:@"record_title"];
        aRecord.createTime=[s longLongIntForColumn:@"create_time"];
        aRecord.categoryId=[s stringForColumn:@"category_id"];
        
        aRecord.sectionArr=[DbHandler getRecordSectionWithRecordId:aRecord.recordId];
        
        [arr2ret addObject:aRecord];
    }
    
    return arr2ret;
}

+(RecordInfo *)getRecordInfoWithRecordId:(NSString *)recordId
{
    RecordInfo *record2ret=nil;
    
    if (![MyUtility isStringNilOrZeroLength:recordId]) {
        FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_info` WHERE `record_id` = ?",recordId];
        if ([s next]) {
            record2ret=[RecordInfo new];
            
            record2ret.recordId=[s stringForColumn:@"record_id"];
            record2ret.recordTitle=[s stringForColumn:@"record_title"];
            record2ret.createTime=[s longLongIntForColumn:@"create_time"];
            record2ret.categoryId=[s stringForColumn:@"category_id"];
            
            record2ret.sectionArr=[DbHandler getRecordSectionWithRecordId:recordId];
        }
    }
    
    return record2ret;
}

+(UInt64)getAllRecordInfoCount
{
    UInt64 count2ret=0;
    
    FMResultSet *s = [dbRecords executeQuery:@"SELECT COUNT(*) FROM `record_info`"];
    if (s && [s next]) {
        count2ret=[s longLongIntForColumnIndex:0];
    }
    return count2ret;
}

+(UInt64)getRecordInfoCountForCategory:(NSString *)categoryId
{
    UInt64 count2ret=0;
    
    if (![MyUtility isStringNilOrZeroLength:categoryId]) {
        FMResultSet *s = [dbRecords executeQuery:@"SELECT COUNT(*) FROM `record_info` WHERE `category_id`=?",categoryId];
        if (s && [s next]) {
            count2ret=[s longLongIntForColumnIndex:0];
        }
    }
    
    return count2ret;
}

+(void)storeRecordWithInfo:(RecordInfo *)record2store
{
    [dbRecords beginTransaction];
    
    //record info
    [dbRecords executeUpdate:@"INSERT OR REPLACE INTO `record_info` (`record_id`,`record_title`,`create_time`,`category_id`) VALUES (?,?,?,?)",
     record2store.recordId,
     record2store.recordTitle,
     [NSString stringWithFormat:@"%lld",record2store.createTime],
     record2store.categoryId];
    
    //record section
//    [dbRecords executeUpdate:@"CREATE TABLE IF NOT EXISTS `record_section`"
//     @"(`record_id` char(128) NOT NULL,"
//     @"`section_id` integer,"
//     @"`section_type` char(16),"
//     @"PRIMARY KEY (`record_id`,`section_id`))"];
    for (RecordSection *aSection in record2store.sectionArr) {
        [dbRecords executeUpdate:@"INSERT OR REPLACE INTO `record_section` (`record_id`,`section_id`,`section_type`) VALUES (?,?,?)",
         aSection.recordId,
         [NSString stringWithFormat:@"%lld",aSection.sectionId],
         aSection.sectionType];
        
        //record section item
        for (RecordSectionItem *aSectionItem in aSection.sectionItemArr) {
            [dbRecords executeUpdate:@"INSERT OR REPLACE INTO `record_section_item` (`record_id`,`section_id`,`item_id`,`item_txt`,`item_img_thumb_id`,`item_img_id`) VALUES (?,?,?,?,?,?)",
             aSectionItem.recordId,
             [NSString stringWithFormat:@"%lld",aSectionItem.sectionId],
             [NSString stringWithFormat:@"%lld",aSectionItem.itemId],
             aSectionItem.itemTxt,
             aSectionItem.imgThumbId,
             aSectionItem.imgId];
        }
    }
    
    [dbRecords commit];
    
    [[MyCustomNotificationObserver sharedObserver] reportCustomNotificationWithKey:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE andContent:record2store.recordId];
}

+(void)deleteRecordInfoWithId:(RecordInfo *)record2del
{
    if ([MyUtility isStringNilOrZeroLength:record2del.recordId]) {
        return;
    }
    [dbRecords executeUpdate:@"DELETE FROM `record_info` WHERE `record_id` = ?", record2del.recordId];
    [dbRecords executeUpdate:@"DELETE FROM `record_section` WHERE `record_id` = ?", record2del.recordId];
    [dbRecords executeUpdate:@"DELETE FROM `record_section_item` WHERE `record_id` = ?", record2del.recordId];
    
    [[MyCustomNotificationObserver sharedObserver] reportCustomNotificationWithKey:CUSTOM_NOTIFICATION_FOR_DB_RECORD_INFO_UPDATE andContent:record2del.recordId];
}

+(NSMutableArray *)getRecordSectionWithRecordId:(NSString *)recordId
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_section` WHERE `record_id` = ? ORDER BY `section_id`",recordId];
    while ([s next]) {
        RecordSection *aRecordSection=[RecordSection new];
        
        aRecordSection.recordId=[s stringForColumn:@"record_id"];
        aRecordSection.sectionId=[s longLongIntForColumn:@"section_id"];
        aRecordSection.sectionType=[s stringForColumn:@"section_type"];
        
        aRecordSection.sectionItemArr=[DbHandler getRecordSectionItemWithRecordId:aRecordSection.recordId andSectionId:aRecordSection.sectionId];
        
        [arr2ret addObject:aRecordSection];
    }
    
    return arr2ret;
}

+(NSMutableArray *)getRecordSectionItemWithRecordId:(NSString *)recordId andSectionId:(UInt64)sectionId
{
    NSMutableArray *arr2ret=[NSMutableArray new];
    
    FMResultSet *s = [dbRecords executeQuery:@"SELECT * FROM `record_section_item` WHERE `record_id` = ? AND `section_id` = ? ORDER BY `item_id`",recordId,[NSString stringWithFormat:@"%lld",sectionId]];
    while ([s next]) {
        RecordSectionItem *aRecord=[RecordSectionItem new];
        
        aRecord.recordId=[s stringForColumn:@"record_id"];
        aRecord.sectionId=[s longLongIntForColumn:@"section_id"];
        aRecord.itemId=[s longLongIntForColumn:@"item_id"];
        aRecord.itemTxt=[s stringForColumn:@"item_txt"];
        aRecord.imgThumbId=[s stringForColumn:@"item_img_thumb_id"];
        aRecord.imgId=[s stringForColumn:@"item_img_id"];
        
        [arr2ret addObject:aRecord];
    }
    
    return arr2ret;
}

+(NSString *)getStrSettingWithKey:(NSString *)key andDefValue:(NSString *)defStr
{
    NSString *str2ret=defStr;
    
    if (![MyUtility isStringNilOrZeroLength:key]) {
        FMResultSet *s = [dbRecords executeQuery:@"SELECT `setting_value` FROM `settings` WHERE `setting_id` = ?",key];
        if (s && [s next]) {
            str2ret=[s stringForColumn:@"setting_value"];
        }
    }
    
    return str2ret;
}
+(UInt64)getIntSettingWithKey:(NSString *)key andDefValue:(UInt64)defInt
{
    UInt64 int2ret=defInt;
    
    NSString *strValue=[DbHandler getStrSettingWithKey:key andDefValue:nil];
    if (![MyUtility isStringNilOrZeroLength:strValue]) {
        int2ret=[strValue longLongValue];
    }
    
    return int2ret;
}
@end
