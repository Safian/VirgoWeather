//
//  LocationManager.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Location Delegate

@protocol LocationManagerDelegate <NSObject>
@optional
-(void)didUpdateLocationLat:(float)latitude Lng:(float)longitude;
-(void)locationDisabled;

@end

#pragma mark - Public Interface

@interface LocationManager : NSObject

@property (nonatomic, weak) id<LocationManagerDelegate> delegate;

+ (instancetype)sharedInstance;

/**
 @brief Force update location. Call back in delegate. 
 */
-(void)updateLocation;


@end
