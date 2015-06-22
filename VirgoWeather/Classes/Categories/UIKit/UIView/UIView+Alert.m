//
//  UIView+Alert.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "UIView+Alert.h"

@implementation UIView (Alert)

-(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message
{
    [[[UIAlertView alloc]initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil]
     show];
}

@end