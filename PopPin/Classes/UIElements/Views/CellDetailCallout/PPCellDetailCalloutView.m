//
//  PPCellDetailCalloutView.m
//  PopPin
//
//  Created by Zealous Amoeba on 11/13/13.
//  Copyright (c) 2013 Zealous Amoeba. All rights reserved.
//

#import "PPCellDetailCalloutView.h"
#import "PPPinCell.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#define Initial_YOffset 25
#define Detail_YOffset 127
#define List_YOffset 160

@interface PPCellDetailCalloutView() {
@private
    NSArray *selectedPins;
    PPPinModel *selectedPin;
    
    NSArray *tableViewData;
    UIButton *transitionButton;
    
    UIImage *upArrowImage;
    UIImage *downArrowImage;
}

@end

@implementation PPCellDetailCalloutView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self  = [super initWithCoder:aDecoder]) {
        selectedPins = @[];
        
        _pinDetailShown = NO;
        _pinListShown = NO;
        
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-Initial_YOffset, 320, [UIScreen mainScreen].bounds.size.height-List_YOffset)];
        
        upArrowImage = [UIImage imageNamed:@"arrowup.png"];
        downArrowImage = [UIImage imageWithCGImage:upArrowImage.CGImage scale:upArrowImage.scale orientation:UIImageOrientationDown];
    }
    return self;
}

-(void)reset {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewButton.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewButton.bounds;
    maskLayer.path = maskPath.CGPath;
    
    viewButton.layer.mask = maskLayer;
    [viewButton.layer setMasksToBounds:YES];
    [viewButton setClipsToBounds:YES];
}

#pragma mark -
#pragma mark Data Methods

-(void)setSelectedPin:(PPPinModel*)pin {
    selectedPin = pin;
    
    [pinTableView reloadData];
}

-(void)setSelectedPins:(NSArray*)pins {
    selectedPins = pins;
    [pinTableView reloadData];
}

-(void)addSelectedPins:(NSArray*)pins {
    NSMutableArray *newPins = [NSMutableArray arrayWithArray:selectedPins];
    for(NSObject *pin in pins) {
        [newPins addObject:pin];
    }
    selectedPins = [NSArray arrayWithArray:newPins];
}

#pragma mark -
#pragma mark IBAction Methods

-(void)viewTogglePushed:(id)sender {
    if(!selectedPin && [selectedPins count] == 0) return;
    
    if(_pinListShown) [self hide];
    else if(_pinDetailShown) [self showPinList];
    else [self showPinDetail];
}

#pragma mark -
#pragma mark Position Methods

-(void)hide {
    _pinDetailShown = NO;
    _pinListShown = NO;
    
    [viewButton setImage:upArrowImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-Initial_YOffset, 320, [UIScreen mainScreen].bounds.size.height-List_YOffset)];
        
        _partnerMapView.tag = 1;
        [_partnerMapView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-Initial_YOffset+21)];
    }];
}

-(void)showPinDetail {
    _pinDetailShown = YES;
    _pinListShown = NO;
    
    if(!selectedPin) selectedPin = selectedPins[0];
    tableViewData = @[selectedPin];
    [pinTableView reloadData];
    
    [viewButton setImage:upArrowImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-Initial_YOffset-Detail_YOffset, 320, [UIScreen mainScreen].bounds.size.height-List_YOffset)];
       
        _partnerMapView.tag = 1;
        [_partnerMapView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-Initial_YOffset-Detail_YOffset+21)];
    }];
    
    
}

-(void)showPinList {
    _pinListShown = YES;
    _pinDetailShown = NO;
    
    tableViewData = selectedPins;
    [pinTableView reloadData];
    
    [viewButton setImage:downArrowImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, List_YOffset, 320, [UIScreen mainScreen].bounds.size.height-List_YOffset)];

        _partnerMapView.tag = 1;
        [_partnerMapView setFrame:CGRectMake(0, 0, 320, List_YOffset+21)];
    }];
}

#pragma mark -
#pragma mark Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"TableView: %lu cells",[tableViewData count]);
    return [tableViewData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PPPinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapCell" forIndexPath:indexPath];
    [cell setPin:tableViewData[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Pin_Selected object:tableViewData[indexPath.row]];
}

#pragma mark -
#pragma mark Action Methods

-(void)transitionPushed:(id)sender {
    if(_pinDetailShown) [self showPinList];
    else [self showPinDetail];
}

@end
