//
//  TileOverlayView.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//


#import <MapKit/MapKit.h>


@interface TileOverlayView : MKOverlayView {
    CGFloat tileAlpha;
}

@property (nonatomic, assign) CGFloat tileAlpha;

@end
