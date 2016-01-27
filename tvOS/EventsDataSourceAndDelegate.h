//
//  NewsDataSourceAndDelegate.h
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"
#import "Event.h"

@interface EventsDataSourceAndDelegate : UITableView<UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *EventsTableViewContent;
    NSMutableArray *EventsContent1;
    NSMutableArray *EventsContent2;
}

- (void) loadData;
- (void) setData1;
- (void) setData2;

@end
