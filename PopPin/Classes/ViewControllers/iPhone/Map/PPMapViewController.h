//
//  PPMapViewController.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPAbstractViewController.h"
#import <MapKit/MapKit.h>

@class PPSettingsCalloutView;
@class PPCellDetailCalloutView;
@interface PPMapViewController : PPAbstractViewController <MKMapViewDelegate,UIAlertViewDelegate> {
    IBOutlet MKMapView *poppinMapView;
    
    IBOutlet UIButton *addPinButton;
    IBOutlet PPSettingsCalloutView *settingsCallout;
    IBOutlet PPCellDetailCalloutView *detailCallout;
    
    IBOutlet UIView *frostOne;
    IBOutlet UIView *frostTwo;
    
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)addPinPushed:(id)sender;


@end
