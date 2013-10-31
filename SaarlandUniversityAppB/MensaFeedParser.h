//
//  MensaFeedParser.h
//  SaarlandUniversityAppB
//
//  Created by Andreas Freund on 28.06.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MensaItem.h"

@class MensaItem;

@protocol MensaFeedParserDelegate <NSObject>
@required
// This delegate is to allow callbacks to the class that called the RSS Feed.
- (void)parsingDidEnd:(NSMutableDictionary *)parsedDictionary;
@end
@interface MensaFeedParser : NSObject <NSXMLParserDelegate> {
    NSMutableString *currentElementValue;
    MensaItem *item;
    NSMutableArray *items;
    NSMutableDictionary *days_dict;
    double date;
    
    //the delegate which has to be informed that the parsing ended
    id delegate;
}

@property (nonatomic, retain) MensaItem *item;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableDictionary *days_dict;
@property id delegate;

- (void) initParser:(NSURL *)url withDict:(NSMutableDictionary *)days_Dict andDelegate:(id<MensaFeedParserDelegate>)theDelegate;
@end
