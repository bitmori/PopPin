//
//  PPUserManager.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPUserManager.h"

@interface PPUserManager() {
@private
    NSMutableDictionary *friendDict;
}

@end

static PPUserManager *sharedUser = nil;

@implementation PPUserManager

+(id)initializeUserManager {
    @synchronized(self) {
        if(sharedUser == nil)
            sharedUser = [[PPUserManager alloc] init];
    }
    return sharedUser;
}

-(id)init {
    if(self = [super init]) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Override Methods

-(void)setFriends:(NSArray *)friends {
    _friends = friends;
    
    friendDict = [NSMutableDictionary dictionary];
    for(NSDictionary *dict in friends) {
        [friendDict setObject:@"YES" forKey:dict[@"id"]];
    }
}

#pragma mark -
#pragma mark Friend Methods

-(BOOL)isFriend:(NSString*)fbid {
    return friendDict[fbid] != NULL;
}

@end
