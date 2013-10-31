//
//  NewsArticle.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "NewsArticle.h"

@implementation NewsArticle

@synthesize title,subTitle,pubDate,article;

-(id) initWithTitle:(NSString *)aTitle subTitle:(NSString *) aSubTitle pubDate:(NSString*) aPubDate article:(NSString*) anArticle {
    title = [aTitle copy];
    subTitle = [aSubTitle copy];
    pubDate = [aPubDate copy];
    article = [anArticle copy];
    return self;
}


#define kTitleKey            @"title"
#define kSubtitleKey         @"subTitle"
#define kPubDateKey          @"pubDate"
#define kArticleKey             @"article"


#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: title forKey:kTitleKey];
    [encoder encodeObject: subTitle forKey:kSubtitleKey];
    [encoder encodeObject: pubDate forKey:kPubDateKey];
    [encoder encodeObject: article forKey:kArticleKey];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    title = [decoder decodeObjectForKey:kTitleKey];
    subTitle = [decoder decodeObjectForKey:kSubtitleKey];
    pubDate = [decoder decodeObjectForKey:kPubDateKey];
    article = [decoder decodeObjectForKey:kArticleKey];
    return self;
}


@end
