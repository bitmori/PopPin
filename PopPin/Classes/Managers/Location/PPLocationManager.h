//
//  PPLocationManager.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PPLocationManager : NSObject <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocation *currentLocation;

+(id)initializeLocationManager;

#pragma mark -
#pragma mark Location Methods

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

@end
