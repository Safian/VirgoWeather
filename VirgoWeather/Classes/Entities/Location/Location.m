//
//  Location.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "Location.h"

@interface Location()

/** Location latitude coordinate */
@property (nonatomic, strong) NSString* latitudeString;

/** Location longitude coordinate */
@property (nonatomic, strong) NSString* longitudeString;


@end

@implementation Location

#pragma mark - Init Method

-(id)initWithLatitudeString:(NSString*)latitudeString
            LongitudeString:(NSString*)longitudeString
{
    if (self = [self init]) {
        _latitudeString = latitudeString;
        _longitudeString = longitudeString;
    }
    return self;
}

#pragma mark - Encoder / Decoder for user default save

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.latitudeString  forKey:@"latitudeString"];
    [encoder encodeObject:self.longitudeString forKey:@"longitudeString"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init])
    {
        self.latitudeString  = [decoder decodeObjectForKey:@"latitudeString"];
        self.longitudeString = [decoder decodeObjectForKey:@"longitudeString"];
    }
    return self;
}

#pragma mark - Read only getters

-(float)latitude
{
    return _latitudeString.floatValue;
}

-(float)longitude
{
    return _longitudeString.floatValue;
}

@end
