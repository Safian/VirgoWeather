//
//  VirgoWeatherTests.m
//  VirgoWeatherTests
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UserDefaultsManager.h"
#import "City.h"
#import "OpenWeatherManager.h"

@interface VirgoWeatherTests : XCTestCase

@end

@implementation VirgoWeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadSaveCity {
    
    City *city = City.new;
    city.name = @"test city";
    
    [UserDefaultsManager saveCities:@[city]];
    NSArray *cities = UserDefaultsManager.cities;
    XCTAssertNotNil(cities, @"Cannot save array to userDefaults");
    
    cities = UserDefaultsManager.cities;
    XCTAssertNotNil(cities, @"Cannot load city array from userDefaults");
    
    [UserDefaultsManager deleteCities];
    NSArray *deletedCities = UserDefaultsManager.cities;
    XCTAssertNil(deletedCities, @"Cannot delete city array from userDefaults");
}

- (void)testCitySearch {
    
    __block BOOL waitingForBlock = YES;
    [[OpenWeatherManager sharedInstance] searchCityWithSubString:@"Buda"
                                                      completion:^(NSDictionary *autocompleteData, NSError *error)
     {
         XCTAssertNotNil(autocompleteData, @"City search result is nil");
         XCTAssertNil(error, @"City search result error is not nil");
         NSLog(@"City AutoComplete search test OK\nautocompleteData : %@", autocompleteData);
        waitingForBlock = NO;
    }];
    // blocker loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testCitySearchWithExtremeLongSearchString {
    
    __block BOOL waitingForBlock = YES;
    [[OpenWeatherManager sharedInstance] searchCityWithSubString:@"Budaijoijpjpjmpopijpijpj"
                                                      completion:^(NSDictionary *autocompleteData, NSError *error)
     {
         XCTAssertNotNil(autocompleteData, @"City search result is nil");
         XCTAssertNil(error, @"City search result error is not nil");
         NSLog(@"City AutoComplete search test OK\nautocompleteData : %@", autocompleteData);
         waitingForBlock = NO;
     }];
    // blocker loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testCitySearchWithoutString {
    
    __block BOOL waitingForBlock = YES;
    [[OpenWeatherManager sharedInstance] searchCityWithSubString:nil
                                                      completion:^(NSDictionary *autocompleteData, NSError *error)
     {
         XCTAssertNotNil(autocompleteData, @"City search result is nil");
         XCTAssertNil(error, @"City search result error is not nil");
         NSLog(@"City AutoComplete search test OK\nautocompleteData : %@", autocompleteData);
         waitingForBlock = NO;
     }];
    // blocker loop
    while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
