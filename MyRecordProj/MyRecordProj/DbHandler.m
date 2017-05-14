//
//  DbHandler.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "DbHandler.h"
#import <MyIosFramework/MyIosFramework.h>

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
        [dbRecords executeUpdate:@"CREATE TALBE IF NOT EXISTS `record_info`"
         @"(`record_id` char(128) PRIMARY KEY NOT NULL,"
         @"`record_title` varchar(1024) NOT NULL,"
         @"`create_time` integer,"
         @"`category_id` char(128))"];
        //record sections
        [dbRecords executeUpdate:@"CREATE TALBE IF NOT EXISTS `record_section`"
         @"(`record_id` char(128) NOT NULL,"
         @"`section_id` integer,"
         @"`section_type` char(16),"
         @"PRIMARY KEY (`record_id`,`section_id`))"];
        //record section item
        [dbRecords executeUpdate:@"CREATE TALBE IF NOT EXISTS `record_section_item`"
         @"(`record_id` char(128) NOT NULL,"
         @"`section_id` integer,"
         @"`item_id` integer,"
         @"`item_txt` varchar(2048),"
         @"`item_img_thumb_id` char(128),"
         @"`item_img_id` char(128),"
         @"PRIMARY KEY (`record_id`,`section_id`,`item_id`))"];
        //record category
        [dbRecords executeUpdate:@"CREATE TALBE IF NOT EXISTS `record_category`"
         @"(`category_id` char(128) PRIMARY KEY NOT NULL,"
         @"`category_title` varchar(256) NOT NULL,"
         @"`create_time` integer)"];
        //setting
        [dbRecords executeUpdate:@"CREATE TALBE IF NOT EXISTS `settings`"
         @"(`setting_id` char(128) PRIMARY KEY NOT NULL,"
         @"`setting_value` varchar(1024) NOT NULL)"];
    }
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
@end
