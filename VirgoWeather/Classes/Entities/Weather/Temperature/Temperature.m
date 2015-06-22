//
//  Temperature.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "Temperature.h"

@implementation Temperature

-(id)initWithOpenWeatherMainDictionary:(NSDictionary*)openWeatherMainDictionary
{
    if (self = [self init]) {
        _actual = [openWeatherMainDictionary[@"temp"]     floatValue];
        _min    = [openWeatherMainDictionary[@"temp_min"] floatValue];
        _max    = [openWeatherMainDictionary[@"temp_max"] floatValue];
    }
    return self;
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.actual) forKey:@"actual"];
    [encoder encodeObject:@(self.min)    forKey:@"min"];
    [encoder encodeObject:@(self.max)    forKey:@"max"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.actual = [[decoder decodeObjectForKey:@"actual"] floatValue];
        self.min    = [[decoder decodeObjectForKey:@"min"]    floatValue];
        self.max    = [[decoder decodeObjectForKey:@"max"]    floatValue];
    }
    return self;
}

#pragma mark - Helpers
#pragma mark Formated String


-(NSString*)stringValueWithCelsius
{
    return [NSString stringWithFormat:@"%.0f°C",self.actual];
}



@end
