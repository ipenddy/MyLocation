//
//  FirstViewController.h
//  MyLocations
//
//  Created by penddy on 15/12/2.
//  Copyright © 2015年 penddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocationViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic,weak)IBOutlet UILabel *messageLabel;
@property(nonatomic,weak)IBOutlet UILabel *latitudeLabel;
@property(nonatomic,weak)IBOutlet UILabel *longtitudeLabel;
@property(nonatomic,weak)IBOutlet UILabel *addressLabel;
@property(nonatomic,weak)IBOutlet UIButton *tagButton;
@property(nonatomic,weak)IBOutlet UIButton *getButton;

-(IBAction)getLocation:(id)sender;


@end

