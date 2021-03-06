//
//  AppDelegate.m
//  iOS-git-osc
//
//  Created by chenhaoxiang on 14-5-4.
//  Copyright (c) 2014年 chenhaoxiang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "UIColor+Util.h"

//#import <UMSocial.h>
//#import "WeiboSDK.h"
//
//#import <UMengSocial/UMSocialQQHandler.h>
//#import <UMengSocial/UMSocialWechatHandler.h>
//#import <UMengSocial/UMSocialSinaSSOHandler.h>
//#import "UMMobClick/MobClick.h"
//#import "UMSocial.h"
//#import "WeiboSDK.h"
//
//#import "UMSocialQQHandler.h"
//#import "UMSocialWechatHandler.h"
////#import "UMSocialSinaSSOHandler.h"
//#import "UMMobClick/MobClick.h"

#import "OSCShareManager.h"

#define UMENG_APPKEY        @"5423cd47fd98c58f04000c52"

static NSString * const SINA_APP_KEY = @"3645105737";
static NSString * const SINA_APP_SECRET = @"3fbd38f46f9a2dd0207160c4a8d82149";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.window.rootViewController = [MainViewController new];
	[self.window makeKeyAndVisible];
	
	[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x0a5090)];       //UIColorFromRGB(0x1f1f1f)
	NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
	[[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];               //UIColorFromRGB(0xdadada)
	    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //隐藏分享面板
    OSCShareManager *shareManeger = [OSCShareManager shareManager];
    [shareManeger hiddenShareBoard];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return false;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
	return false;
}
@end
