//
//  City.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "City.h"
#import "NSDate+Timeformater.h"

@implementation City

#pragma mark - Init Method

-(id)initWithOpenWeatherDictionary:(NSDictionary*)openWeatherDictionary
{
    if (self = [self init])
    {
        [self parseDataWithOpenWeatherDictionary:openWeatherDictionary];
    }
    return self;
}

#pragma mark - Data Parser

- (void)parseDataWithOpenWeatherDictionary:(NSDictionary *)openWeatherDictionary
{
    _cityID = openWeatherDictionary[@"id"];
    _name = openWeatherDictionary[@"name"];
    _countryCode = openWeatherDictionary[@"sys"][@"country"];
    _location = [[Location alloc] initWithLatitudeString:openWeatherDictionary[@"coord"][@"lat"]
                                         LongitudeString:openWeatherDictionary[@"coord"][@"lon"]];
    _sunriseTimestamp = [openWeatherDictionary[@"sys"][@"sunrise"] integerValue];
    _sunsetTimestamp = [openWeatherDictionary[@"sys"][@"sunset"] integerValue];
    _lastUpdateTimestamp = [openWeatherDictionary[@"dt"] integerValue];
    _weather = [[Weather alloc] initWithOpenWeatherDictionary:openWeatherDictionary];
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.cityID forKey:@"cityID"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.countryCode forKey:@"countryCode"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:@(self.sunriseTimestamp) forKey:@"sunriseTimestamp"];
    [encoder encodeObject:@(self.sunsetTimestamp) forKey:@"sunsetTimestamp"];
    [encoder encodeObject:@(self.lastUpdateTimestamp) forKey:@"lastUpdateTimestamp"];
    [encoder encodeObject:self.weather forKey:@"weather"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.cityID = [decoder decodeObjectForKey:@"cityID"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.countryCode = [decoder decodeObjectForKey:@"countryCode"];
        self.location = [decoder decodeObjectForKey:@"location"];
        self.sunriseTimestamp = [[decoder decodeObjectForKey:@"sunriseTimestamp"] integerValue];
        self.sunsetTimestamp = [[decoder decodeObjectForKey:@"sunsetTimestamp"] integerValue];
        self.lastUpdateTimestamp = [[decoder decodeObjectForKey:@"lastUpdateTimestamp"] integerValue];
        self.weather = [decoder decodeObjectForKey:@"weather"];
    }
    return self;
}

#pragma mark - Helper Methods

-(NSString *)weatherIconImageName
{
    Condition *condition = self.weather.conditions.firstObject;
    return condition ? condition.iconName : nil;
}

-(NSString*)stringLastUpdateTime
{
    return [NSDate timeStringWithServerTimestamp:self.lastUpdateTimestamp];
}

-(void)imageWithAsyncBlock:(void (^)(UIImage *image))imageBlock
{
    if (self.weatherIconImageName)
    {
        [OpenWeatherManager.sharedInstance loadIconImageWithName:self.weatherIconImageName
                                                      completion:^(UIImage *image,NSError *error)
        {
            if (image && imageBlock) imageBlock(image);
        }];
    }
}

-(void)updateIfNeed
{
    NSTimeInterval nsti = [[NSDate date] timeIntervalSince1970];
    // Check last update data time if need updated self data from the backend
    if ((long)nsti > (self.lastUpdateTimestamp+1200)) {
        [OpenWeatherManager.sharedInstance getWeatherWithCityID:self.cityID
                                                     completion:^(NSDictionary *data,NSError *error)
         {
             if (data) {
                 [self parseDataWithOpenWeatherDictionary:data];
                 self.lastUpdateTimestamp = nsti;
                 if ([self.delegate respondsToSelector:@selector(didUpdateCity:)])
                 {
                     [self.delegate didUpdateCity:self];
                 }
             }
         }];
    }
}

@end
