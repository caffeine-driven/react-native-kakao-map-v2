#import <React/RCTViewManager.h>
#import "RCTConvert+KakaoMap.h"

@interface RCT_EXTERN_MODULE(KakaoMapV2ViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(centerPosition, CenterPosition)
RCT_EXPORT_VIEW_PROPERTY(rotate, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(tilt, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(lodLabels, NSArray<LodLabel>)
RCT_EXPORT_VIEW_PROPERTY(balloonLabels, NSArray<BalloonLabel>)
RCT_EXPORT_VIEW_PROPERTY(selectedBalloonLabel, NSString)
RCT_EXPORT_VIEW_PROPERTY(routeLines, NSArray<RouteLine>)
RCT_EXPORT_VIEW_PROPERTY(showCurrentLocationMarker, BOOL)
RCT_EXPORT_VIEW_PROPERTY(currentLocationMarkerOption, CurrentLocationMarkerOption)
RCT_EXPORT_VIEW_PROPERTY(onCameraChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onBalloonLabelSelect, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLodLabelSelect, RCTDirectEventBlock)

@end
