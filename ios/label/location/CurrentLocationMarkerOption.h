//
//  CurrentLocationMarkerOption.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

#import <Foundation/Foundation.h>

// CurrentLocationMarkerOption
@interface CurrentLocationMarkerOption : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *markerImage;
@property (nonatomic, strong, nullable) NSNumber *angle;
@property (nonatomic, strong, nullable) NSNumber *rotateMap;
@property (nonatomic, strong, nullable) NSNumber *offsetX;
@property (nonatomic, strong, nullable) NSNumber *offsetY;

//- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude markerImage:(NSString *)markerImage;

@end
