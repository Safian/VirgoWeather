//
//  Location.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

/** Location latitude coordinate */
@property (readonly) float latitude;

/** Location longitude coordinate */
@property (readonly) float longitude;

-(id)initWithLatitudeString:(NSString*)latitudeString
            LongitudeString:(NSString*)longitudeString;

@end
