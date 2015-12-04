//
//  FirstViewController.m
//  MyLocations
//
//  Created by penddy on 15/12/2.
//  Copyright © 2015年 penddy. All rights reserved.
//

#import "CurrentLocationViewController.h"
#import "LocationDetailsViewController.h"



@interface CurrentLocationViewController ()

@end

@implementation CurrentLocationViewController{
    CLLocationManager *_locationManager;
    CLLocation *_location;
    BOOL _updatingLocation;
    NSError *_lastLocationError;
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
    BOOL _performingReverseGeocoding;
    NSError *_lastGeocodingError;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        _locationManager = [[CLLocationManager alloc]init];
        _geocoder = [[CLGeocoder alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabels];
    
    [self configureGetButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureGetButton{
    
    if(_updatingLocation){
        [self.getButton setTitle:@"停止定位" forState:UIControlStateNormal];
    }else{
        [self.getButton setTitle:@"获取当前所在位置" forState:UIControlStateNormal];
    }
}
- (IBAction)getLocation:(id)sender{

    if(_updatingLocation){
        [self stopLocationManager];
    }else{
        _location = nil;
        _lastLocationError = nil;
        _placemark = nil;
        _lastGeocodingError = nil;
        [self startLocationManager];
    }
    
    [self updateLabels];    
    [self configureGetButton];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"TagLocation"]){
        NSLog(@"Enter segue...");
        UINavigationController *navigationController = segue.destinationViewController;
        LocationDetailsViewController *controller = (LocationDetailsViewController *)navigationController.topViewController;
        controller.coordinate = _location.coordinate;
        controller.placemark = _placemark;
    }
}
-(NSString *)stringFromPlacemark:(CLPlacemark *)thePlacemark{
    
    return [NSString stringWithFormat:@"%@ %@\n%@ %@ %@",thePlacemark.subThoroughfare,thePlacemark.thoroughfare,thePlacemark.locality,thePlacemark.administrativeArea,thePlacemark.postalCode];
}
-(void)updateLabels{
    
    if(_location != nil){
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f",_location.coordinate.latitude];
        self.longtitudeLabel.text= [NSString stringWithFormat:@"%.8f",_location.coordinate.longitude];
        self.tagButton.hidden = NO;
        self.messageLabel.text= @"";
        
        if(_placemark != nil){
            self.addressLabel.text = [self stringFromPlacemark:_placemark];
        }else if(_performingReverseGeocoding){
            self.addressLabel.text = @"寻找中...";
        }else if(_lastGeocodingError != nil){
            self.addressLabel.text = @"出错了";
        }else{
            self.addressLabel.text = @"啥也没找到";
        }
    }else{
        
        self.latitudeLabel.text = @"";
        self.longtitudeLabel.text = @"";
        self.addressLabel.text = @"";
        self.tagButton.hidden = YES;
        
        NSString *statusMessage;
        if(_lastLocationError != nil){
            
            if([_lastLocationError.domain isEqualToString:kCLErrorDomain] && _lastLocationError.code == kCLErrorDenied){
                statusMessage = @"对不起，用户禁用了定位功能";
            }else{
                statusMessage = @"对不起，获取位置信息错误";
            }
        }else if(![CLLocationManager locationServicesEnabled]){
            statusMessage = @"对不起，用户禁用了定位功能";
        }else if(_updatingLocation){
            statusMessage = @"定位中...";
        }else{
            self.messageLabel.text = @"请触碰按钮开始定位";
        }
        self.messageLabel.text = statusMessage;
    }
}
-(void) startLocationManager{
    
    if([CLLocationManager locationServicesEnabled]){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager startUpdatingLocation];
        _updatingLocation = YES;
        
        [self performSelector:@selector(didTimeOut:) withObject:nil afterDelay:60];
    }
}

-(void) stopLocationManager{
    if(_updatingLocation){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
        [_locationManager stopUpdatingHeading];
        _locationManager.delegate = nil;
        _updatingLocation = NO;
    }
}

-(void)didTimeOut:(id)obj{
    
    NSLog(@"*** oops，超时了");
    
    if(_location == nil){
        [self stopLocationManager];
        _lastLocationError = [NSError errorWithDomain:@"MyLocationErrorDomain" code:1 userInfo:nil];
        [self updateLabels];
        [self configureGetButton];
    }
}
#pragma mark -CLLoctionManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败：%@",error);
    if(error.code == kCLErrorLocationUnknown){
        return;
    }
    [self stopLocationManager];
    _lastLocationError =error;
    
    [self updateLabels];
    [self configureGetButton];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *newLocaltion = [locations lastObject];
    NSLog(@"已更新坐标，当前位置：%@",newLocaltion);
    
    if([newLocaltion.timestamp timeIntervalSinceNow] < -5.0){
        return;
    }
    
    if(newLocaltion.horizontalAccuracy <0){
        return;
    }
    
    CLLocationDistance distance = MAXFLOAT;
    
    if(_location != nil){
        distance = [newLocaltion distanceFromLocation:_location];
    }
    
    if(_location == nil || _location.horizontalAccuracy> newLocaltion.horizontalAccuracy){
        _lastLocationError = nil;
        _location = newLocaltion;
        [self updateLabels];
        
        if(newLocaltion.horizontalAccuracy <= _locationManager.desiredAccuracy){
            NSLog(@"成功完成定位");
            [self stopLocationManager];
            [self configureGetButton];
            
        }
        
        if(distance >0){
            _performingReverseGeocoding = NO;
        }
            
        if(!_performingReverseGeocoding){
            NSLog(@"*** Going to geocode");
            _performingReverseGeocoding = YES;
            
            [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks,NSError *error) {
                
                NSLog(@"*** Found placemarks: %@ ,error: %@",placemarks,error);
                
                _lastGeocodingError = error;
                if(error == nil && [placemarks count] > 0 ){
                    _placemark = [placemarks lastObject];
                }else{
                    _placemark = nil;
                }
                
                _performingReverseGeocoding = NO;
                [self updateLabels];
            }];
        }else if(distance <1.0){
            NSTimeInterval timeInterval = [newLocaltion.timestamp timeIntervalSinceDate:_location.timestamp];
            if(timeInterval > 10){
                NSLog(@"***强制完成!");
                [self stopLocationManager];
                [self updateLabels];
                [self configureGetButton];
            }
        }

    }
    
 }

@end
