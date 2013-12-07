//
//  PPAbstractViewController.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPAbstractViewController.h"
#import "PPUserManager.h"
#import "PPLocationManager.h"

@interface PPAbstractViewController() {
@private
}

@end

@implementation PPAbstractViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    sharedUserManager = [PPUserManager initializeUserManager];
    sharedLocationManager = [PPLocationManager initializeLocationManager];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
