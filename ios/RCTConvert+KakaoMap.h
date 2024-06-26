//
//  RCTConvert+KakaoMap.h
//  Pods
//
//  Created by caffeine.driven on 2/19/24.
//
#import <React/RCTConvert.h>
#import "CenterPosition.h"
#import "Coordinate.h"

#import "LodLabel.h"
#import "CurrentLocationMarkerOption.h"
#import "BalloonLabel.h"
#import "RouteLine.h"

@interface RCTConvert (KakaoMapV2ViewManager)

+(CenterPosition*)CenterPosition:(id)json;
+(NSArray<LodLabel *>*)LodLabelArray:(id)json;
+(NSArray<BalloonLabel*>*)BalloonLabelArray:(id)json;
+(NSArray<RouteLine*>*)RouteLineArray:(id)json;
+(CurrentLocationMarkerOption*)CurrentLocationMarkerOption:(id)json;
@end
