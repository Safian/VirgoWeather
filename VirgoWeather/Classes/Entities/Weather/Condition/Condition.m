//
//  Condition.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "Condition.h"

@implementation Condition

-(id)initWithOpenWeatherWeatherItemDictionary:(NSDictionary*)openWeatherWeatherItemDictionary
{
    if (self = [self init]) {
        _conditionID = [openWeatherWeatherItemDictionary[@"id"] integerValue];
        _descriptionString = openWeatherWeatherItemDictionary[@"description"];
        _iconName = openWeatherWeatherItemDictionary[@"icon"];
        _groupString = openWeatherWeatherItemDictionary[@"main"];
    }
    return self;
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.conditionID) forKey:@"conditionID"];
    [encoder encodeObject:self.descriptionString forKey:@"descriptionString"];
    [encoder encodeObject:self.iconName forKey:@"iconName"];
    [encoder encodeObject:self.groupString forKey:@"groupString"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.conditionID        = [[decoder decodeObjectForKey:@"conditionID"] integerValue];
        self.descriptionString  =  [decoder decodeObjectForKey:@"descriptionString"];
        self.iconName           =  [decoder decodeObjectForKey:@"iconName"];
        self.groupString        =  [decoder decodeObjectForKey:@"groupString"];
    }
    return self;
}

@end