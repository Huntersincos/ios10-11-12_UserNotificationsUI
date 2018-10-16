UserNotifications
功能:
* Define the types of notifications that your app supports(自定义通知类型)
* Define any custom actions associated with your notification types(自定义和通知相关联的任何操作)
* Schedule local notifications for delivery(本地推送)
* Process already delivered notifications(通知进程)
* Respond to user-selected actions(交互)

 trigger:
 
 1 UNTimeIntervalNotificationTrigger:一段时间出发
 
  UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:YES];
 
  UNNotificationRequest *requestNotif = [UNNotificationRequest   requestWithIdentifier:identifier content:context trigger:trigger];
  [notCenter addNotificationRequest:requestNotif withCompletionHandler:^(NSError * _Nullable error) {
 
 }];
 
 2 UNCalendarNotificationTrigger:设置规定的时间点提醒
 NSDateComponents *components = [[NSDateComponents alloc]init];
 NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDate *date = [gregorianCalendar dateFromComponents:components];
 NSInteger weekday = [gregorianCalendar component:NSCalendarUnitWeekday fromDate:date];
 components.weekday = weekday;
 components.hour  = 12;
 UNCalendarNotificationTrigger *commTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
 UNNotificationRequest *requestNotif = [UNNotificationRequest   requestWithIdentifier:identifier content:context trigger:commTrigger];
 [notCenter addNotificationRequest:requestNotif withCompletionHandler:^(NSError * _Nullable error) {
 
 }];
 
 3 UNLocationNotificationTrigger:位置通知提醒
 CLLocationCoordinate2D cllLoaction =
 CLLocationCoordinate2DMake(24, 120);
 CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:cllLoaction radius:200 identifier:@"id"];
 region.notifyOnEntry = YES;
 region.notifyOnExit = YES;
 UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
 
 
