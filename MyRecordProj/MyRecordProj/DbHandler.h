//
//  DbHandler.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/14.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbHandler : NSObject
+(void)initLocalDatabase;
+(void)closeLocalDatabase;
@end
