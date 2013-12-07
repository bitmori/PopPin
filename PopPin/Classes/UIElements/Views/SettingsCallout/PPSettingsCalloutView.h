//
//  PPSettingsCalloutView.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPSettingsCalloutView : UIView <UIActionSheetDelegate> {
    IBOutlet UISegmentedControl *filterSegmentedControl;
    IBOutlet UIButton *viewButton;
    IBOutlet UIImageView *image;
}
@property(nonatomic, assign, readonly) BOOL shown;
@property(nonatomic, weak) UIViewController *parentViewController;

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)logoutPushed:(id)sender;
-(IBAction)viewTogglePushed:(id)sender;
-(IBAction)filterSelected:(id)sender;

#pragma mark -
#pragma mark Position Methods

-(void)reset;
-(void)hide;
-(void)show;



@end
