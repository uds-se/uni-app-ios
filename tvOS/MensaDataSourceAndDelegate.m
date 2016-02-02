//
//  MensaDataSourceAndDelegate.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "MensaDataSourceAndDelegate.h"


@implementation MensaDataSourceAndDelegate

@synthesize Menu1, Menu2, Menu3;


-(void)loadData {
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *campus_selected = [defaults objectForKey:@"campus_selected"];
    
    if ([campus_selected isEqualToString:@"saar"]) {
        url = @"http://www.studentenwerk-saarland.de/_menu/actual/speiseplan-saarbruecken.xml";
    }
    else {
        url = @"http://www.studentenwerk-saarland.de/_menu/actual/speiseplan-homburg.xml";
    }
    
    NSDate *now = [NSDate date];
    NSString *dayOfWeek = [self getDay];
    if ([@"6" isEqualToString:dayOfWeek]) {
        now = [now dateByAddingTimeInterval:60*60*24*2];
    }
    else if ([@"0" isEqualToString:dayOfWeek]) {
        now = [now dateByAddingTimeInterval:60*60*24*1];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    NSString *day = [[NSNumber numberWithDouble:[[calendar dateFromComponents:components] timeIntervalSince1970]] stringValue];
    
    NSString *xpath = [NSString stringWithFormat:@"//tag[@timestamp='%@']//description | //tag[@timestamp='%@']//category | //tag[@timestamp='%@']//title  | //tag[@timestamp='%@']//preis1  | //tag[@timestamp='%@']//preis2 | //tag[@timestamp='%@']//preis3  | //tag[@timestamp='%@']//color", day, day, day, day, day, day, day];
    
    MensaContent = [Parser parseWithURL:url andWithPath:xpath];
    MensaMenus = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [MensaContent count]; i=i+7) {
        NSString *food = [[MensaContent objectAtIndex:i+1] stringByAppendingString:@" "];
        food = [food stringByAppendingString:[MensaContent objectAtIndex:i+2]];
        [MensaMenus addObject:[[MensaKioskItem alloc] initWithFood:food category:[MensaContent objectAtIndex:i] price1:[[NSLocalizedStringFromTable(@"Student", @"tvosLocalisation", nil) stringByAppendingString:[MensaContent objectAtIndex:i+3]] stringByAppendingString:@" €"] price2:[[NSLocalizedStringFromTable(@"Employee", @"tvosLocalisation", nil) stringByAppendingString:[MensaContent objectAtIndex:i+4]] stringByAppendingString:@" €"] price3:[[NSLocalizedStringFromTable(@"Guest", @"tvosLocalisation", nil) stringByAppendingString:[MensaContent objectAtIndex:i+5]] stringByAppendingString:@" €"] high:[MensaContent objectAtIndex:i+6]]];
    }
    
    
    [self splitMenus];
    
}

- (NSString*) getDay {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"c"];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];

    return dayOfWeek;
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
    
    while (i < 4 && i < [MensaMenus count] ) {
        [Menu1 addObject:[MensaMenus objectAtIndex:i]];
        i++;
    }
    while (i < 9 && i < [MensaMenus count]) {
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
    CustomMensaKioskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.CustomCategory.text = [[CurrentMenus objectAtIndex:indexPath.row] category];
    cell.CustomFood.text = [[CurrentMenus objectAtIndex:indexPath.row] food];
    cell.CustomPrice1.text = [[CurrentMenus objectAtIndex:indexPath.row] price1];
    cell.CustomPrice2.text = [[CurrentMenus objectAtIndex:indexPath.row] price2];
    cell.CustomPrice3.text = [[CurrentMenus objectAtIndex:indexPath.row] price3];
    
    NSString *col = [[CurrentMenus objectAtIndex:indexPath.row] high];
    if ([col isEqualToString:@"217,38,26"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"red.png"];
    }
    if ([col isEqualToString:@"21,135,207"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"blue.png"];
    }
    if ([col isEqualToString:@"245,204,43"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"yellow.png"];
    }
    if ([col isEqualToString:@"16,107,10"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"green.png"];
    }
    if ([col isEqualToString:@"135,10,194"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"purple.png"];
    }
    if ([col isEqualToString:@"204,235,255"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"blue_hom.png"];
    }
    if ([col isEqualToString:@"204,255,153"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"green_hom.png"];
    }
    if ([col isEqualToString:@"255,204,102"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"orange_hom.png"];
    }
    if ([col isEqualToString:@"255,255,153"]) {
        cell.CustomStripe.image = [UIImage imageNamed:@"yellow_hom.png"];
    }
    
    return cell;
    
}


@end
