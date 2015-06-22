//
//  NSDate+Timeformater.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "NSDate+Timeformater.h"

@implementation NSDate (Timeformater)

+(NSString*)timeStringWithServerTimestamp:(NSInteger)timestamp
{
    NSTimeInterval _interval=timestamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= NSDateFormatter.new;
    formatter.locale = NSLocale.currentLocale;
    formatter.dateFormat = @"HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end
