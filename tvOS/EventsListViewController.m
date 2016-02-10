//
//  EventsListViewController.m
//  Uni Saar
//
//  Created by SE15 UniC on 25/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "EventsListViewController.h"
#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "Parser.h"
#import "EventContentViewController.h"
#import "EventsListTableViewCell.h"


@interface EventsListViewController ()

@end

@implementation EventsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([Reachability hasInternetConnection]) {
        NoInternet.hidden = true;
    }
    else{
    NoInternet.hidden = false;
    NoInternet.text = NSLocalizedStringFromTable(@"NoInternet", @"tvosLocalisation", nil);
    EventsLabel.alpha = 0;
    }
    
    [AiEventsView startAnimating];
    AiEventsView.hidden = false;
    EventsListView.estimatedRowHeight = 150.0;
    EventsListView.rowHeight = UITableViewAutomaticDimension;
    EventsLabel.hidden = true;
    
    PageCounter = 0;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        EventElements = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadEvents];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [EventsListView reloadData];
            [AiEventsView stopAnimating];
            AiEventsView.hidden = true;
            EventsLabel.hidden = false;
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadEvents {
    NSString *PageCount = [NSString stringWithFormat:@"%d",PageCounter];
    NSMutableArray *EventListElements = [Parser parseWithURL:[@"http://www.uni-saarland.de/aktuelles/veranstaltungen/alle-veranstaltungen.html?tx_ttnews%5Bpointer%5D=" stringByAppendingString:PageCount] andWithPath:@"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']/p | //div//h1//a/@href"];
    
    for (int i = 0; i < [EventListElements count]; i=i+4) {
        @try {
            Event *event = [[Event alloc] initWithTitle:[EventListElements objectAtIndex:i+1] subTitle:[EventListElements objectAtIndex:(i+3)] pubDate:[EventListElements objectAtIndex:i] description:[@"https://www.uni-saarland.de/" stringByAppendingString:[EventListElements objectAtIndex:(i+2)]]];
            [EventElements addObject:event];
        }
        @catch (NSException *e) {
            
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [EventElements count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventsListCell";
    EventsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.EventTitleView.text = [[EventElements objectAtIndex:indexPath.row] title];
    cell.EventSubTitleView.text = [[EventElements objectAtIndex:indexPath.row] pubDate];
    [cell setDate: [[EventElements objectAtIndex:indexPath.row] pubDate]];
    [cell setDateImage];
     
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    NSIndexPath *nextIndexPath = [context nextFocusedIndexPath];
    if ((nextIndexPath.row == ([EventElements count]-1)) && PageCounter < 9) {
        PageCounter = PageCounter + 1;
        [AiEventsView startAnimating];
        AiEventsView.hidden = false;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self loadEvents];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [EventsListView reloadData];
                [AiEventsView stopAnimating];
                AiEventsView.hidden = true;
            });
        });
        
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EventContentSegue"]) {
        NSIndexPath *indexPath = [EventsListView indexPathForSelectedRow];
        EventContentViewController *destViewController = segue.destinationViewController;
        destViewController.event = [EventElements objectAtIndex:indexPath.row];
    }
}


@end
