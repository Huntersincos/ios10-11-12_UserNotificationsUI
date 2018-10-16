//
//  UserNotifications.m
//  UserNotificationsUIDemo
//
//  Created by wenze on 2018/10/16.
//  Copyright © 2018年 wenze. All rights reserved.
//

#import "UserNotifications.h"
#import <CoreLocation/CoreLocation.h>

static UserNotifications *userCneter = nil;
@implementation UserNotifications

+(UserNotifications *)shareIninstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!userCneter) {
            userCneter  = [[UserNotifications alloc]init];
        }
    });
    return userCneter;
    
}

- (void)requestAuthorization
{
    
    UNUserNotificationCenter *notCenter  = [UNUserNotificationCenter currentNotificationCenter];
    notCenter.delegate = self;
    [notCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
          //[self notficationsLocalPushIOS_10:@"本地推送内容" promptTone:@"voicetiaozhuan.mp3" soundName:@"" imageName:@"" movieName:@"moive.mp4" Identifier:@"id"];
           //[self notficationsLocalPushIOS_10:@"本地推送内容" promptTone:@"voicetiaozhuan.mp3" soundName:@"voicetiaozhuan.mp3" imageName:@"" movieName:@"" Identifier:@"id"];
           [self notficationsLocalPushIOS_10:@"本地推送内容" promptTone:@"voicetiaozhuan.mp3" soundName:@"" imageName:@"1.jpeg" movieName:@"" Identifier:@"id"];
        }
    }];
    
    [notCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        //获取权限
        
    }];
    
}

- (void)notficationsLocalPushIOS_10:(NSString *)body
                         promptTone:(NSString *)promptTone
                          soundName:(NSString *)soundName
                          imageName:(NSString *)imageName
                          movieName:(NSString *)movieName
                         Identifier:(NSString *)identifier
{
    
    UNUserNotificationCenter *notCenter = [UNUserNotificationCenter currentNotificationCenter];

    UNMutableNotificationContent *context = [UNMutableNotificationContent new];
    context.body = body;
    if ([promptTone containsString:@"."]) {
        context.sound = [UNNotificationSound soundNamed:promptTone];
    }
    __block UNNotificationAttachment *imageAtt;
    __block UNNotificationAttachment *movieAtt;
    __block UNNotificationAttachment *soundAtt;
    
    dispatch_queue_t queue = dispatch_queue_create("push", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_barrier_sync(queue, ^{
        /** 图片 */
        if ([imageName containsString:@"."]) {
            [self imageGx_notNotificationAttachmentContent:context attachmentName:imageName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
                imageAtt  = [notificationAtt copy];
            }];
            
        }
        /** 视频 */
        if ([movieName containsString:@"."]) {
            [self gx_notNotificationAttachmentContent:context attachmentName:movieName options:@{@"UNNotificationAttachmentOptionsThumbnailTimeKey":@20} withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
                movieAtt  = [notificationAtt copy];
            }];
            
        }
        /** 音频 */
        if ([soundName containsString:@"."]) {
            [self gx_notNotificationAttachmentContent:context attachmentName:soundName options:nil withCompletion:^(NSError *error, UNNotificationAttachment *notificationAtt) {
                soundAtt  = [notificationAtt copy];
            }];
            
        }
    });
   
    
    dispatch_async(queue, ^{
        NSMutableArray *pushArray = [NSMutableArray array];
        
        if (imageAtt) {
            [pushArray addObject:imageAtt];
        }
        
        if (movieAtt) {
            [pushArray addObject:movieAtt];
        }
        
        if (soundAtt) {
            [pushArray addObject:soundAtt];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            context.attachments = pushArray;
            /** 添加按钮*/
            NSMutableArray *actionMutableArray = [NSMutableArray array];
            UNNotificationAction *bringAction = [UNNotificationAction actionWithIdentifier:@"identifierNeedUnlock" title:@"确定" options:UNNotificationActionOptionAuthenticationRequired];
            UNNotificationAction *cancelAction = [UNNotificationAction actionWithIdentifier:@"identifierRed" title:@"忽略" options:UNNotificationActionOptionDestructive];
            [actionMutableArray addObject:bringAction];
            [actionMutableArray addObject:cancelAction];
            
            if (actionMutableArray.count > 1) {
                UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArray intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
                [notCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
                context.categoryIdentifier  = @"categoryNoOperationAction";
                
            }
            /** 60s后提醒 */
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:YES];
            
            /** 每日12:点提醒 */
            NSDateComponents *components = [[NSDateComponents alloc]init];
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date = [gregorianCalendar dateFromComponents:components];
            NSInteger weekday = [gregorianCalendar component:NSCalendarUnitWeekday fromDate:date];
            NSLog(@"%td", weekday);
            components.weekday = weekday;
            components.hour  = 12;
            //UNCalendarNotificationTrigger *commTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
            /** 位置提醒 */
            CLLocationCoordinate2D cllLoaction = CLLocationCoordinate2DMake(24, 120);
            CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:cllLoaction radius:200 identifier:@"id"];
            region.notifyOnEntry = YES;
            region.notifyOnExit = YES;
            // UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
            UNNotificationRequest *requestNotif = [UNNotificationRequest   requestWithIdentifier:identifier content:context trigger:trigger];
            [notCenter addNotificationRequest:requestNotif withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
        });
      
    });
   
    
    
    
    
}

/**视频 音频   */
- (void)gx_notNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion
{
    NSArray * arr = [attachmentName componentsSeparatedByString:@"."];
    NSError * error;
    NSString * path = [[NSBundle mainBundle]pathForResource:arr[0] ofType:arr[1]];
    
    if (path.length <= 0) {
        completion(error,nil);
    }
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSString stringWithFormat:@"notificationAtt_%@",arr[1]] URL:[NSURL fileURLWithPath:path] options:options error:&error];
    
    if (error) {
        
        NSLog(@"attachment error %@", error);
        
    }
    
    completion(error,attachment);
  
}

/** 图片  */

- (void)imageGx_notNotificationAttachmentContent:(UNMutableNotificationContent *)content attachmentName:(NSString *)attachmentName  options:(NSDictionary *)options withCompletion:(void(^)(NSError * error , UNNotificationAttachment * notificationAtt))completion
{
    //NSArray * arr = [attachmentName componentsSeparatedByString:@"."];
    NSError * error;
    NSString * path = [[NSBundle mainBundle]pathForResource:attachmentName ofType:nil];
    
    if (path.length <= 0) {
        completion(error,nil);
    }
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:[NSString stringWithFormat:@"notificationAtt_%@",path] URL:[NSURL fileURLWithPath:path] options:options error:&error];
    
    if (error) {
        
        NSLog(@"attachment error %@", error);
        
    }
    
    completion(error,attachment);
    
}


#pragma mark UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    // 取消通知
//    [center removeAllDeliveredNotifications];
//    [center removeAllPendingNotificationRequests];
    
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    
    
}

@end
