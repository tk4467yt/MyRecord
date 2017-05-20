//
//  MyCustomNotificationObserver.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/20.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "MyCustomNotificationObserver.h"
#import "MyCommonHeaders.h"

NSString *MyCustomNotificationContent_key=@"custom_notification_key";
NSString *MyCustomNotificationContent_content=@"custom_notification_content";

static __strong MyCustomNotificationObserver *sharedObserver=nil;

@interface MyCustomNotificationObserver ()

@property (nonatomic,retain) NSMutableDictionary *observerDict;

@property (nonatomic,retain) NSMutableArray *dict2reportArr;
@end

@implementation MyCustomNotificationObserver
+(MyCustomNotificationObserver *)sharedObserver
{
    if (nil == sharedObserver) {
        sharedObserver=[[MyCustomNotificationObserver alloc] init];
        sharedObserver.observerDict=[NSMutableDictionary new];
        sharedObserver.dict2reportArr=[NSMutableArray new];
    }
    
    return sharedObserver;
}

-(void)addCustomOvserverWithDelegate:(id<MyCustomNotificationActionDelegate>)delegate andKey:(NSString *)key
{
    NSLog(@"add custom notification for %@-%@",delegate,key);
    
    if (nil == delegate || [MyUtility isStringNilOrZeroLength:key]) {
        NSLog(@"add cumstom observer fail with empty parameter");
        return;
    }
    
    NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:key];
    if (nil == observerArr) {
        observerArr=[NSMutableArray new];
    }
    //check is exist
    for (id<MyCustomNotificationActionDelegate> aObserver in observerArr) {
        if (aObserver == delegate) {
            NSLog(@"duplicate observer exist for %@-%@",delegate,key);
            return;
        }
    }
    //not exist,add to array
    [observerArr addObject:delegate];
    [sharedObserver.observerDict setObject:observerArr forKey:key];
}

-(void)removeCustomObserverForDelegate:(id<MyCustomNotificationActionDelegate>)delegate andKey:(NSString *)key
{
    NSLog(@"remove custom notification for %@-%@",delegate,key);
    //both nil, clear all
    if (nil == delegate && nil == key) {
        [sharedObserver.observerDict removeAllObjects];
        return;
    }
    
    //if delegate nil, clear all delegate for key
    if (nil == delegate) {
        NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:key];
        if (nil != observerArr) {
            [observerArr removeAllObjects];
            [sharedObserver.observerDict setObject:observerArr forKey:key];
        }
        return;
    }
    
    //if key is nil, clear all key for delegate
    for (NSString *aKey in sharedObserver.observerDict.allKeys) {
        NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:aKey];
        if (nil != observerArr) {
            [observerArr removeObject:delegate];
            [sharedObserver.observerDict setObject:observerArr forKey:aKey];
        }
        return;
    }
    
    //both not nil,remove specific key for delegate
    NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:key];
    if (nil != observerArr) {
        [observerArr removeObject:delegate];
        [sharedObserver.observerDict setObject:observerArr forKey:key];
    }
    return;
}

-(void)reportCustomNotificationWithDict:(NSDictionary *)dict2report
{
    if (nil == dict2report) {
        return;
    }
    NSString *key=dict2report[MyCustomNotificationContent_key];
    
    if (nil != key) {
        NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:key];
        if (nil != observerArr && observerArr.count > 0) {
            BOOL isExist=false;
            id content=dict2report[MyCustomNotificationContent_content];
            
            if ([MyUtility isObjectAnString:content]) {
                for (NSDictionary *dict2check in sharedObserver.dict2reportArr) {
                    NSString *key2check=dict2check[MyCustomNotificationContent_key];
                    if ([key2check isEqualToString:key]) {
                        id content2check=dict2check[MyCustomNotificationContent_content];
                        if ([MyUtility isObjectAnString:content2check] && [content2check isEqualToString:content]) {
                            isExist=true;
                            break;
                        }
                    }
                }
            }
            if (!isExist) {
                [sharedObserver.dict2reportArr addObject:dict2report];
                
                [UIView cancelPreviousPerformRequestsWithTarget:self selector:@selector(actionForReportNotification) object:nil];
                [self performSelector:@selector(actionForReportNotification) withObject:nil afterDelay:0.5];
            }
        }
    }
}

-(void)reportCustomNotificationWithKey:(NSString *)key andContent:(NSString *)content
{
    if (nil == key || nil == content) {
        return;
    }
    NSMutableDictionary *dict2report=[NSMutableDictionary new];
    [dict2report setObject:key forKey:MyCustomNotificationContent_key];
    [dict2report setObject:content forKey:MyCustomNotificationContent_content];
    
    [self reportCustomNotificationWithDict:dict2report];
}

-(void)actionForReportNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSDictionary *dict2check in sharedObserver.dict2reportArr) {
            NSString *key2check=dict2check[MyCustomNotificationContent_key];
            NSMutableArray *observerArr=[sharedObserver.observerDict objectForKey:key2check];
            for (id<MyCustomNotificationActionDelegate> aObserver in observerArr) {
                if ([aObserver respondsToSelector:@selector(didReceivecMyCustomNotification:)]) {
                    [aObserver didReceivecMyCustomNotification:dict2check];
                }
            }
        }
        
        [sharedObserver.dict2reportArr removeAllObjects];
    });
}
@end
