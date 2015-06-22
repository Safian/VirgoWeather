//
//  CityCell.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CityCell : UITableViewCell

/** @brief The data source class. Set the subviews outlets of the setter method */
@property (nonatomic, strong) City *city;

@end
