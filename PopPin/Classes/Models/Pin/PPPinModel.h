//
//  PPPinModel.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@interface PPPinModel : NSObject
@property(nonatomic, strong) NSString *fbid;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSDate *pinDate;

@property(nonatomic, strong) NSArray *pushes;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;

@property(nonatomic, strong) PFObject *source;

-(id)initWithObject:(PFObject*)object;

@end
