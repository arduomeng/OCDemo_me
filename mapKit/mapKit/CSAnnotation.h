//
//  CSAnnotation.h
//  mapKit
//
//  Created by LCS on 16/6/3.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CSAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;


@property (nonatomic, copy, nullable) NSString *icon;

@end
