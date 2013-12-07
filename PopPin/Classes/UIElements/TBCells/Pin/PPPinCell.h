//
//  PPPinCell.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPinModel;
@interface PPPinCell : UITableViewCell {
    IBOutlet UILabel *textlabel;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UILabel *pushesLabel;
    
    IBOutlet UIButton *pushButton;
}
@property(nonatomic, strong) PPPinModel *pin;

#pragma mark -
#pragma mark IBAction Methods

-(IBAction)pushPushed:(id)sender;

@end
