//
//  PointOfInterest.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 12.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "PointOfInterest.h"

@implementation PointOfInterest

/*
poi.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
poi.subtitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
poi.canShowLeftCallout = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] boolValue];
poi.canShowRightCallout = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] boolValue];
poi.color = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] integerValue];
poi.website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
poi.latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue];
poi.longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue];
poi.ID = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue];
*/

-(void)setUTF8Title:(char *)title{
    if (title) {
        _title = [NSString stringWithUTF8String: title]; ;
    } else {
        _title = @"";
    }
}

-(void)setUTF8Subtitle:(char *)subtitle{
    if (subtitle) {
        _subtitle = [NSString stringWithUTF8String:subtitle];
    } else {
        _subtitle = @"";
    }
}

-(void)setUTF8CanShowLeftCallout:(char *)cslc{
    if (cslc) {
        _canShowLeftCallout = [[NSString stringWithUTF8String:cslc] boolValue];
    } else {
        _canShowLeftCallout = NO;
    }
}

-(void)setUTF8CanShowRightCallout:(char *)csrc{
    if (csrc) {
        _canShowRightCallout =[[NSString stringWithUTF8String:csrc] boolValue];
    } else {
        _canShowRightCallout = NO;
    }
}
-(void)setUTF8Website:(char *)website{
    if (website) {
        _website = [NSString stringWithUTF8String:website];
    } else {
        _website = @"";
    }
}


-(void)setUTF8Color:(char *)myColor{
    int color = [[NSString stringWithUTF8String:myColor] integerValue];
    if (color>=1 && color<=2) {
        _color=color;
    }else {
        _color=0;
    }
}

-(void)setUTF8CategorieID:(char *) catID{
    if (catID) {
        _categorieID = [[NSString stringWithUTF8String:catID] integerValue];
    }
}



-(void)setTitle:(NSString *)title{
    if (title && ![title.uppercaseString isEqualToString:@"(NULL)"]) {
        _title = title;
    } else {
        _title = @"";
    }
}

-(void)setSubtitle:(NSString *)subtitle{
    if (subtitle && ![subtitle.uppercaseString isEqualToString:@"(NULL)"]) {
        _subtitle = subtitle;
    } else {
        _subtitle = @"";
    }
}

-(void)setCanShowLeftCallout:(BOOL)cslc{
    if (cslc) {
        _canShowLeftCallout = YES;
    } else {
        _canShowLeftCallout = NO;
    }
}

-(void)setCanShowRightCallout:(BOOL)csrc{
    if (csrc) {
        _canShowRightCallout = YES;
    } else {
        _canShowRightCallout = NO;
    }
}
-(void)setWebsite:(NSString *)website{
    NSLog(@"%@",website);
    if (website && ![website.uppercaseString isEqualToString:@"(NULL)"]) {
        _website = website;
    } else {
        _website = @"";
    }
}


-(void)setColor:(int)color{
    if (color>=1 && color<=2) {
        _color=color;
    }else {
        _color=0;
    }
}

-(NSComparisonResult) compare:(PointOfInterest*) otherPoi {
    return [self.title compare:otherPoi.title];
}


@end
