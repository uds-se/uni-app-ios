//
//  NewsListViewController.h
//  Uni Saar
//
//  Created by Daniel on 01/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#ifndef NewsListViewController_h
#define NewsListViewController_h

#endif /* NewsListViewController_h */

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "Reachability.h"

@interface NewsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    int PageCounter;
    NSMutableArray *ArticleElements;
    __weak IBOutlet UITableView *NewsListView;
    __weak IBOutlet UIActivityIndicatorView *AiNewsView;
    __weak IBOutlet UILabel *NewsLabel;
    __weak IBOutlet UILabel *NoInternet;
}

- (void) loadNews;

@end
