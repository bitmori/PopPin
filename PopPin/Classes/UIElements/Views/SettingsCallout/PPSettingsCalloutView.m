//
//  PPSettingsCalloutView.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPSettingsCalloutView.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface PPSettingsCalloutView() {
@private
    UIImage *rightArrowImage;
    UIImage *leftArrowImage;
}

@end

@implementation PPSettingsCalloutView

-(id)init {
    if(self = [super init]) {
        _shown = NO;
    }
    
    return self;
}


#pragma mark -
#pragma mark Position Methods

-(void)reset {
    _shown = NO;
    
    [filterSegmentedControl setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Raleway-Light" size:14.0]} forState:UIControlStateNormal];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    [self.layer setMasksToBounds:YES];
    [self setClipsToBounds:YES];
    
    rightArrowImage = [UIImage imageNamed:@"arrowright.png"];
    leftArrowImage = [UIImage imageWithCGImage:rightArrowImage.CGImage scale:rightArrowImage.scale orientation:UIImageOrientationDown];
    
    [viewButton setImage:rightArrowImage forState:UIControlStateNormal];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewTogglePushed:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft];
    [viewButton addGestureRecognizer:swipe];
    
    [viewButton setBounds:UIEdgeInsetsInsetRect(viewButton.bounds, UIEdgeInsetsMake(5, 5, 5, 5))];
    [self setFrame:CGRectMake(-self.frame.size.width+20, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

-(void)hide {
    _shown = NO;
    
    [viewButton setImage:rightArrowImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(-self.frame.size.width+20, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }];
}

-(void)show {
    _shown = YES;
    
    [viewButton setImage:leftArrowImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }];
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)logoutPushed:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [action showInView:[_parentViewController view]];
}

-(IBAction)viewTogglePushed:(id)sender {
    if(_shown) [self hide];
    else [self show];
}

-(IBAction)filterSelected:(id)sender {
    NSString *filter = @"friends";
    if(filterSegmentedControl.selectedSegmentIndex == 0) filter = @"everyone";
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Settings_Filter object:filter];
}

#pragma mark -
#pragma mark Action Sheet Methods

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([actionSheet cancelButtonIndex] != buttonIndex) {
        [PFUser logOut];
        [_parentViewController.navigationController popViewControllerAnimated:YES];
    }
}

@end
