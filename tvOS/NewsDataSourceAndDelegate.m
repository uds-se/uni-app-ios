//
//  NewsDataSourceAndDelegate.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "NewsDataSourceAndDelegate.h"

@implementation NewsDataSourceAndDelegate

-(void)loadData {
    
    NewsContent1 = [[NSMutableArray alloc] initWithCapacity:0];
    NewsContent2 = [[NSMutableArray alloc] initWithCapacity:0];
    NewsTableViewContent = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *NewsElements = [Parser parseWithURL:@"http://www.uni-saarland.de/aktuelles/presse/pms.html" andWithPath:@"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']/p | //div//h1//a/@href"];
    
    for (int i = 0; i < ([NewsElements count]/2); i=i+4) {
        @try {
            NewsArticle *article = [[NewsArticle alloc] initWithTitle:[NewsElements objectAtIndex:i+1] subTitle:[NewsElements objectAtIndex:(i+3)] pubDate:[NewsElements objectAtIndex:i] article:[@"https://www.uni-saarland.de/" stringByAppendingString:[NewsElements objectAtIndex:(i+2)]]];
            [NewsContent1 addObject:article];
        }
        @catch (NSException *e) {
        }
    }
    
    for (int i = 20; i < ([NewsElements count]); i=i+4) {
        @try {
            NewsArticle *article = [[NewsArticle alloc] initWithTitle:[NewsElements objectAtIndex:i+1] subTitle:[NewsElements objectAtIndex:(i+3)] pubDate:[NewsElements objectAtIndex:i] article:[@"https://www.uni-saarland.de/" stringByAppendingString:[NewsElements objectAtIndex:(i+2)]]];
            [NewsContent2 addObject:article];
        }
        @catch (NSException *e) {
        }
    }
}

- (void) setData1 {
    NewsTableViewContent = NewsContent1;
}

- (void) setData2 {
    NewsTableViewContent = NewsContent2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NewsTableViewContent count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[NewsTableViewContent objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[NewsTableViewContent objectAtIndex:indexPath.row] pubDate];
    
    return cell;
    
}

@end
