//
//  LocationManager.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 20/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initSingleton];
    });
    
    return sharedInstance;
}

- (instancetype)initSingleton {
    if (self = [super init]) {
        //[self updateLocation];
    }
    return self;
}

-(void)updateLocation
{
    [self.locationManager startUpdatingLocation];
}

-(CLLocationManager *)locationManager
{
    if (!_locationManager) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            if (   CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse
                && CLLocationManager.authorizationStatus != kCLAuthorizationStatusDenied) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    return _locationManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([self.delegate respondsToSelector:@selector(didUpdateLocationLat:Lng:)]) {
        CLLocation* newLocation = locations.firstObject;
       [self.delegate didUpdateLocationLat:newLocation.coordinate.latitude
                                       Lng:newLocation.coordinate.longitude];
    }
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager startUpdatingLocation];
        } else {
            [self disableLocation];
        }
    } else {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            [self.locationManager startUpdatingLocation];
        } else {
            [self disableLocation];
        }
    }
}

-(void)disableLocation
{
    if ([self.delegate respondsToSelector:@selector(locationDisabled)])
    {
        [self.delegate locationDisabled];
    }
}

-(void)setDelegate:(id<LocationManagerDelegate>)delegate
{
    _delegate = delegate;
}

@end
