//
//  CafeParser.h
//  SaarlandUniversityAppB
//
//  Created by Andreas Freund on 10.07.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MensaItem.h"

@class MensaItem;

@protocol CafeParserDelegate <NSObject>
@required
// This delegate is to allow callbacks to the class that called the RSS Feed.
- (void)parsingDidEnd:(NSMutableDictionary *)parsedDictionary;
@end
@interface CafeParser : NSObject <NSXMLParserDelegate> {
    NSMutableString *currentElementValue;
    MensaItem *item;
    MensaItem *placeholder;
    NSMutableDictionary *days_dict;
    NSInteger wochentag;
    NSString *weekdayString;
    NSString *category;
    BOOL started;
    BOOL lastday;
    BOOL endParsing;
    BOOL twotimes;
    
    //the delegate which has to be informed that the parsing ended
    id delegate;
}

@property (nonatomic, retain) MensaItem *item;
@property (nonatomic, retain) NSMutableDictionary *days_dict;
@property (nonatomic, retain) NSString *category;
@property id delegate;

- (void) initParser:(NSURL *)url withCategory:(NSString *)menuCategory withDict:(NSMutableDictionary *)dict andDelegate:(id<CafeParserDelegate>)theDelegate;

@end