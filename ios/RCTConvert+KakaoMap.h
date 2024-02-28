//
//  RCTConvert+KakaoMap.h
//  Pods
//
//  Created by caffeine.driven on 2/19/24.
//
#import <React/RCTConvert.h>
#import "camera/CenterPosition.h"
#import "common/Coordinate.h"

#import "label/lodlabel/LodLabel.h"
#import "label/location/CurrentLocationMarkerOption.h"
#import "label/balloon/BalloonLabel.h"
#import "line/RouteLine.h"

@interface RCTConvert (KakaoMapV2ViewManager)

+(CenterPosition*)CenterPosition:(id)json;
+(NSArray<LodLabel *>*)LodLabelArray:(id)json;
+(NSArray<BalloonLabel*>*)BalloonLabelArray:(id)json;
+(NSArray<RouteLine*>*)RouteLineArray:(id)json;
+(CurrentLocationMarkerOption*)CurrentLocationMarkerOption:(id)json;
@end
