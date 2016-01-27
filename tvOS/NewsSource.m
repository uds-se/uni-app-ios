//
//  EventsDataSourceAndDelegate.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "NewsSource.h"

@implementation NewsSource

-(void)loadData {
    
    NSMutableArray *NewsElements = [Parser parseWithURL:@"http://www.uni-saarland.de/aktuelles/presse/pms.html" andWithPath:@"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']/p | //div//h1//a/@href"];
    
    ArticleElements = [[NSMutableArray alloc] initWithCapacity:0];
    News1 = [[NSMutableArray alloc] initWithCapacity:0];
    News2 = [[NSMutableArray alloc] initWithCapacity:0];
    News3 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [NewsElements count]; i=i+4) {
        @try {
            NewsArticle *article = [[NewsArticle alloc] initWithTitle:[NewsElements objectAtIndex:i+1] subTitle:[NewsElements objectAtIndex:(i+3)] pubDate:[NewsElements objectAtIndex:i] article:[@"https://www.uni-saarland.de/" stringByAppendingString:[NewsElements objectAtIndex:(i+2)]]];
            [ArticleElements addObject:article];
        }
        @catch (NSException *e) {
            
        }
    }
    
    News = [Parser parseWithURL:[[ArticleElements objectAtIndex:0] article] andWithPath:@"//div[@class='newscontent']/p/b[1]"];
    [News1 addObject:[News objectAtIndex:0]];
    [News1 addObject:[[ArticleElements objectAtIndex:0] title]];
    News = [Parser parseWithURL:[[ArticleElements objectAtIndex:1] article] andWithPath:@"//div[@class='newscontent']/p/b[1]"];
    [News2 addObject:[News objectAtIndex:0]];
    [News2 addObject:[[ArticleElements objectAtIndex:1] title]];
    News = [Parser parseWithURL:[[ArticleElements objectAtIndex:2] article] andWithPath:@"//div[@class='newscontent']/p/b[1]"];
    [News3 addObject:[News objectAtIndex:0]];
    [News3 addObject:[[ArticleElements objectAtIndex:2] title]];
    
}

-(NSMutableArray*)getNews1 {
    return News1;
}

-(NSMutableArray*)getNews2 {
    return News2;
}

-(NSMutableArray*)getNews3 {
    return News3;
}

@end
