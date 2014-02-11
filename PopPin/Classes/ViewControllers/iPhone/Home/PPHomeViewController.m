//
//  PPHomeViewController.m
//  PopPin
//
//  Created by Zealous Amoeba on 12/1/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPHomeViewController.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PPUserManager.h"

@interface PPHomeViewController() {
@private
    BOOL first;
    BOOL loading;
}

@end

@implementation PPHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    first = YES;
    loading = NO;
    
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setNeedsStatusBarAppearanceUpdate];
    [PFFacebookUtils initializeFacebook];
    NSLog(@"homeview viewWillAppear");
    if(first) {
        first = NO;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveEaseOut animations:^{
            [logoImageView setCenter:CGPointMake(logoImageView.center.x, logoImageView.center.y-100)];
            [activityIndicator setCenter:CGPointMake(activityIndicator.center.x, activityIndicator.center.y-100)];
        } completion:^(BOOL finished) {}];
    }
}


#pragma mark -
#pragma mark IBAction Methods

-(IBAction)loginPushed:(id)sender {
    if(loading) return;

    loading = YES;
    [activityIndicator startAnimating];
    
    NSArray *permissionsArray = @[@"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            loading = NO;
            [activityIndicator stopAnimating];
            
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else {
            NSLog(@"User with facebook logged in!");
            [self requestForMe];
        }
        NSLog(@"ads");
    }];
}

-(void)requestForMe {
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            [sharedUserManager setUserData:userData];
            [self requestForFriends];
        }
        else {
            loading = NO;
            [activityIndicator stopAnimating];
            NSLog(@"Request for me failed: %@",error);
        }
    }];
}

-(void)requestForFriends {
    FBRequest *request = [FBRequest requestForMyFriends];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *friendData = (NSDictionary *)result;
            [sharedUserManager setFriends:friendData[@"data"]];
            loading = NO;
            [activityIndicator stopAnimating];
            [self performSegueWithIdentifier:Segue_MapView sender:self];
        }
        else {
            loading = NO;
            [activityIndicator stopAnimating];
            NSLog(@"Request for friends failed: %@",error);
        }
    }];
}

#pragma mark -
#pragma mark Status Bar

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
