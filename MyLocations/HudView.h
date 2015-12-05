//
//  HudView.h
//  MyLocations
//
//  Created by penddy on 15/12/5.
//  Copyright © 2015年 penddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

+(instancetype)hudInView:(UIView *)view animated:(BOOL)animated;
@property(nonatomic,strong)NSString *text;

@end
