//
//  ResultStaffSearchViewController.m
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "ResultStaffSearchViewController.h"


@implementation ResultStaffSearchViewController



@synthesize selectedIndexPath,fullURL,searchParam,backgroudnThread;

- (void)viewDidLoad
{
    [super viewDidLoad];
    names = [NSMutableArray new];
    backgroudnThread = [NSOperationQueue new];
    [self refresh];
    [self.noresult setHidden:YES];
    [self.nointernet setHidden:YES];

}
-(void)refresh{
        [self.loadingView setHidden:NO];
        [self.activityIndicator startAnimating];
        NSInvocationOperation *loadTableOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadTable) object:nil];
        [loadTableOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
        [backgroudnThread addOperation:loadTableOperation];
    }




-(void)loadTable{
    
    if ([Reachability hasInternetConnection]) {
        
        
        NSError *error = nil;
        NSString* html = [[NSString stringWithFormat:self.fullURL] stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding];
        NSURL *url_of_string = [NSURL URLWithString:html] ;
        HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:url_of_string error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        names = [NSMutableArray new];
        links = [NSMutableArray new];
 
        
        [self parseData:parser];
        
        if([searchParam isEqualToString:@"Profs"]){
            self.fullURL = [self.fullURL stringByReplacingOccurrencesOfString:@"171" withString:@"166"];
            error = nil;
            html = [[NSString stringWithFormat:self.fullURL] stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding];
            url_of_string = [NSURL URLWithString:html] ;
            
            parser = [[HTMLParser alloc] initWithContentsOfURL:url_of_string error:&error];
            
            if (error) {
                NSLog(@"Error: %@", error);
                return;
            }
            
            [self parseData:parser];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.loadingView setHidden:YES];
            [self.activityIndicator stopAnimating];
            
        });
        
        }
    
    else {
        [self.nointernet setHidden:NO];
        [self.noresult setHidden:YES];
        [self.tableView setHidden:YES];
        [self.loadingView setHidden:YES];
        [self.ergebnislabel setHidden:YES];
         self.nointernet.text = NSLocalizedStringFromTable(@"NoInternet", @"tvosLocalisation", nil);
        
    }
}

-(void)parseData:(HTMLParser *)parser{
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    
    
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
    
    if (names.count == 0){
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView setHidden:YES];
        [self.noresult setHidden:NO];
            
        });
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    // Configure the cell...
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    
    
    return cell;
}


#pragma mark - Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailStaff* detailstaff =  segue.destinationViewController;
    [detailstaff setFullURL: [links objectAtIndex: selectedIndexPath.row]];
}




@end