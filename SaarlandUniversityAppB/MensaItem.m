//
//  mensaItem.m
//  SaarlandUniversity
//
//  Created by Andreas Freund on 21.06.12.
//  Copyright (c) 2012 UdS. All rights reserved.
//

#import "mensaItem.h"

@implementation MensaItem

@synthesize tag, category, title, desc, kennzeichnungen,beilagen, preis1, preis2, preis3, color;

- (id)init {
    if (self = [super init]) {
        //date since 1st Januar 1970
        //tag = [[NSDate alloc] initWithTimeIntervalSince1970:0]; 
        category = @"";
        title = @"";
        desc = @"";
        kennzeichnungen = @"";
        beilagen = @"";
        preis1 = @"";
        preis2 = @"";
        preis3 = @"";
        color = @"";
    }
    return self;
}

@end
