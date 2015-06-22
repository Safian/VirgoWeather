//
//  Weather.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenWeatherManager.h"
#import "Temperature.h"
#import "Wind.h"
#import "Condition.h"

/** This is a OpenWeather Api helper class  @see http://openweathermap.org/weather-data  */

@interface Weather : NSObject

/** 
 Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data) in hPa.
 */
@property (nonatomic) float pressure;

/** Humidity in percent (%) */
@property (nonatomic) float humidity;

/** Humidity in percent (%) */
@property (nonatomic) float seaLevel;

/** Humidity in percent (%) */
@property (nonatomic) float grndLevel;

/** Cloudiness in percent (%) */
@property (nonatomic) float cloudinessPercent;

/** Rain precipitation volume for last 3 hours in milimeter */
@property (nonatomic) float rainForLast3hours;

/** Snow precipitation volume for last 3 hours in milimeter */
@property (nonatomic) float snowForLast3hours;

/** Temperature data - actual, min, max in float */
@property (nonatomic, strong) Temperature *temperature;

/** Wind data - speed, direction, gust */
@property (nonatomic, strong) Wind *wind;

/** Array of weather conditions */
@property (nonatomic, strong) NSArray *conditions;

/** Weather class init with OpenWeather dictionary
    @param openWeatherWindDictionary
            OpenWeather dictionary
 */
-(id)initWithOpenWeatherDictionary:(NSDictionary*)openWeatherDictionary;

@end

