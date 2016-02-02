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
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    if (pageIndex+1 !=[days_dict count]) {
        self.pageIndex=self.pageIndex+1;
        self.pageControl.currentPage=self.pageIndex;
        //[self.tableView reloadData];
        [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    days_dict = [[NSMutableDictionary alloc] init];
    [self parseFeeds];
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
    NSString *campus_selected = [self.defaults objectForKey:@"campus_selected"];
    //saar hom
    NSURL *mensaFeed = nil;
    if ([campus_selected isEqualToString:@"saar"]) {
    mensaFeed =[NSURL URLWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-saarbruecken.xml"];
    }
    if ([campus_selected isEqualToString:@"hom"]) {
        mensaFeed =[NSURL URLWithString:@"http://studentenwerk.netzindianer.net/_menu/actual/speiseplan-homburg.xml"];
    }
    
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
    NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
    [keysArr sortUsingSelector:@selector(compare:)];
    NSArray* currentDay = [days_dict objectForKey:[keysArr objectAtIndex:self.pageIndex]];
    MensaItem*blub = [currentDay objectAtIndex:indexPath.row];
    NSString *food_details = [blub.title stringByAppendingString:@"\n"];
    cell.Gericht_Art.text = blub.category;
    cell.Gericht_Name.text =[food_details stringByAppendingString:blub.desc];
    cell.Preis1.text = [@"Student: " stringByAppendingString: blub.preis1];
    cell.Preis2.text = [@"Mitarbeiter: " stringByAppendingString: blub.preis2];
    cell.Preis3.text = [@"Besucher: " stringByAppendingString: blub.preis3];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:blub.tag
                                                          dateStyle:NSDateIntervalFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.Tag.text = dateString;
    NSString *col = blub.color;
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
    NSMutableArray* keysArr = days_dict.allKeys.mutableCopy;
    [keysArr sortUsingSelector:@selector(compare:)];
    NSArray* currentDay = [days_dict objectForKey:[keysArr objectAtIndex:self.pageIndex]];
    return [currentDay count];
}

@end
