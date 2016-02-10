//
//  EventsListViewController.h
//  Uni Saar
//
//  Created by SE15 UniC on 25/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventsListTableViewCell.h"
#import "Reachability.h"



@interface EventsListViewController : UIViewController{


int PageCounter;
NSMutableArray *EventElements;

__weak IBOutlet UILabel *NoInternet;
__weak IBOutlet UITableView *EventsListView;
__weak IBOutlet UIActivityIndicatorView *AiEventsView;
__weak IBOutlet UILabel *EventsLabel;


}



- (void) loadEvents;
@end
