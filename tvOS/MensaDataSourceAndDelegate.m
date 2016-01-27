//
//  MensaDataSourceAndDelegate.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "MensaDataSourceAndDelegate.h"

@implementation MensaDataSourceAndDelegate

-(void)loadData {
    
/*    MensaContent = [Parser parseWithURL:@"http://www.studentenwerk-saarland.de/de/Essen/Essen-in-Saarbrucken/Speiseplan-aktuell" andWithPath:@"//div[@class='desc']/node()[not(self::div)] | //div[@class='category'] | //div[@class='price']"];*/
    
    
    NSInteger day = [self getDay];
    NSString *day2 = [@(day) stringValue];
    NSString *xpath = [NSString stringWithFormat:@"//tag[%@]//description | //tag[%@]//category | //tag[%@]//title  | //tag[%@]//preis1  | //tag[%@]//preis2 | //tag[%@]//preis3  | //tag[%@]//color", day2,day2,day2,day2,day2,day2,day2];
    MensaContent = [Parser parseWithURL:@"http://www.studentenwerk-saarland.de/_menu/actual/speiseplan-saarbruecken.xml" andWithPath:xpath];
    
    MensaMenus = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [MensaContent count]; i=i+7) {
        NSString *food = [[MensaContent objectAtIndex:i+1] stringByAppendingString:@" "];
        food = [food stringByAppendingString:[MensaContent objectAtIndex:i+2]];
        [MensaMenus addObject:[[MensaKioskItem alloc] initWithFood:food category:[MensaContent objectAtIndex:i] price1:[MensaContent objectAtIndex:i+3] price2:[MensaContent objectAtIndex:i+4] price3:[MensaContent objectAtIndex:i+5] color:[MensaContent objectAtIndex:i+6]]];
    }
    
    
    [self splitMenus];
    
}

- (NSInteger) getDay {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"c"];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];
    
    return ([dayOfWeek integerValue]-1);
}

- (void) setData1 {
    CurrentMenus = Menu1;
}

- (void) setData2 {
    CurrentMenus = Menu2;
}
- (void) setData3 {
    CurrentMenus = Menu3;
}

- (void) splitMenus {
    Menu1 = [[NSMutableArray alloc] initWithCapacity:0];
    Menu2 = [[NSMutableArray alloc] initWithCapacity:0];
    Menu3 = [[NSMutableArray alloc] initWithCapacity:0];
    int i = 0;
    while (i < 5) {
        [Menu1 addObject:[MensaMenus objectAtIndex:i]];
        i++;
    }
    while (i < 10) {
        [Menu2 addObject:[MensaMenus objectAtIndex:i]];
        i++;
    }
    while (i < [MensaMenus count]) {
        [Menu3 addObject:[MensaMenus objectAtIndex:i]];
        i++;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CurrentMenus count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MensaTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[CurrentMenus objectAtIndex:indexPath.row] food];
    cell.detailTextLabel.text = [[CurrentMenus objectAtIndex:indexPath.row] price1];
    
    return cell;
    
}


@end
