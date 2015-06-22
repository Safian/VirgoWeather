//
//  Weather.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "Weather.h"

@implementation Weather

-(id)initWithOpenWeatherDictionary:(NSDictionary*)openWeatherDictionary
{
    if (self = [self init]) {
        _pressure = [openWeatherDictionary[@"main"][@"pressure"] floatValue];
        _humidity = [openWeatherDictionary[@"main"][@"humidity"] floatValue];
        _seaLevel = [openWeatherDictionary[@"main"][@"sea_level"] floatValue];
        _grndLevel = [openWeatherDictionary[@"main"][@"grnd_level"] floatValue];
        _cloudinessPercent = [openWeatherDictionary[@"main"][@"grnd_level"] floatValue];
        _rainForLast3hours = [openWeatherDictionary[@"rain"][@"3h"] floatValue];
        _snowForLast3hours = [openWeatherDictionary[@"main"][@"grnd_level"] floatValue];
        _temperature = [[Temperature alloc] initWithOpenWeatherMainDictionary:openWeatherDictionary[@"main"]];
        _wind = [[Wind alloc] initWithOpenWeatherWindDictionary:openWeatherDictionary[@"wind"]];
        NSArray *conditionArray = openWeatherDictionary[@"weather"];
        if (conditionArray.count > 0) {
            NSMutableArray *mutableArray = NSMutableArray.new;
            for (int i = 0; i < conditionArray.count; i++) {
                Condition *condition = [[Condition alloc] initWithOpenWeatherWeatherItemDictionary:conditionArray[i]];
                [mutableArray addObject:condition];
            }
            _conditions = mutableArray.copy;
        }
    }
    return self;
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.pressure) forKey:@"pressure"];
    [encoder encodeObject:@(self.humidity) forKey:@"humidity"];
    [encoder encodeObject:@(self.seaLevel) forKey:@"seaLevel"];
    [encoder encodeObject:@(self.grndLevel) forKey:@"grndLevel"];
    [encoder encodeObject:@(self.cloudinessPercent) forKey:@"cloudinessPercent"];
    [encoder encodeObject:@(self.rainForLast3hours) forKey:@"rainForLast3hours"];
    [encoder encodeObject:@(self.snowForLast3hours) forKey:@"snowForLast3hours"];
    [encoder encodeObject:self.temperature forKey:@"temperature"];
    [encoder encodeObject:self.wind forKey:@"wind"];
    [encoder encodeObject:self.conditions forKey:@"conditions"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.pressure           = [[decoder decodeObjectForKey:@"pressure"] floatValue];
        self.humidity           = [[decoder decodeObjectForKey:@"humidity"] floatValue];
        self.seaLevel           = [[decoder decodeObjectForKey:@"seaLevel"] floatValue];
        self.grndLevel          = [[decoder decodeObjectForKey:@"grndLevel"] floatValue];
        self.cloudinessPercent  = [[decoder decodeObjectForKey:@"cloudinessPercent"] floatValue];
        self.rainForLast3hours  = [[decoder decodeObjectForKey:@"rainForLast3hours"] floatValue];
        self.snowForLast3hours  = [[decoder decodeObjectForKey:@"snowForLast3hours"] floatValue];
        self.temperature        =  [decoder decodeObjectForKey:@"temperature"];
        self.wind               =  [decoder decodeObjectForKey:@"wind"];
        self.conditions         =  [decoder decodeObjectForKey:@"conditions"];
    }
    return self;
}


@end
