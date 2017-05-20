//
//  MyCustomNotificationObserver.h
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *MyCustomNotificationContent_key;
extern NSString *MyCustomNotificationContent_content;

@protocol MyCustomNotificationActionDelegate <NSObject>

-(void)didReceivecMyCustomNotification:(NSDictionary *)notificationDict;

@end

@interface MyCustomNotificationObserver : NSObject

+(MyCustomNotificationObserver *)sharedObserver;

-(void)addCustomOvserverWithDelegate:(id<MyCustomNotificationActionDelegate>)delegate andKey:(NSString *)key;
-(void)removeCustomObserverForDelegate:(id<MyCustomNotificationActionDelegate>)delegate andKey:(NSString *)key;

-(void)reportCustomNotificationWithDict:(NSDictionary *)dict2report;
-(void)reportCustomNotificationWithKey:(NSString *)key andContent:(NSString *)content;
@end
