//
//  MapManager.m
//  Qiniu
//
//  Created by 范东 on 16/8/13.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MapManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface MapManager ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation MapManager

+ (MapManager *)manager{
    static MapManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [AMapServices sharedServices].apiKey = @"4e5f9381d765d4ab19398f8324904c24";
}

- (void)startAlwaysUpdatingLocation{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)startUpdatingLocationFinishBlock:(void(^)(NSString *location))finishBlock ErrorBlock:(void(^)(NSError *error))errorBlock{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.locationTimeout = 11;
    self.locationManager.reGeocodeTimeout = 12;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"定位Error:{%ld - %@};", (long)error.code, error.localizedDescription);
            errorBlock(error);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        if (regeocode)
        {
            finishBlock(regeocode.formattedAddress);
        }
    }];
}

- (void)stopUpdatingLocation{
    self.locationManager = nil;
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败:%@",error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"定位信息:{纬度:%f; 经度:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didDetermineState:(AMapLocationRegionState)state forRegion:(AMapLocationRegion *)region{
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager monitoringDidFailForRegion:(AMapLocationRegion *)region withError:(NSError *)error{
    
}

@end
