//
//  MensaListViewController.m
//  Uni Saar
//
//  Created by Henrik on 18.12.15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MensaListViewController.h"
#import "MensaListTableViewCell.h"
#import "Reachability.h"
#import "MensaItem.h"

@interface MensaListViewController ()

@end


@implementation MensaListViewController
@synthesize days_dict, parsingSuccessful, pageIndex;

- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    if (pageIndex!=0) {
        self.pageIndex=self.pageIndex-1;
        //[self.tableView reloadData];
        self.pageControl.currentPage=self.pageIndex;
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if (pageIndex+1 !=[days_dict count]) {
        self.pageIndex=self.pageIndex+1;
        self.pageControl.currentPage=self.pageIndex;
        //[self.tableView reloadData];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    days_dict = [[NSMutableDictionary alloc] init];
    [self parseFeeds];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableview.bounces = YES;
    self.tableview.estimatedRowHeight = 150.0;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.Tag.text = @"None";
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(162,1008,1580,100);
    self.pageControl.numberOfPages = [days_dict count];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    self.pageControl.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
-(void)parsingDidEnd:(NSMutableDictionary *)parsedDictionary
{
    // the new dictionary
    days_dict = parsedDictionary;
    //[self performSelectorOnMainThread:@selector(updateModel) withObject:nil waitUntilDone:NO];
    
    parsingSuccessful = YES;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) parseFeeds
{
    // source urls of menus
    NSURL *mensaFeed =[NSURL URLWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-saarbruecken.xml"];
    MensaFeedParser *mensaParser = [MensaFeedParser alloc];
    @try {
        [mensaParser initParser:mensaFeed withDict:days_dict andDelegate:self];
        parsingSuccessful = YES;
    }
    @catch (NSException *exception) {
        parsingSuccessful = NO;
        NSLog(@"Mensa parser failed");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MensaListCell";
    MensaListTableViewCell *cell = (MensaListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MensaListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //self.mensaitem.desc
    //RSSEntry *entry = [_AllElements objectAtIndex:indexPath.row];
    /*category = @"";
    title = @"";
    desc = @"";
    kennzeichnungen = @"";
    beilagen = @"";
    preis1 = @"";
    preis2 = @"";
    preis3 = @"";
    color = @"";*/
    NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
    [keysArr sortUsingSelector:@selector(compare:)];
    NSArray* currentDay = [days_dict objectForKey:[keysArr objectAtIndex:self.pageIndex]];
    MensaItem*blub = [currentDay objectAtIndex:indexPath.row];
    cell.Gericht_Art.text = blub.category;
    cell.Gericht_Name.text = blub.title;
    cell.Details.text = blub.desc;
    cell.Preise.text = blub.preis1;
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:blub.tag
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    self.Tag.text = dateString;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", articleDateString, entry.Gericht_Art];
    
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
    [keysArr sortUsingSelector:@selector(compare:)];
    NSArray* currentDay = [days_dict objectForKey:[keysArr objectAtIndex:self.pageIndex]];
    return [currentDay count];
}

@end
