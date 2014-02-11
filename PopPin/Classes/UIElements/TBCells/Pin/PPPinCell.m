//
//  PPPinCell.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPPinCell.h"

#import <Parse/Parse.h>
#import "PPPinModel.h"
#import "PPUserManager.h"

@interface PPPinCell() {
@private
    BOOL loading;
}

@end

@implementation PPPinCell

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        loading = NO;
        
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:Color_PopPinPurple_Highlight];
        [self setSelectedBackgroundView:bgColorView];
    }
    return self;
}

#pragma mark -
#pragma mark Override Methods

-(void)setPin:(PPPinModel *)pin {
    _pin = pin;
    
    if(_pin) {
        [textlabel setFont:[UIFont fontWithName:@"Raleway-Heavy" size:17.0]];
        [usernameLabel setFont:[UIFont fontWithName:@"Raleway-Light" size:22.0]];
        [pushesLabel setFont:[UIFont fontWithName:@"Raleway-Medium" size:17.0]];
        [pushButton.titleLabel setFont:[UIFont fontWithName:@"Raleway-Medium" size:17.0]];
        
        [textlabel setText:[pin text]];
        [usernameLabel setText:[pin username]];
        [pushesLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)[[pin pushes] count]]];
        
        PPUserManager *sharedUser = [PPUserManager initializeUserManager];
        NSString *fbid = [sharedUser userData][@"id"];
        if([[pin pushes] containsObject:fbid]) {
            [pushButton setTitle:@"Pushed" forState:UIControlStateNormal];
            [pushButton setAlpha:0.75f];
        }
        else {
            [pushButton setTitle:@"Push!" forState:UIControlStateNormal];
            [pushButton setAlpha:1.0f];
        }
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [pushButton setBackgroundColor:Color_PopPinGray];
    [pushesLabel setBackgroundColor:Color_PopPinGray];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [pushButton setBackgroundColor:Color_PopPinGray];
    [pushesLabel setBackgroundColor:Color_PopPinGray];
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)pushPushed:(id)sender {
    if(loading) return;
    loading = YES;
    
    PPUserManager *sharedUser = [PPUserManager initializeUserManager];
    NSString *fbid = [sharedUser userData][@"id"];
    if([[_pin pushes] containsObject:fbid]) {
        [pushButton setTitle:@"Push!" forState:UIControlStateNormal];
        [pushButton setAlpha:1.0f];
        
        NSMutableArray *newPins = [NSMutableArray arrayWithArray:[_pin pushes]];
        [newPins removeObject:fbid];
        [_pin setPushes:[NSArray arrayWithArray:newPins]];
    }
    else {
        [pushButton setTitle:@"Pushed" forState:UIControlStateNormal];
        [pushButton setAlpha:0.75f];
        
        NSMutableArray *newPins = [NSMutableArray arrayWithArray:[_pin pushes]];
        [newPins addObject:fbid];
        [_pin setPushes:[NSArray arrayWithArray:newPins]];
    }
    
    PFObject *source = [_pin source];
    [source saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        loading = NO;
        [self setPin:_pin];
    }];
}

@end
