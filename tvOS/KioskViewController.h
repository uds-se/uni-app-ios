//
//  KioskViewController.h
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "Parser.h"

@interface KioskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    __weak IBOutlet UIActivityIndicatorView *AiKiosk;
    __weak IBOutlet UITableView *NewsTableView;
    NSMutableArray *NewsTableViewContent;
    NSMutableArray *NewsContent1;
    NSMutableArray *NewsContent2;
    
}

- (void) loadNews;
- (void) showNews1;
- (void) showNews2;

@end
