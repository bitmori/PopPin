//
//  PPAppDelegate.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPAppDelegate.h"
#import <Parse/Parse.h>
#import "PPLocationManager.h"

@implementation PPAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:Parse_Application_Id clientKey:Parse_Client_Key];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    PPLocationManager *sharedLocationManager = [PPLocationManager initializeLocationManager];
    [sharedLocationManager startUpdatingLocation];
    
    return YES;
}

#pragma mark -
#pragma mark Activity Methods

-(void)applicationDidEnterBackground:(UIApplication *)application {
    PPLocationManager *sharedLocationManager = [PPLocationManager initializeLocationManager];
    [sharedLocationManager stopUpdatingLocation];
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    PPLocationManager *sharedLocationManager = [PPLocationManager initializeLocationManager];
    [sharedLocationManager startUpdatingLocation];

}

#pragma mark -
#pragma mark URL Methods

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url open");
    return [PFFacebookUtils handleOpenURL:url];
}


@end
