//
//  PPPinModel.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPPinModel.h"
#import <Parse/Parse.h>

@implementation PPPinModel

-(id)init {
    if(self = [super init]) {
        _fbid = @"1000000";
        _text = @"Free chips with a drink at Murphy's right now!";
        _username = @"Rob P";
        _pinDate = [NSDate date];
        
        _pushes = @[];
        _longitude = -88.2248157;
        _latitude = 40.1141041;
        _source = NULL;
    }
    return self;
}

-(id)initWithObject:(PFObject*)object {
    if(self = [super init]) {
        _fbid = object[@"FBid"];
        _text = object[@"Text"];
        _username = object[@"Name"];
        _pinDate = object[@"createdAt"];
        
        _pushes = object[@"Pushes"];

        PFGeoPoint *point = object[@"Location"];
        _longitude = [point longitude];
        _latitude = [point latitude];
        
        _source = object;
    }
    return self;
}

@end
