//
//  LocationDetailsViewController.h
//  MyLocations
//
//  Created by penddy on 15/12/4.
//  Copyright © 2015年 penddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CategoryPickerViewController.h"

@interface LocationDetailsViewController : UITableViewController

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) CLPlacemark *placemark;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
