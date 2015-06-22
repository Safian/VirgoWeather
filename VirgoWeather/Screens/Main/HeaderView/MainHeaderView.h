//
//  MainHeaderView.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@protocol MainHeaderViewDelegate <NSObject>
@optional
-(void)addNewCity:(City*)city;

@end


@interface MainHeaderView : UIView

@property (nonatomic, weak) id<MainHeaderViewDelegate> delegate;

@end
