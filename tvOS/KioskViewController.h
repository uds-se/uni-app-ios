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
#import "NewsDataSourceAndDelegate.h"

@interface KioskViewController : UIViewController {
    
    __weak IBOutlet UIActivityIndicatorView *AiKiosk;
    __weak IBOutlet UITableView *NewsTableView;
    __weak IBOutlet UILabel *KioskModeTitel;
    
    NewsDataSourceAndDelegate *NewsTable;
    NSInteger interval;
    NSInteger animationSpeed;
    NSUserDefaults *defaults;
}

- (void) showNews1;
- (void) showNews2;
- (void) switchToNextView:(SEL)selector;

@end
