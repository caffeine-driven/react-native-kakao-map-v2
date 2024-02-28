//
//  CenterPosition.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/18/24.
//
#import <Foundation/Foundation.h>

@interface CenterPosition : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int zoomLevel;

//- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude zoomLevel:(int)zoomLevel;

@end
