//
//  LocationDetailsViewController.m
//  MyLocations
//
//  Created by penddy on 15/12/4.
//  Copyright © 2015年 penddy. All rights reserved.
//

#import "LocationDetailsViewController.h"

@interface LocationDetailsViewController ()

@property(nonatomic,weak) IBOutlet UITextView *descriptionTextView;
@property(nonatomic,weak) IBOutlet UILabel *categoryLabel;
@property(nonatomic,weak) IBOutlet UILabel *latitudeLabel;;
@property(nonatomic,weak) IBOutlet UILabel *longitudeLabel;
@property(nonatomic,weak) IBOutlet UILabel *addressLabel;
@property(nonatomic,weak) IBOutlet UILabel *dateLabel;

@end

@implementation LocationDetailsViewController

-(void)closeScreen{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done:(id)sender{
    [self closeScreen];
    
}

-(IBAction)cacel:(id)sender{
    [self closeScreen];
}


- (NSString *)stringFromPlacemark:(CLPlacemark *)placemark{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",placemark.subThoroughfare,placemark.thoroughfare,placemark.locality,placemark.administrativeArea,placemark.postalCode,placemark.country];
}

-(NSString *)formatDate:(NSDate *)theDate{
    
    static NSDateFormatter *formatter = nil;
    
    if(formatter == nil){
        
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return [formatter stringFromDate:theDate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Enter Tag Location View");
    self.descriptionTextView.text = @"";
    self.categoryLabel.text = @"";

    self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f",self.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f",self.coordinate.longitude];
    
    if(self.placemark != nil){

        self.addressLabel.text = [self stringFromPlacemark:self.placemark];
    }else{
        self.addressLabel.text = @"No Address Found";
    }
    self.dateLabel.text = [self formatDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
