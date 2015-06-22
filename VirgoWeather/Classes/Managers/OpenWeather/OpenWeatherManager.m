
//
//  OpenWeatherManager.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "OpenWeatherManager.h"

#define OpenWeather_API_KEY         @"b6828c3c8ac8d36c34ed4525c1b50e8a"

#define OpenWeather_CityID_URL      @"http://api.openweathermap.org/data/2.5/weather?id=%@&units=metric"
#define OpenWeather_CitySearch_URL  @"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&units=metric"
#define OpenWeather_Location_URL    @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric"
#define OpenWeather_IconImage_URL   @"http://openweathermap.org/img/w/%@.png"

#define DefaultHeader   @{@"Accept": @"application/json", @"x-api-key": OpenWeather_API_KEY}

@interface OpenWeatherManager ()

@property (strong, nonatomic) NSURLSession *defaultSession;
@property (strong, nonatomic) NSURLSession *searchSession;

@property (strong, nonatomic) NSURLSessionConfiguration *defaultSessionConfig;

@end


@implementation OpenWeatherManager

#pragma mark - Inits -
#pragma mark Singleton init

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{ sharedInstance = [[self alloc] initSingleton]; });
    return sharedInstance;
}

#pragma mark Custom singleton init
- (instancetype)initSingleton {
    if (self = [super init])
    {
        //Singleton init
    }
    return self;
}

#pragma mark - Lazy Load -
#pragma mark Basic Config

-(NSURLSessionConfiguration*)defaultSessionConfig
{
    if (!_defaultSessionConfig) {
        _defaultSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultSessionConfig.HTTPAdditionalHeaders = DefaultHeader;
    }
    return _defaultSessionConfig;
}

#pragma mark Sessions

-(NSURLSession *)defaultSession
{
    if (!_defaultSession) {
        
        _defaultSession = [NSURLSession sessionWithConfiguration:self.defaultSessionConfig
                                                       delegate:nil
                                                  delegateQueue:[NSOperationQueue currentQueue]];
    }
    return _defaultSession;
}


-(NSURLSession *)searchSession
{
    if (!_searchSession) {
        _searchSession = [NSURLSession sessionWithConfiguration:self.defaultSessionConfig
                                                           delegate:nil
                                                      delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _searchSession;
}

#pragma mark - Server Communication -

#pragma mark Get url helpers


- (void)getURL:(NSString *)urlStr
   WithSession:(NSURLSession*)session
    completion:(void (^)(NSDictionary *data,NSError *error))completionBlock
{
   [[session dataTaskWithURL:[NSURL URLWithString:urlStr]
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"Response:%@ %@\n", response, error);
        NSDictionary* dataDictionary;
        if(!error)
        {
            NSError* error;
            dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        }
        if (completionBlock)
        {
            completionBlock(dataDictionary,error);
        }
   }] resume];
}

//Shorthand with default session

- (void)getURL:(NSString *)urlStr completion:(void (^)(NSDictionary *data,NSError *error))completionBlock
{
    [self getURL:urlStr  WithSession:self.defaultSession completion:completionBlock];
}

#pragma mark Get Weather methods

-(void)getWeatherWithCityID:(NSString*)cityID
               completion:(void (^)(NSDictionary *weatherData,NSError *error))completionBlock
{
    NSString * urlStr =[NSString stringWithFormat:OpenWeather_CityID_URL,cityID];
    [self getURL:urlStr completion:completionBlock];
    NSLog(@"GetWeatherWih CityID URL :%@\n", urlStr);
}


-(void)getWeatherWithLatitude:(float)latitude
                    Longitude:(float)longitude
                   completion:(void (^)(NSDictionary *weatherData,NSError *error))completionBlock
{
    NSString * urlStr =[NSString stringWithFormat:OpenWeather_Location_URL,latitude,longitude];
    [self getURL:urlStr completion:completionBlock];
    NSLog(@"GetWeatherWith Location URL :%@\n", urlStr);
}

#pragma mark Search City method

-(void)searchCityWithSubString:(NSString*)citySubString
                    completion:(void (^)(NSDictionary *autocompleteData,NSError *error))completionBlock
{
    [_searchSession invalidateAndCancel];
    _searchSession = nil;
    NSString * urlStr =[NSString stringWithFormat:OpenWeather_CitySearch_URL,citySubString];
    [self getURL:urlStr  WithSession:self.searchSession completion:completionBlock];;
    NSLog(@"Get City with Search String: %@ URL :%@\n", citySubString,urlStr);
}

#pragma mark Download and cache image method

-(void)loadIconImageWithName:(NSString*)iconName completion:(void (^)(UIImage *image,NSError *error))completionBlock
{
    if (!iconName) return;
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
    NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:iconName];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:documentURL]];
    
    if (image) {
        completionBlock(image,nil);
    } else {
        NSString *imageUrl = [NSString stringWithFormat:OpenWeather_IconImage_URL,iconName];
        
        [[self.defaultSession downloadTaskWithURL:[NSURL URLWithString:imageUrl]
                                completionHandler:^(NSURL *imgUrl,
                                                    NSURLResponse *response,
                                                    NSError *error)
          {
              if (imgUrl && completionBlock)
              {
                  UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
                  completionBlock(image,error);
                  [[NSFileManager defaultManager] moveItemAtURL:imgUrl
                                                          toURL:documentURL
                                                          error:nil];
              }
          }] resume];
    }
}

@end
