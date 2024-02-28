//
//  RCTConvert+KakaoMap.m
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/19/24.
//

#import <Foundation/Foundation.h>
#import "RCTConvert+KakaoMap.h"

@implementation RCTConvert (KakaoMapV2ViewManager)

+(CenterPosition*)CenterPosition:(id)json
{
  json = [self NSDictionary:json];
  NSNumber* lat = [json objectForKey:@"latitude"];
  NSNumber* lng = [json objectForKey:@"longitude"];
  NSNumber* zoomLv = [json objectForKey:@"zoomLevel"];
  double latitude = lat != nil ? lat.doubleValue : 0.0;
  double longitude = lng != nil ? lng.doubleValue : 0.0;
  int zoomLevel = zoomLv != nil ? zoomLv.intValue : 17;
  
  return [[CenterPosition alloc] initWithLatitude:latitude longitude:longitude zoomLevel:zoomLevel];
}
+(CurrentLocationMarkerOption*)CurrentLocationMarkerOption:(id)json{
  if (json == nil){
    return nil;
  }
  json = [self NSDictionary:json];
  
  NSNumber* lat = [json objectForKey:@"latitude"];
  NSNumber* lng = [json objectForKey:@"longitude"];
  NSString* markerImage = [json objectForKey:@"markerImage"];
  NSNumber* angle = [json objectForKey:@"angle"];
  NSNumber* rotateMap = [json objectForKey:@"rotateMap"];
  NSNumber* offsetX = [json objectForKey:@"offsetX"];
  NSNumber* offsetY = [json objectForKey:@"offsetY"];
  
  CurrentLocationMarkerOption* option = [[CurrentLocationMarkerOption alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue markerImage:markerImage];
  
  option.angle = angle;
  option.rotateMap = rotateMap;
  option.offsetX = offsetX;
  option.offsetY = offsetY;
  
  return option;
  
}
+(NSArray<BalloonLabel*>*)BalloonLabelArray:(id)json{
  json = [self NSArray:json];
  
  NSMutableArray<BalloonLabel *>* labels = [[NSMutableArray alloc] init];
  
  for (NSDictionary* labelData in json) {
    NSString* idStr = labelData[@"id"];
    NSString* title = labelData[@"title"];
    NSString* activeIcon = labelData[@"activeIcon"];
    NSString* inactiveIcon = labelData[@"inactiveIcon"];
    NSNumber* lat = labelData[@"latitude"];
    NSNumber* lng = labelData[@"longitude"];
    
    BalloonLabel* label = [[BalloonLabel alloc] initWithId:idStr title:title activeIcon:activeIcon inactiveIcon:inactiveIcon latitude:lat longitude:lng];
    [labels addObject:label];
  }
  return labels;
}

+(NSArray<LodLabel *>*)LodLabelArray:(id)json
{
  json = [self NSArray:json];
  NSMutableArray<LodLabel *>* lodLabels = [[NSMutableArray alloc] init];
  
  for (NSDictionary* labelData in json) {
    NSArray<NSString*>* textsData = labelData[@"texts"];
    
    NSArray<NSDictionary*>* stylesData = labelData[@"styles"];
    NSMutableArray<LabelStyle*>* styles = [[NSMutableArray<LabelStyle*> alloc] init];
    for (NSDictionary* styleData in stylesData) {
      [styles addObject:[self convertStyle:styleData]];
    }
    
    NSNumber* lat = labelData[@"latitude"];
    NSNumber* lng = labelData[@"longitude"];
    NSNumber* click = labelData[@"clickable"];
    NSString* idStr = labelData[@"id"];
    LodLabel* label = [[LodLabel alloc] initWithId:idStr
                                            styles:styles
                                         clickable:click.boolValue
                                             texts:textsData
                                          latitude:lat.doubleValue
                                         longitude:lng.doubleValue
    ];
    [lodLabels addObject:label];
  }
  
  return lodLabels;
}
+(LabelStyle*)convertStyle:(NSDictionary*)data {
  NSString* icon = [data objectForKey:@"icon"];
  NSDictionary* anchorPointDict = [data objectForKey:@"anchorPoint"];
  NSNumber* zoomLevel = [data objectForKey:@"zoomLevel"];
  NSArray* textStylesArray = [data objectForKey:@"textStyles"];
  
  NSNumber* x = anchorPointDict[@"x"];
  NSNumber* y = anchorPointDict[@"y"];
  
  AnchorPoints* anchorPoint = [[AnchorPoints alloc] initWithX:x.doubleValue y:y.doubleValue];
  
  NSMutableArray<TextStyleProp*>* textStyles = [[NSMutableArray alloc] init];
  if (textStylesArray != nil){
    for (NSDictionary* textStyleDict in textStylesArray) {
      [textStyles addObject:[self convertTextStyle:textStyleDict]];
    }
  }
  
  return [[LabelStyle alloc] initWithIcon:icon anchorPoint:anchorPoint zoomLevel:[zoomLevel intValue] textStyles:textStyles];
}

+(TextStyleProp*)convertTextStyle:(NSDictionary*)data {
  NSString* fontColor = [data objectForKey:@"fontColor"];
  NSNumber* fontSize = [data objectForKey:@"fontSize"];
  NSString* strokeColor = [data objectForKey:@"strokeColor"];
  NSNumber* strokeThickness = [data objectForKey:@"strokeThickness"];
  NSNumber* charSpace = [data objectForKey:@"charSpace"];
  NSNumber* lineSpace = [data objectForKey:@"lineSpace"];
  NSNumber* aspectRatio = [data objectForKey:@"aspectRatio"];
  
  TextStyleProp* textStyle = [[TextStyleProp alloc] init];
  
  [textStyle setFontColor:fontColor];
  [textStyle setFontSize:fontSize];
  [textStyle setStrokeColor:strokeColor];
  [textStyle setStrokeThickness:strokeThickness];
  [textStyle setCharSpace:charSpace];
  [textStyle setLineSpace:lineSpace];
  [textStyle setAspectRatio:aspectRatio];
  
  return textStyle;
}


+(NSArray<RouteLine*>*)RouteLineArray:(id)json{
  json = [self NSArray:json];
  NSMutableArray<RouteLine *>* lines = [[NSMutableArray alloc] init];
  
  for (NSDictionary* lineData in json) {
    NSString* idStr = lineData[@"id"];
    NSArray* segData = lineData[@"segments"];
    NSArray<RouteLineSegment*>* segments = [self convertLineSegments:segData];
    RouteLine* line = [[RouteLine alloc] initWithId:idStr segments:segments];
    [lines addObject:line];
  }
  
  return lines;
}

+(NSArray<RouteLineSegment*>*)convertLineSegments:(NSArray*)data {
  NSMutableArray<RouteLineSegment *>* segments = [[NSMutableArray alloc] init];
  
  if(data == nil){
    return segments;
  }
  
  for (NSDictionary* coordinateData in data) {
    NSArray* coordinatesData = coordinateData[@"coordinates"];
    NSNumber* lineWidth = coordinateData[@"lineWidth"];
    NSString* lineColor = coordinateData[@"lineColor"];
    NSNumber* strokeWidth = coordinateData[@"strokeWidth"];
    NSString* strokeColor = coordinateData[@"strokeColor"];
    
    NSArray<Coordinate*>* coordinates = [self convertCoordinates:coordinatesData];
    
    RouteLineSegment* segment = [[RouteLineSegment alloc]
                                 initWithCoordinates:coordinates
                                 lineWidth:lineWidth
                                 lineColor:lineColor
                                 strokeWidth:strokeWidth
                                 strokeColor:strokeColor];
    [segments addObject:segment];
  }
  
  return segments;
}

+(NSArray<Coordinate*>*)convertCoordinates:(NSArray*)data {
  NSMutableArray<Coordinate *>* coordinates = [[NSMutableArray alloc] init];
  
  if(data == nil){
    return coordinates;
  }
  
  for (NSDictionary* coordinateData in data) {
    NSNumber* latitude = coordinateData[@"latitude"];
    NSNumber* longitude = coordinateData[@"longitude"];
    
    Coordinate* coordinate = [[Coordinate alloc] initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
    [coordinates addObject:coordinate];
  }
  
  return coordinates;
}

@end
