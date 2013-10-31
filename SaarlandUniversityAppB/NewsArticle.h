//
//  NewsArticle.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsArticle : NSObject{
    NSString* title;
    NSString* subTitle;
    NSString* pubDate;
    NSString* article;
}

@property NSString* title;
@property NSString* subTitle;
@property NSString* pubDate;
@property NSString* article;

-(id) initWithTitle:(NSString *)aTitle subTitle:(NSString *) aSubTitle pubDate:(NSString*) aPubDate article:(NSString*) anArticle;


@end
