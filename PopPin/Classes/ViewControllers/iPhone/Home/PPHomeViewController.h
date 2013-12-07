//
//  PPHomeViewController.h
//  PopPin
//
//  Created by Zealous Amoeba on 12/1/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPAbstractViewController.h"

@interface PPHomeViewController : PPAbstractViewController {
    IBOutlet UIButton *facebookButton;
    IBOutlet UIImageView *logoImageView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)loginPushed:(id)sender;

@end
