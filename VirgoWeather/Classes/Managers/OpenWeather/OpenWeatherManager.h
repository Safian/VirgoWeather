//
//  OpenWeatherManager.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenWeatherManager : NSObject

+ (instancetype)sharedInstance;

/**
 @brief Get city weather data with OpenWeather city id
 @param cityID
        OpenWeather city id string
 @return @b completionBlock
        Return the city weather data dictionary and error. If error not nil something went wrong.
 */
-(void)getWeatherWithCityID:(NSString*)cityID
                 completion:(void (^)(NSDictionary *weatherData,NSError *error))completionBlock;

/**
 @brief Get location weather data with coordinate - latitude, longitude
 @param latitude
        Geo location coordinate latitude
 @param longitude
        Geo location coordinate longitude
 @return @b completionBlock
        Return the location weather data dictionary and error. If error not nil something went wrong.
 */
-(void)getWeatherWithLatitude:(float)latitude
                    Longitude:(float)longitude
                   completion:(void (^)(NSDictionary *weatherData,NSError *error))completionBlock;
/**
 @brief Backend city search with substring
 @param citySubString
        Text for search
 @return @b completionBlock
        Return the serarch result dictionary and error. If error not nil something went wrong.
 */
-(void)searchCityWithSubString:(NSString*)citySubString
                    completion:(void (^)(NSDictionary *autocompleteData,NSError *error))completionBlock;

/** 
 @brief Download and cache wather icons from server
 @param iconName
        icon image name string
 @return @b completionBlock
        Return the UIImage data and error. If error not nil something went wrong.
 */
-(void)loadIconImageWithName:(NSString*)iconName
                  completion:(void (^)(UIImage *image,NSError *error))completionBlock;


@end
