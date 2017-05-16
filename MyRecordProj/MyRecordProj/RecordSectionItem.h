//
//  RecordSectionItem.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/16.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordSectionItem : NSObject
@property (nonatomic,copy) NSString *recordId;
@property (nonatomic,assign) UInt64 sectionId;
@property (nonatomic,assign) UInt64 itemId;
@property (nonatomic,copy) NSString *itemTxt;
@property (nonatomic,copy) NSString *imgThumbId;
@property (nonatomic,copy) NSString *imgId;
@end
