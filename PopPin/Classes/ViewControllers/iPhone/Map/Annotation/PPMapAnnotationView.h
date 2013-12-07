//
//  PPMapAnnotationView.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/15/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PPPinModel;
@interface PPMapAnnotationView : NSObject <MKAnnotation>
@property (nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong, readonly) PPPinModel *pinModel;

-(id)initWithPin:(PPPinModel*)model;

@end
