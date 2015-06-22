//
//  City.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Weather.h"
#import "Location.h"

/** @brief This is a OpenWeather Api helper class  @see http://openweathermap.org/weather-data  */

#pragma mark - Delegate
@class City;
@protocol CityDelegate <NSObject>
@optional
-(void)didUpdateCity:(City*)updatedCity;

@end

@interface City : NSObject

/** @brief The delegete. Methods is optional. */
@property (nonatomic, weak) id<CityDelegate> delegate;


/** @brief OpenWeather Api City ID. */
@property (nonatomic, strong) NSString* cityID;

/** @brief City name. */
@property (nonatomic, strong) NSString* name;

/** @brief City country code. */
@property (nonatomic, strong) NSString* countryCode;

/** @brief City location - lat/long cordinate. */
@property (nonatomic, strong) Location* location;

/** @brief Sunrise time in unix server timestamp. */
@property (nonatomic, assign) NSInteger sunriseTimestamp;

/** @brief Sunset time in unix server timestamp. */
@property (nonatomic, assign) NSInteger sunsetTimestamp;

/** @brief Last update time in unix server timestamp. */
@property (nonatomic, assign) NSInteger lastUpdateTimestamp;

/** @brief Weather data class. */
@property (nonatomic, strong) Weather* weather;

/** @brief Weather icon image name. */
@property (readonly) NSString* weatherIconImageName;


/** 
 @brief City class init with OpenWeather dictionary
 @param openWeatherWindDictionary
        OpenWeather response dictionary
 */
-(id)initWithOpenWeatherDictionary:(NSDictionary*)openWeatherDictionary;

/**
 @brief Formated string with last update time
 @return Formated string with last update time. Format : HH:mm:ss.
*/
-(NSString*)stringLastUpdateTime;

/**
 @brief Get weather icon images with asynchronous block.
 @return @b imageBlock Icon image in UIImage. If UIImage is nil something went wrong.
 */
-(void)imageWithAsyncBlock:(void (^)(UIImage *image))imageBlock;

/** 
 @brief Update data checker.
 */
-(void)updateIfNeed;


@end