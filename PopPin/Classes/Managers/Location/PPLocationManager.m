//
//  PPLocationManager.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPLocationManager.h"

@interface PPLocationManager() {
@private
    CLLocationManager *locationManager;
}

@end

static PPLocationManager *sharedLocation = nil;

@implementation PPLocationManager

+(id)initializeLocationManager {
    @synchronized(self) {
        if(sharedLocation == nil)
            sharedLocation = [[PPLocationManager alloc] init];
    }
    return sharedLocation;
}

-(id)init {
    if(self = [super init]) {
        NSLog(@"Create location manager");
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
    }
    return self;
}

#pragma mark -
#pragma mark Location Methods

-(void)startUpdatingLocation {
    NSLog(@"Start location manager");
    [locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation {
    NSLog(@"Stop location manager");
    [locationManager stopUpdatingLocation];
}

#pragma mark -
#pragma mark Location Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if([locations count] > 0) {
        //NSLog(@"Update location manager");
        _currentLocation = [locations lastObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Location_Update object:nil];
    }
}

@end
