//
//  RecordSection.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECTION_TYPE_TXT @"txt"
#define SECTION_TYPE_IMAGE @"img"

@interface RecordSection : NSObject
@property (nonatomic,copy) NSString *recordId;
@property (nonatomic,assign) UInt64 sectionId;
@property (nonatomic,copy) NSString *sectionType;

@property (nonatomic,strong) NSMutableArray *sectionItemArr;
@end
