//
//  NewsDataSourceAndDelegate.h
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"
#import "NewsArticle.h"

@interface NewsDataSourceAndDelegate : UITableView<UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *NewsTableViewContent;
    NSMutableArray *NewsContent1;
    NSMutableArray *NewsContent2;
}

- (void) loadData;
- (void) setData1;
- (void) setData2;

@end
