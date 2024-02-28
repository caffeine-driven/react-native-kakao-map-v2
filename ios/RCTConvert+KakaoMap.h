//
//  RCTConvert+KakaoMap.h
//  Pods
//
//  Created by caffeine.driven on 2/19/24.
//
#import <React/RCTConvert.h>
#import "react_native_kakao_map_v2-Swift.h"

@class CenterPosition;
@class LodLabel;
@class LabelStyle;
@class AnchorPoints;
@class TextStyleProp;

@interface RCTConvert (KakaoMapV2ViewManager)

+(CenterPosition*)CenterPosition:(id)json;
+(NSArray<LodLabel *>*)LodLabelArray:(id)json;
+(NSArray<BalloonLabel*>*)BalloonLabelArray:(id)json;
+(NSArray<RouteLine*>*)RouteLineArray:(id)json;
+(CurrentLocationMarkerOption*)CurrentLocationMarkerOption:(id)json;
@end
