//
//  PPUserManager.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUserManager : NSObject
@property(nonatomic, strong) NSDictionary *userData;
@property(nonatomic, strong) NSArray *friends;

+(id)initializeUserManager;

#pragma mark -
#pragma mark Friend Methods

-(BOOL)isFriend:(NSString*)fbid;

@end
