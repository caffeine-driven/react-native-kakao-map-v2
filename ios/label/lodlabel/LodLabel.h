//
//  LodLabel.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/19/24.
//

#import <Foundation/Foundation.h>

// TextStyleProp
@interface TextStyleProp : NSObject

@property (nonatomic, strong) NSNumber *fontSize;
@property (nonatomic, strong, nullable) NSString *fontColor;
@property (nonatomic, strong, nullable) NSString *strokeColor;
@property (nonatomic, strong, nullable) NSNumber *strokeThickness;
@property (nonatomic, strong, nullable) NSNumber *charSpace;
@property (nonatomic, strong, nullable) NSNumber *lineSpace;
@property (nonatomic, strong, nullable) NSNumber *aspectRatio;

//- (instancetype)init;

@end


// AnchorPoints
@interface AnchorPoints : NSObject

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

//- (instancetype)initWithX:(double)x y:(double)y;

@end

// LabelStyle
@interface LabelStyle : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) AnchorPoints *anchorPoint;
@property (nonatomic, assign) int zoomLevel;
@property (nonatomic, strong) NSArray<TextStyleProp *> *textStyles;

//- (instancetype)initWithIcon:(NSString *)icon anchorPoint:(AnchorPoints *)anchorPoint zoomLevel:(int)zoomLevel textStyles:(NSArray<TextStyleProp *> *)textStyles;

@end



// LodLabel
@interface LodLabel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSArray<LabelStyle *> *styles;
@property (nonatomic, assign) BOOL clickable;
@property (nonatomic, strong) NSArray<NSString *> *texts;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

//- (instancetype)initWithId:(NSString *)id styles:(NSArray<LabelStyle *> *)styles clickable:(BOOL)clickable texts:(NSArray<NSString *> *)texts latitude:(double)latitude longitude:(double)longitude;

@end
