//
//  NSDate+Timeformater.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Timeformater)

/**
 @brief Formated integer unix tmestamp to time string :
             format : HH:mm:ss like 12:03:11
 @param timestamp
        Unix timestamp integer value
 */
+(NSString*)timeStringWithServerTimestamp:(NSInteger)timestamp;

@end
