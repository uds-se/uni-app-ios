//
//  mensaItem.h
//  SaarlandUniversity
//
//  Created by Andreas Freund on 21.06.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 UdS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MensaItem : NSObject{
    NSString *category;
    NSString *desc;
    NSString *title;
    NSDate *tag;
    NSString *kennzeichnungen;
    NSString *beilagen;
    NSString *preis1;
    NSString *preis2;
    NSString *preis3;
    NSString *color;
}

@property NSString *category;
@property NSString *desc;
@property NSString *title;
@property NSDate *tag;
@property NSString *kennzeichnungen;
@property NSString *beilagen;
@property NSString *preis1;
@property NSString *preis2;
@property NSString *preis3;
@property NSString *color;

@end
