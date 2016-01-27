//
//  NewsDataSourceAndDelegate.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "EventsDataSourceAndDelegate.h"

@implementation EventsDataSourceAndDelegate

-(void)loadData {
    
    EventsContent1 = [[NSMutableArray alloc] initWithCapacity:0];
    EventsContent2 = [[NSMutableArray alloc] initWithCapacity:0];
    EventsTableViewContent = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *EventsElements = [Parser parseWithURL:@"http://www.uni-saarland.de/aktuelles/veranstaltungen/alle-veranstaltungen.html" andWithPath:@"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']/p | //div//h1//a/@href"];
    
    for (int i = 0; i < ([EventsElements count]/2); i=i+4) {
        @try {
            Event *article = [[Event alloc] initWithTitle:[EventsElements objectAtIndex:i+1] subTitle:[EventsElements objectAtIndex:(i+3)] pubDate:[EventsElements objectAtIndex:i] description:[@"https://www.uni-saarland.de/" stringByAppendingString:[EventsElements objectAtIndex:(i+2)]]];
            [EventsContent1 addObject:article];
        }
        @catch (NSException *e) {
        }
    }
    
    
    for (int i = 20; i < ([EventsElements count]); i=i+4) {
        @try {
            Event *article = [[Event alloc] initWithTitle:[EventsElements objectAtIndex:i+1] subTitle:[EventsElements objectAtIndex:(i+3)] pubDate:[EventsElements objectAtIndex:i] description:[@"https://www.uni-saarland.de/" stringByAppendingString:[EventsElements objectAtIndex:(i+2)]]];
            [EventsContent2 addObject:article];
        }
        @catch (NSException *e) {
        }
    }
}

- (void) setData1 {
    EventsTableViewContent = EventsContent1;
}

- (void) setData2 {
    EventsTableViewContent = EventsContent2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [EventsTableViewContent count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[EventsTableViewContent objectAtIndex:indexPath.row] title];
    cell.detailTextLabel.text = [[EventsTableViewContent objectAtIndex:indexPath.row] pubDate];
    
    return cell;
    
}

@end
