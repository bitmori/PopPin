//
//  PPMapAnnotationView.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/15/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPMapAnnotationView.h"
#import "PPPinModel.h"

@implementation PPMapAnnotationView

-(id)initWithPin:(PPPinModel*)model {
    if(self = [super init]) {
        _title = @"Pin";
        _pinModel = model;
        _coordinate = CLLocationCoordinate2DMake([model latitude], [model longitude]);
    }
    return self;
}

@end
