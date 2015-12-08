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
#import "Parser.h"
#import "NewsArticleViewController.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    [AiNewsView startAnimating];
    AiNewsView.hidden = false;
    NewsListView.estimatedRowHeight = 150.0;
    NewsListView.rowHeight = UITableViewAutomaticDimension;
    
    PageCounter = 0;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        //Background Thread
        ArticleElements = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadNews];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [NewsListView reloadData];
            [AiNewsView stopAnimating];
            AiNewsView.hidden = true;
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadNews {
    NSString *PageCount = [NSString stringWithFormat:@"%d",PageCounter];
    NSMutableArray *NewsElements = [Parser parseWithURL:[@"http://www.uni-saarland.de/aktuelles/presse/pms.html?tx_ttnews%5Bpointer%5D=" stringByAppendingString:PageCount] andWithPath:@"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']/p | //div//h1//a/@href"];
    
    for (int i = 0; i < [NewsElements count]; i=i+4) {
        @try {
            NewsArticle *article = [[NewsArticle alloc] initWithTitle:[NewsElements objectAtIndex:i+1] subTitle:[NewsElements objectAtIndex:(i+3)] pubDate:[NewsElements objectAtIndex:i] article:[@"https://www.uni-saarland.de/" stringByAppendingString:[NewsElements objectAtIndex:(i+2)]]];
            [ArticleElements addObject:article];
        }
        @catch (NSException *e) {
            
        }
    }
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


 - (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
 NSIndexPath *nextIndexPath = [context nextFocusedIndexPath];
     if ((nextIndexPath.row == ([ArticleElements count]-1)) && PageCounter < 9) {
         PageCounter = PageCounter + 1;
         [AiNewsView startAnimating];
         AiNewsView.hidden = false;
         
         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
             [self loadNews];
             dispatch_async(dispatch_get_main_queue(), ^(void){
                 [NewsListView reloadData];
                 [AiNewsView stopAnimating];
                 AiNewsView.hidden = true;
             });
         });

     }
  
 }
 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewsArticleSegue"]) {
        NSIndexPath *indexPath = [NewsListView indexPathForSelectedRow];
        NewsArticleViewController *destViewController = segue.destinationViewController;
        destViewController.article = [ArticleElements objectAtIndex:indexPath.row];
    }
}


@end
