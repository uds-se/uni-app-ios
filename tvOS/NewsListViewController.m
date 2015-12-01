//
//  NewsListViewController.m
//  Uni Saar
//
//  Created by Daniel on 01/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsListViewController.h"
#import "TFHpple.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://www.uni-saarland.de/aktuelles/presse/pms.html"];
    NSData  *data      = [NSData dataWithContentsOfURL:url];
    TFHpple *Parser = [TFHpple hppleWithHTMLData:data];
    NSString *QueryString = @"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']//p | //div//h1//a/@href";
    NSArray *Nodes = [Parser searchWithXPathQuery:QueryString];
    
    NSMutableArray *NewsElements = [[NSMutableArray alloc] initWithCapacity:0];
    ArticleElements = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement * elem in Nodes) {
        [NewsElements addObject:[elem content]];
    }
    
    for (int i = 0; i < 40; i=i+4) {
        NewsArticle *article = [[NewsArticle alloc] initWithTitle:[NewsElements objectAtIndex:i+1] subTitle:[NewsElements objectAtIndex:(i+3)] pubDate:[NewsElements objectAtIndex:i] article:[NewsElements objectAtIndex:(i+2)]] ;
        [ArticleElements addObject:article];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ArticleElements count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[ArticleElements objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[ArticleElements objectAtIndex:indexPath.row] pubDate];
    
    
    
    
    
    return cell;
    
}



@end
