//
//  Wind.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "Wind.h"

@implementation Wind

-(id)initWithOpenWeatherWindDictionary:(NSDictionary*)openWeatherWindDictionary
{
    if (self = [self init]) {
        _speed = [openWeatherWindDictionary[@"speed"]           floatValue];
        _directionDeegrees = [openWeatherWindDictionary[@"deg"] floatValue];
        _gust = [openWeatherWindDictionary[@"gust"]             floatValue];
    }
    return self;
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.speed)             forKey:@"speed"];
    [encoder encodeObject:@(self.directionDeegrees) forKey:@"directionDeegrees"];
    [encoder encodeObject:@(self.gust)              forKey:@"gust"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.speed              = [[decoder decodeObjectForKey:@"pressure"]          floatValue];
        self.directionDeegrees  = [[decoder decodeObjectForKey:@"directionDeegrees"] floatValue];
        self.gust               = [[decoder decodeObjectForKey:@"gust"]              floatValue];
    }
    return self;
}


@end
