//
//  BalloonLabel.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//
#import <Foundation/Foundation.h>

// BalloonLabel
@interface BalloonLabel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *activeIcon;
@property (nonatomic, strong) NSString *inactiveIcon;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

//- (instancetype)initWithId:(NSString *)id title:(NSString *)title activeIcon:(NSString *)activeIcon inactiveIcon:(NSString *)inactiveIcon latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end
