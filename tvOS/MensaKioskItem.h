//
//  MensaKioskItem.h
//  Uni Saar
//
//  Created by Daniel on 27/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MensaKioskItem : NSObject {

    NSString* category;
    NSString* food;
    NSString* price1;
    NSString* price2;
    NSString* price3;
    NSString* high;
}

@property NSString* category;
@property NSString* food;
@property NSString* price1;
@property NSString* price2;
@property NSString* price3;
@property NSString* high;

-(id) initWithFood:(NSString *)aFood category:(NSString *)aCategory price1:(NSString*)aPrice1 price2:(NSString*)aPrice2 price3:(NSString*)aPrice3 high:(NSString*)aColor;

@end
