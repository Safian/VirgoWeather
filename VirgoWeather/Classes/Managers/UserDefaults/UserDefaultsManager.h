//
//  UserDefaultsManager.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

/** @brief Get cities from userdefaults */
+(NSArray*)cities;

/** 
 @brief Save city array to userdefaults
 @param cityArray
        Array with City objects
 */
+(void)saveCities:(NSArray*)cityArray;

/** 
 @brief Delete cities from userdefaults
 */
+(void)deleteCities;

@end
