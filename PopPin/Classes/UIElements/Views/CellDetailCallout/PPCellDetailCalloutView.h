//
//  PPCellDetailCalloutView.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class PPPinModel;
@interface PPCellDetailCalloutView : UIView <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UIButton *viewButton;
    IBOutlet UITableView *pinTableView;
}
@property(nonatomic, assign, readonly) BOOL pinDetailShown;
@property(nonatomic, assign, readonly) BOOL pinListShown;

//Hack so the map on the parent view adjusts size with this view, terrible design otherwise
@property(nonatomic, assign) MKMapView *partnerMapView;
-(void)reset;

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)viewTogglePushed:(id)sender;

#pragma mark -
#pragma mark Data Methods

-(void)setSelectedPin:(PPPinModel*)pin;
-(void)setSelectedPins:(NSArray*)pins;

-(void)addSelectedPins:(NSArray*)pins;

#pragma mark -
#pragma mark Position Methods

-(void)hide;
-(void)showPinDetail;
-(void)showPinList;

@end
