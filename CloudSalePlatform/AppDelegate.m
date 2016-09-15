//
//  AppDelegate.m
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Globals.h"
#import "ViewController.h"
#import "BSEngine.h"
#import "BSClient.h"
#import "User.h"
#import "ImageProgressQueue.h"
#import "JSON.h"
#import <AVFoundation/AVFoundation.h>
#import "LocationManager.h"
#import "KWAlertView.h"
#import "BMapKit.h"
#import "UMSocial.h"
#import "APService.h"
#import "ApplyViewController.h"
#import <AlipaySDK/AlipaySDK.h>



static SystemSoundID soundDidRecMsg;
static SystemSoundID soundDidSendMsg;
static SystemSoundID soundDidRecNotify;

@interface AppDelegate()<BMKGeneralDelegate,IChatManagerDelegate> {
    NSMutableArray  * rootConArr;
    BMKMapManager   * _mapManager;
}
@property (nonatomic, strong) NSMutableArray * controllerArr;
@property (nonatomic, strong) ViewController * viewController;
@end

@implementation AppDelegate
@synthesize viewController, controllerArr;

+ (AppDelegate*)instance {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc {
    Release(rootConArr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeAudios];
    // Setup Baidu Map
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"nHGaaNPEIidmfNHWK33hviAg" generalDelegate:self];
    if (!ret) {
        DLog(@"manager start failed!");
    }
    
    // init Globa
    [Globals initializeGlobals];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    application.applicationIconBadgeNumber = 0;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 初始化友盟分享模块
    [UMSocialData setAppKey:UMShareKey];
    [UMSocialConfig showAllPlatform:YES];
    
    //环信配置
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"cloudvast123#yundan" apnsCertName:@"platform"];
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"platform"]];
    [self registerRemoteNotification];
    
    //激光推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}
- (void)registerRemoteNotification{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
         }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return  [UMSocialSnsService handleOpenURL:url];
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    
    //    if (application.applicationState != UIApplicationStateActive) {
    //        //处理消息通知。
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveRemoteNotificationFromCloud" object:userInfo];
    //    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = @"添加你为好友";
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    [[ApplyViewController shareController] addNewApply:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveBuddyRequest" object:nil];
}


#pragma mark - Audios Play

- (void)initializeAudios {
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_msg_rec" ofType:@"caf"]], &soundDidRecMsg);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_msg_send" ofType:@"caf"]], &soundDidSendMsg);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"audio_notify_rec" ofType:@"wav"]], &soundDidRecNotify);
}

- (void)audioPlayRecMsg {
    AudioServicesPlaySystemSound(soundDidRecMsg);
}

- (void)audioPlaySendMsg {
    AudioServicesPlaySystemSound(soundDidSendMsg);
}

- (void)audioPlayRecNotify {
    AudioServicesPlaySystemSound(soundDidRecNotify);
}

#pragma mark - Functions

- (void)setupAPNS {
    UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (enabledTypes > 0) {
        BSClient * clt = [[BSClient alloc] initWithDelegate:nil action:nil];
        [clt setupAPNSDevice];
    }
}

- (void)cancelAPNS {
    UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (enabledTypes > 0) {
        BSClient * clt = [[BSClient alloc] initWithDelegate:nil action:nil];
        [clt cancelAPNSDevice];
    }
}

#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"[Baidu-Map] moulde:online");
    } else {
        NSLog(@"[Baidu-Map] moulde:offline. Reason %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"[Baidu-Map] successfully authorized");
    } else {
        NSLog(@"[Baidu-Map] moulde offline. Reason %d",iError);
    }
}

- (void)signOut {
    NSLog(@"Exit system");
    [APService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
    [[BSEngine currentEngine] signOut];
    
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}


@end
