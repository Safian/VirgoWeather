//
//  UIView+Alert.h
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Alert)

/**
 @brief Pop up message alert view with 'OK' dismiss button.
 @param title
        Popup title string
 @param message
        Popup message string
 */
- (void) showAlertWithTitle:(NSString*)title Message:(NSString*)message;

@end