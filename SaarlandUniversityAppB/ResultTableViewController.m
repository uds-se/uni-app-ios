//
//  ResultTableViewController.m
//  SaarlandUniversityAppB
//
//  Created by Jianan Ma on 12-7-13.
//  Copyright (c) 2012年 Universität des Saarlandes. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultTableViewCell.h"

int numberOfResults;


@interface ResultTableViewController ()

@end

@implementation ResultTableViewController

@synthesize selectedIndexPath,fullURL,backgroudnThread;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    names = [NSMutableArray new];
    links = [NSMutableArray new];
    functions = [NSMutableArray new];
    
    backgroudnThread = [NSOperationQueue new];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


    [self refresh];
     
}

//refreshes information asynchronously
-(void)refresh{
    [self.loadingView setHidden:NO];
    [self.activityIndicator startAnimating];
    NSInvocationOperation *loadTableOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadTable) object:nil];
    [loadTableOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [backgroudnThread addOperation:loadTableOperation];
}


//loads the information from the lsf portal. should run in a different thread.
-(void)loadTable{
    if ([Reachability hasInternetConnection]) {
                
        NSError *error = nil;
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.fullURL] encoding:NSUTF8StringEncoding error:NULL];
        
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        HTMLNode *bodyNode = [parser body];
        
        NSArray *spanNodes = [bodyNode findChildTags:@"div"];
        
        names = [NSMutableArray new];
        links = [NSMutableArray new];
        functions = [NSMutableArray new];
        
        for (HTMLNode *spanNode in spanNodes) {
            if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"erg_list_entry"]) {
                
                HTMLNode* detail = [spanNode findChildWithAttribute:@"class" matchingName:@"erg_list_label" allowPartial:YES] ;
                if([[detail contents] isEqualToString:@"Name:"]){
                    HTMLNode *nameNode = [spanNode findChildTag:@"a"];
                    NSString *name = [nameNode contents];
                    NSURL *link = [NSURL URLWithString:[nameNode getAttributeNamed:@"href"]];
                    NSCharacterSet *whiteNewLine = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
                    
                    NSArray *parts = [name componentsSeparatedByCharactersInSet:whiteNewLine];
                    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
                    int length = [filteredArray count];
                    name = [filteredArray objectAtIndex:(length-1)];
                    NSString *firstname = [filteredArray objectAtIndex:(length-2)];
                    
                    firstname = [firstname stringByAppendingFormat:@" "];
                    name = [firstname stringByAppendingString:name];
                    
                    [names addObject:name];
                    [links addObject:link];
                }                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.loadingView setHidden:YES];
            [self.activityIndicator stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        });

        if (names.count <= 0) {
            NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Unfortunately no staff member matches your search criteria",nil)];
            UIAlertView *notfoundAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Staff member not found",nil) message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

            [notfoundAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    } else {
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Bitte überprüfen sie ihre Internetverbindung und versuchen sie es erneut",nil)];
        UIAlertView *reachabilityAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Keine Internetverbindung",nil) message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setHidden:YES];
            [self.activityIndicator stopAnimating];
            [reachabilityAlert show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{

    [self setLoadingView:nil];
    [self setActivityIndicator:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    self.backgroudnThread = nil;
    self.fullURL = nil;
    self.selectedIndexPath = nil;
   
}

-(void) viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadingView setHidden:YES];
    [self.activityIndicator stopAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    static NSString *CellIdentifier = @"resultCell";
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    cell.name.text = [names objectAtIndex:indexPath.row];
    
    
	return cell;
}


#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailTableViewController* detailTableViewCon =  segue.destinationViewController;
    [detailTableViewCon setFullURL: [links objectAtIndex: selectedIndexPath.row]];
}







@end
