//
//  UserNotifications.h
//  UserNotificationsUIDemo
//
//  Created by wenze on 2018/10/16.
//  Copyright © 2018年 wenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
/**
 UserNotifications
 @author wenze
 **/
@interface UserNotifications : NSObject<UNUserNotificationCenterDelegate>
+(UserNotifications *)shareIninstance;

/**
 UNUserNotificationCenter
 requestAuthor 授权
 @author wenze
 **/
- (void)requestAuthorization;

/**
 @explation:本地推送内容 图片 <= 10M 视频 <= 50M
 @param body 内容
 @param promptTone 提示音
 @param soundName 音频
 @param imageName 图片
 @param  movieName 视频
 @param  identifier 消息标识
 @author wenze
 **/

- (void)notficationsLocalPushIOS_10:(NSString *)body
                         promptTone:(NSString *)promptTone
                          soundName:(NSString *)soundName
                          imageName:(NSString *)imageName
                          movieName:(NSString *)movieName
                         Identifier:(NSString *)identifier;



@end
