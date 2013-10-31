//
//  PointOfInterest.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 12.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointOfInterest : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* subtitle;
@property (nonatomic) BOOL canShowLeftCallout;
@property (nonatomic) BOOL canShowRightCallout;
@property (nonatomic) NSString* website;
@property (nonatomic) int color;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) int ID;
@property (nonatomic) int categorieID;


-(void)setUTF8Title:(char *)title;
-(void)setUTF8Subtitle:(char *)subtitle;
-(void)setUTF8CanShowLeftCallout:(char *)cslc;
-(void)setUTF8CanShowRightCallout:(char *)csrc;
-(void)setUTF8Website:(char *)website;
-(void)setUTF8Color:(char *)myColor;
-(void)setUTF8CategorieID:(char *) catID;

@end
