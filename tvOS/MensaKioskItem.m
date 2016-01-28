//
//  MensaKioskItem.m
//  Uni Saar
//
//  Created by Daniel on 27/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "MensaKioskItem.h"

@implementation MensaKioskItem

@synthesize food, category, price1, price2, price3, high;

-(id) initWithFood:(NSString *)aFood category:(NSString *)aCategory price1:(NSString*)aPrice1 price2:(NSString*)aPrice2 price3:(NSString*)aPrice3 high:(NSString*)aColors {
    food = [aFood copy];
    category = [aCategory copy];
    price1 = [aPrice1 copy];
    price2 = [aPrice2 copy];
    price3 = [aPrice3 copy];
    high = [aColors copy];
    return self;
}

@end
