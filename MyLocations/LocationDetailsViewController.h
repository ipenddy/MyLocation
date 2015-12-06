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

extern NSString *const ManagedObjectContextSaveDidFailNotification;
#define FATAL_CORE_DATA_ERROR(__error__)\
NSLog(@"***Fatal error in %s:%d\n%@\n%@",\
__FILE__,__LINE__,error,[error userInfo]);\
[[NSNotificationCenter defaultCenter]postNotificationName:\
ManagedObjectContextSaveDidFailNotification object:error];

@interface LocationDetailsViewController : UITableViewController

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) CLPlacemark *placemark;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
