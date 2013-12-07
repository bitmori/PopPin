//
//  PPAbstractViewController.h
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPUserManager;
@class PPLocationManager;
@interface PPAbstractViewController : UIViewController {
    PPUserManager *sharedUserManager;
    PPLocationManager *sharedLocationManager;
}

@end
