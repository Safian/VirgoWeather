//
//  Wind.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This is a OpenWeather Api helper class  @see http://openweathermap.org/weather-data  */

@interface Wind : NSObject

/** Wind speed in meter/sec */
@property (nonatomic) float speed;

/** Wind direction in degrees (meteorological) */
@property (nonatomic) float directionDeegrees;

/** Wind gust in meter/sec */
@property (nonatomic) float gust;

/** Wind class init with OpenWeather dictionary 'wind' key object
@param openWeatherWindDictionary
        OpenWeather dictionary 'wind' key object
*/
-(id)initWithOpenWeatherWindDictionary:(NSDictionary*)openWeatherWindDictionary;

@end