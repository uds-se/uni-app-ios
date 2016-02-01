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
#import "EventsDataSourceAndDelegate.h"
#import "MensaDataSourceAndDelegate.h"
#import "NewsSource.h"
#import "Reachability.h"

@interface KioskViewController : UIViewController {
    
    __weak IBOutlet UIActivityIndicatorView *AiKiosk;
    __weak IBOutlet UITableView *EventsTableView;
    __weak IBOutlet UILabel *KioskModeTitel;
    __weak IBOutlet UITextView *NewsTextView;
    __weak IBOutlet UITableView *MensaTableView;
    __weak IBOutlet UIImageView *CampusImageView;
    __weak IBOutlet UILabel *NoInternet;
    
    EventsDataSourceAndDelegate *EventsTable;
    MensaDataSourceAndDelegate *MensaTable;
    NewsSource *NewsTextSource;
    NSInteger interval;
    NSInteger animationSpeed;
    NSUserDefaults *defaults;
    NSInteger loopCount;

}

- (void) showNews1;
- (void) showNews2;
- (void) showNews3;
- (void) showEvents1;
- (void) showEvents2;
- (void) showMensa1;
- (void) showMensa2;
- (void) showMensa3;
- (void) showMap;
- (void) checkForRefresh;
- (void) switchToNextView:(SEL)selector;

@end
