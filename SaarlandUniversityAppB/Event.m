//
//  Event.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 14.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize title,subTitle,pubDate,description;


-(id) initWithTitle:(NSString *)aTitle subTitle:(NSString *) aSubTitle pubDate:(NSString*) aPubDate description:(NSString*) aDescription{
    title = [aTitle copy];
    subTitle = [aSubTitle copy];
    pubDate = [aPubDate copy];
    description = [aDescription copy];
    return self;
}


#define kTitleKey            @"title"
#define kSubtitleKey         @"subTitle"
#define kPubDateKey          @"pubDate"
#define kArticleKey          @"description"


#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: title forKey:kTitleKey];
    [encoder encodeObject: subTitle forKey:kSubtitleKey];
    [encoder encodeObject: pubDate forKey:kPubDateKey];
    [encoder encodeObject: description forKey:kArticleKey];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    title = [decoder decodeObjectForKey:kTitleKey];
    subTitle = [decoder decodeObjectForKey:kSubtitleKey];
    pubDate = [decoder decodeObjectForKey:kPubDateKey];
    description = [decoder decodeObjectForKey:kArticleKey];
    return self;
}



@end
