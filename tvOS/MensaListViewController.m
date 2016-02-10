//
//  MensaListViewController.m
//  Uni Saar
//
//  Created by Henrik on 18.12.15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MensaListViewController.h"


@interface MensaListViewController ()

@end


@implementation MensaListViewController


@synthesize days_dict, parsingSuccessful, pageIndex;

//decreases page index (highlighted dot moved one dot to the left) and reloads displayed tablview at index pageIndex
- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    if (pageIndex!=0) {
        self.pageIndex=self.pageIndex-1;
        self.pageControl.currentPage=self.pageIndex;
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

//increases page index (highlighted dot moved one dot to the right) and reloads displayed tablview at index pageIndex
- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if (pageIndex+1 !=[days_dict count]) {
        self.pageIndex=self.pageIndex+1;
        self.pageControl.currentPage=self.pageIndex;
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

//get current date
-(double )getTimestampOfTodayAt0am{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    
    return [[calendar dateFromComponents:components] timeIntervalSince1970];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //check internet connection
    if ([Reachability hasInternetConnection]) {
        
        //hide "no internet" label
        self.no_internet.hidden=true;
        
        //initiliaize menu dictionary and user defaults
        self.defaults = [NSUserDefaults standardUserDefaults];
        days_dict = [[NSMutableDictionary alloc] init];
        
        //parse Feeds
        [self parseFeeds];
        
        //checks if days dict is empty
        if (parsingSuccessful==true) {
            
            
            //Set view options for tableview cells
            self.tableview.bounces = YES;
            self.tableview.estimatedRowHeight = 150.0;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
            self.current_date.text = @"";
            
            // NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
            //[keysArr sortUsingSelector:@selector(compare:)];
            self.pageControl = [[UIPageControl alloc] init];
            self.pageControl.frame = CGRectMake(162,1008,1580,100);
            self.pageControl.numberOfPages = [self.sorted_days count];
            self.pageControl.currentPage = 0;
            [self.view addSubview:self.pageControl];
            self.pageControl.backgroundColor = [UIColor lightGrayColor];
        
        } else {
            self.no_internet.hidden=false;
            self.current_date.text = @"";
            self.no_internet.text = NSLocalizedStringFromTable(@"NoContent", @"tvosLocalisation", nil);
        }
    } else {
        self.current_date.text = @"";
        self.no_internet.text = NSLocalizedStringFromTable(@"NoInternet", @"tvosLocalisation", nil);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


-(void)parsingDidEnd:(NSMutableDictionary *)parsedDictionary
{
    //if the parsed dictionary is empty, the parsing failed else parsing is successful and the dict can be sorted
    if ([parsedDictionary count] == 0) {
        parsingSuccessful=false;
        
    } else {
        parsingSuccessful=true;
        //Sort dictionary and delete menus from the past days if there are any.
        NSMutableArray* keysArr = parsedDictionary.allKeys.mutableCopy;
        [keysArr sortUsingSelector:@selector(compare:)];
        NSMutableArray *days = [[NSMutableArray alloc] init];
        double yesterday = [self getTimestampOfTodayAt0am];
        for (int i=0; i<[parsedDictionary count]; i++) {
            MensaItem *item = [parsedDictionary objectForKey:[keysArr objectAtIndex:i]];
            if (yesterday <= [[keysArr objectAtIndex:i] doubleValue]) {
                [days addObject:item];
            }
        }
        self.sorted_days=days;
    }
}

- (void) parseFeeds
{
    // source urls of menus
    NSString *campus_selected = [self.defaults objectForKey:@"campus_selected"];
    NSURL *mensaFeed = nil;
    
    //select url depending on selecetd campus
    if ([campus_selected isEqualToString:@"saar"]) {
    mensaFeed =[NSURL URLWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-saarbruecken.xml"];
    }
    if ([campus_selected isEqualToString:@"hom"]) {
        mensaFeed =[NSURL URLWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-homburg.xml"];
    }
    
    //Parse Menus
    MensaFeedParser *mensaParser = [MensaFeedParser alloc];
    [mensaParser initParser:mensaFeed withDict:days_dict andDelegate:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //create custom cell of type "MensaListCell"
    static NSString *CellIdentifier = @"MensaListCell";
    MensaListTableViewCell *cell = (MensaListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //select Mensa Menu of the day at pageindex
    MensaItem* current_menu = [[self.sorted_days objectAtIndex:pageIndex] objectAtIndex:indexPath.row];
    
    //Format Strings to fit in the Cells
    NSString * food_details = [current_menu.title stringByAppendingString:@"\n"];
    cell.Gericht_Art.text = current_menu.category;
    cell.Gericht_Name.text =[food_details stringByAppendingString:current_menu.desc];
    
    
    //if the price of the menu is not available, the empty string gets replaced by n.A.
    if ([current_menu.preis1 isEqualToString:@""]) {
        cell.Preis1.text = NSLocalizedStringFromTable(@"not Available", @"tvosLocalisation", nil);
    }else {
        cell.Preis1.text = [[NSLocalizedStringFromTable(@"Student", @"tvosLocalisation", nil) stringByAppendingString: current_menu.preis1] stringByAppendingString:@" €"];
    }
    
    if ([current_menu.preis2 isEqualToString:@""]) {
        cell.Preis2.text = NSLocalizedStringFromTable(@"not Available", @"tvosLocalisation", nil);
    }else {
        cell.Preis2.text = [[NSLocalizedStringFromTable(@"Employee", @"tvosLocalisation", nil) stringByAppendingString: current_menu.preis2] stringByAppendingString:@" €"];
    }
    
    if ([current_menu.preis3 isEqualToString:@""]) {
        cell.Preis3.text = NSLocalizedStringFromTable(@"not Available", @"tvosLocalisation", nil);
    }else {
        cell.Preis3.text = [[NSLocalizedStringFromTable(@"Guest", @"tvosLocalisation", nil) stringByAppendingString: current_menu.preis3] stringByAppendingString:@" €"];
    }
 
    //formats the date
    NSString *dateString = [NSDateFormatter localizedStringFromDate:current_menu.tag dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
    self.current_date.text = dateString;
    
    //sets the beautiful color stripe on the left
    NSString *col = current_menu.color;
    if ([col isEqualToString:@"217,38,26"]) {
        cell.colors.image = [UIImage imageNamed:@"red.png"];
    }
    if ([col isEqualToString:@"21,135,207"]) {
        cell.colors.image = [UIImage imageNamed:@"blue.png"];
    }
    if ([col isEqualToString:@"245,204,43"]) {
        cell.colors.image = [UIImage imageNamed:@"yellow.png"];
    }
    if ([col isEqualToString:@"16,107,10"]) {
        cell.colors.image = [UIImage imageNamed:@"green.png"];
    }
    if ([col isEqualToString:@"135,10,194"]) {
        cell.colors.image = [UIImage imageNamed:@"purple.png"];
    }
    if ([col isEqualToString:@"204,235,255"]) {
        cell.colors.image = [UIImage imageNamed:@"light_cyan.png"];
    }
    if ([col isEqualToString:@"204,255,153"]) {
        cell.colors.image = [UIImage imageNamed:@"canary.png"];
    }
    if ([col isEqualToString:@"255,204,102"]) {
        cell.colors.image = [UIImage imageNamed:@"brown.png"];
    }
    if ([col isEqualToString:@"255,255,153"]) {
        cell.colors.image = [UIImage imageNamed:@"ecru.png"];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([days_dict count] == 0) {
        return 0;
    }
    else {
        return [[self.sorted_days objectAtIndex:pageIndex] count];
    }
}

@end
