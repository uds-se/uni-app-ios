//
//  Event.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 14.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject {
    NSString* title;
    NSString* subTitle;
    NSString* pubDate;
    NSString* description;
}

@property NSString* title;
@property NSString* subTitle;
@property NSString* pubDate;
@property NSString* description;

-(id) initWithTitle:(NSString *)aTitle subTitle:(NSString *) aSubTitle pubDate:(NSString*) aPubDate description:(NSString*) aDescription;



@end
