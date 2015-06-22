//
//  UserDefaultsManager.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "UserDefaultsManager.h"

#define CityArrayData_KEY @"VirgoWeather.CityArray.NSData"

@implementation UserDefaultsManager

+(NSArray*)cities
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CityArrayData_KEY];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(void)saveCities:(NSArray*)cityArray
{
    if (cityArray.count)
    {
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:cityArray];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:dataSave forKey:CityArrayData_KEY];
        [defaults synchronize];
        NSLog(@"NSUserDictionary Saved %ld cities :\n%@\n",cityArray.count,cityArray);
    }
    else
    {
        [self deleteCities];
    }
}

+(void)deleteCities
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:CityArrayData_KEY];
    [defaults synchronize];
}

@end
