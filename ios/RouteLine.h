//
//  RouteLine.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"
// RouteLineSegment
@interface RouteLineSegment : NSObject

@property (nonatomic, strong) NSArray<Coordinate *> *coordinates;
@property (nonatomic, strong, nullable) NSNumber *lineWidth;
@property (nonatomic, strong) NSString *lineColor;
@property (nonatomic, strong, nullable) NSNumber *strokeWidth;
@property (nonatomic, strong, nullable) NSString *strokeColor;

//- (instancetype)initWithCoordinates:(NSArray<Coordinate *> *)coordinates lineWidth:(NSNumber * _Nullable)lineWidth lineColor:(NSString *)lineColor strokeWidth:(NSNumber * _Nullable)strokeWidth strokeColor:(NSString * _Nullable)strokeColor;

@end

// RouteLine
@interface RouteLine : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSArray<RouteLineSegment *> *segments;

//- (instancetype)initWithId:(NSString *)id segments:(NSArray<RouteLineSegment *> *)segments;

@end
