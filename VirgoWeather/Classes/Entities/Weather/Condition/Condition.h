//
//  Condition.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This is a OpenWeather Api helper class  @see http://openweathermap.org/weather-data  */

@interface Condition : NSObject

/** Weather condition id */
@property (nonatomic, assign) NSInteger conditionID;

/** Weather condition description */
@property (nonatomic, strong) NSString *descriptionString;

/** Weather icon id string. */
@property (nonatomic, strong) NSString *iconName;

/** OpenWeather group of weather parameters (Rain, Snow, Extreme etc.) */
@property (nonatomic, strong) NSString *groupString;

/** Condition class init with OpenWeather dictionary 'weather' key array item object
 @param openWeatherWindDictionary
        OpenWeather dictionary 'weather' key array item object
 */
-(id)initWithOpenWeatherWeatherItemDictionary:(NSDictionary*)openWeatherWeatherItemDictionary;

@end