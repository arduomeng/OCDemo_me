//
//  MTDealAnnotation.h
//  63-美团HD
//
//  Created by LCS on 15/12/8.
//  Copyright (c) 2015年 Mac OS X. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MTDealAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property(nonatomic, copy) NSString *icon;

@end
