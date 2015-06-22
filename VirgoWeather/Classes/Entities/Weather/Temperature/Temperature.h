//
//  Temperature.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This is a OpenWeather Api helper class.
    @see http://openweathermap.org/weather-data  */

@interface Temperature : NSObject

/** Actual temperature in celsius */
@property (nonatomic) float actual;

/** Minimum temperature in celsius */
@property (nonatomic) float min;

/** Maximum temperature in celsius */
@property (nonatomic) float max;

/** Temperature class init with OpenWeather dictionary 'main' key object
 @param openWeatherWindDictionary
        OpenWeather dictionary 'main' key object
 */
-(id)initWithOpenWeatherMainDictionary:(NSDictionary*)openWeatherMainDictionary;

/** Temperature in formated string (like : 23°C ) */
-(NSString*)stringValueWithCelsius;

@end