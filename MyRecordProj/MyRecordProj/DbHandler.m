//
//  DbHandler.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "DbHandler.h"
#import <MyIosFramework/MyIosFramework.h>

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
        //add table create
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
