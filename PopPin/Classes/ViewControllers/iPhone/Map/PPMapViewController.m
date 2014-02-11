//
//  PPMapViewController.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPMapViewController.h"
#import "PPUserManager.h"
#import "PPLocationManager.h"

#import "PPSettingsCalloutView.h"
#import "PPCellDetailCalloutView.h"
#import "PPPinModel.h"

#import "PPMapAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface PPMapViewController() {
@private
    CLLocation *selectedLocation;
    CLLocation *currentLocation;
    int countdown;
    
    BOOL onlyFriends;
    
    BOOL firstUpdate;
    BOOL shouldUpdate;
    BOOL shouldLocate;
    
    BOOL addingPin;
}

@end

@implementation PPMapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [addPinButton.layer setCornerRadius:3.0];
    [addPinButton setClipsToBounds:YES];
    
    [settingsCallout setParentViewController:self];
    countdown = 2;
    
    poppinMapView.tag = 0;
    [detailCallout setPartnerMapView:poppinMapView];
    [detailCallout reset];
    
    [settingsCallout setAlpha:0.85f];
    [addPinButton setAlpha:0.85f];
    
    firstUpdate = YES;
    shouldUpdate = YES;
    shouldLocate = YES;
    currentLocation = NULL;
    onlyFriends = NO;
    selectedLocation = NULL;
    addingPin = NO;
    
    [poppinMapView setRegion:MKCoordinateRegionMake(poppinMapView.region.center, MKCoordinateSpanMake(0.001, 0.001)) animated:YES];
    [poppinMapView setShowsBuildings:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinPushed:)];
    [longPress setNumberOfTouchesRequired:1];
    [longPress setMinimumPressDuration:1.0];
    [poppinMapView addGestureRecognizer:longPress];
    
    [frostOne.layer setCornerRadius:3.0f];
    [frostTwo.layer setCornerRadius:3.0f];
    
    [frostOne setAlpha:0.9];
    [frostTwo setAlpha:0.9];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:Notification_Location_Update object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:Notification_Settings_Filter object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotification:) name:Notification_Pin_Selected object:nil];
    
    [settingsCallout reset];
    [poppinMapView removeAnnotations:poppinMapView.annotations];
    
    currentLocation = [sharedLocationManager currentLocation];
    [self centerMapOnLocation:currentLocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"frost-over"]) {
        [UIView animateWithDuration:0.75 delay:4.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [frostOne setAlpha:0.0f];
            [frostTwo setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [defaults setObject:@"YES" forKey:@"frost-over"];
        }];
    }
    else {
        [frostOne setAlpha:0.0f];
        [frostTwo setAlpha:0.0f];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark Notification Methods

-(void)recievedNotification:(NSNotification*)notification {
    if([[notification name] isEqualToString:Notification_Location_Update]) {
        currentLocation = [sharedLocationManager currentLocation];
        //NSLog(@"Location %f %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        
        if(firstUpdate && currentLocation && currentLocation.coordinate.longitude == [sharedLocationManager currentLocation].coordinate.longitude && currentLocation.coordinate.latitude == [sharedLocationManager currentLocation].coordinate.latitude) {
            firstUpdate = NO;
            [self update];
        }
        
        if(countdown > 0) {
            countdown--;
            [self centerMapOnLocation:currentLocation];
        }
    }
    else if([[notification name] isEqualToString:Notification_Settings_Filter]) {
        NSString *filter = (NSString*)[notification object];
        onlyFriends = [filter isEqualToString:@"friends"];
        
        [self resetAnnotations];
    }
    else if([[notification name] isEqualToString:Notification_Pin_Selected]) {
        PPPinModel *pin = (PPPinModel*)[notification object];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[pin latitude] longitude:[pin longitude]];
        selectedLocation = location;
        NSLog(@"%f %f",location.coordinate.latitude,location.coordinate.longitude);
        
        poppinMapView.tag = 1;
        [self resetAnnotations];
        [poppinMapView setCenterCoordinate:location.coordinate animated:YES];
    }
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)addPinPushed:(id)sender {
    if(addingPin) return;
    addingPin = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Pin" message:@"Enter a message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pin!", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}
     
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    addingPin = NO;
    
    if([[alertView textFieldAtIndex:0].text isEqualToString:@""] && buttonIndex == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid!" message:@"You cannot have a blank message" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    } else if (buttonIndex == 0) {
        return;
    }
    
    NSLog(@"Add pin!: %@",[sharedUserManager userData]);
    
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    coordinate.latitude += 0.0001;
    coordinate.longitude += 0.0001;
    
    PFObject *pin = [PFObject objectWithClassName:@"Pin"];
    NSString *fbid = [sharedUserManager userData][@"id"];
    
    pin[@"FBid"] = fbid;
    pin[@"Name"] = [sharedUserManager userData][@"name"];
    pin[@"Text"] = [alertView textFieldAtIndex:0].text;
    pin[@"Pushes"] = @[fbid];
    pin[@"Location"] = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [pin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            PPPinModel *model = [[PPPinModel alloc] initWithObject:pin];
            PPMapAnnotationView *annotation = [[PPMapAnnotationView alloc] initWithPin:model];
            [poppinMapView addAnnotation:annotation];
            [detailCallout addSelectedPins:@[model]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pin Added" message:@"Your new pin has been successfully added" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil];
            [alert show];
            
            [poppinMapView setCenterCoordinate:currentLocation.coordinate animated:YES];
        }
        else {
            [pin saveEventually];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pin Error" message:@"Something went wrong! Your pin was not added to the map and will try to be added later" delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark -
#pragma mark Map Methods

-(void)resetAnnotations {
    NSArray *anns = poppinMapView.annotations;
    [poppinMapView removeAnnotations:anns];
    [poppinMapView addAnnotations:anns];
}

-(void)centerMapOnLocation:(CLLocation*)location {
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, poppinMapView.region.span);
    [poppinMapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([[view.annotation title] isEqualToString:@"Current Location"]) return;
    
    PPMapAnnotationView *pinAnnotation = (PPMapAnnotationView*)view.annotation;
    PPPinModel *model = [pinAnnotation pinModel];
    [detailCallout setSelectedPin:model];
    
    if(![detailCallout pinListShown]) [detailCallout showPinDetail];
    selectedLocation = [[CLLocation alloc] initWithLatitude:[pinAnnotation coordinate].latitude longitude:[pinAnnotation coordinate].longitude];
    [self resetAnnotations];
    
    poppinMapView.tag = 1;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[model latitude] longitude:[model longitude]];
    [poppinMapView setCenterCoordinate:location.coordinate animated:YES];
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {

}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    PPMapAnnotationView *pinAnnotation = (PPMapAnnotationView*)annotation;
    PPPinModel *model = [pinAnnotation pinModel];
    
    int size = 15;
    if([[model pushes] count] > 5) size = 25;
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"poppinAnnotation"];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size),NO,[UIScreen mainScreen].scale);
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[Color_PopPinRed setFill];

	CGRect circleRect = CGRectMake(0,0,size,size);
	CGContextFillEllipseInRect(ctx, circleRect);
    
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    if(onlyFriends && ![sharedUserManager isFriend:[model fbid]]) [annView setAlpha:0.0f];
    else [annView setAlpha:0.75f];
    
    if(pinAnnotation.coordinate.latitude == selectedLocation.coordinate.latitude && pinAnnotation.coordinate.longitude == selectedLocation.coordinate.longitude) {
        [annView setAlpha:1.0f];

        float scale = [UIImage imageNamed:@"selectpin_original.png"].scale;
        if([[model pushes] count] > 5) scale = [UIImage imageNamed:@"selectpin_original.png"].scale * 0.75;
        
        annView.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"selectpin_original.png"].CGImage scale:scale orientation:UIImageOrientationUp];
    }
    else annView.image = retImage;
    
    annView.canShowCallout = NO;
    
    return annView;
}

#pragma mark -
#pragma mark Update Methods

-(void)update {
    if(!shouldUpdate) return;
    shouldUpdate = NO;
    NSLog(@"Performing query update");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Pin"];
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:currentLocation];
    [query whereKey:@"Location" nearGeoPoint:point];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *models = [NSMutableArray array];
            
            for (PFObject *object in objects) {
                PPPinModel *model = [[PPPinModel alloc] initWithObject:object];
                [models addObject:model];
                
                PPMapAnnotationView *annotation = [[PPMapAnnotationView alloc] initWithPin:model];
                [arr addObject:annotation];
            }
            NSLog(@"Updating map, %i models found",[models count]);
            [poppinMapView addAnnotations:arr];
            [detailCallout setSelectedPins:models];
            
        } else NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark -
#pragma mark Status Bar

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
