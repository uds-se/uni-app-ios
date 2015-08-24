//
//  DetailTableViewController.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 16.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "DetailTableViewController.h"


@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

@synthesize fullURL,parsedInformations,heaerforInformations,name,backgroundThread,selectedBuilding;




- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundThread = [NSOperationQueue new];
    name.text = [NSString stringWithFormat:@""];
    parsedInformations = [[NSMutableArray alloc] init];
    heaerforInformations = [[NSMutableArray alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.loadingView setHidden:NO];
    [self.activityIndicator startAnimating];

    
    NSInvocationOperation *parseOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseInformations) object:nil];
    [parseOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [backgroundThread addOperation:parseOperation];   
}


//parses the detail from a staff member from the lsf portal. should run in backroundthread.
-(void) parseInformations{
    if ([Reachability hasInternetConnection]) {
        
        NSError *error = nil;
        
        
        NSString *html = [NSString stringWithContentsOfURL:fullURL encoding:NSUTF8StringEncoding error:NULL];
        
        
        HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
        
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        HTMLNode *bodyNode = [parser body];
        
        
        NSArray *spanNodes = [bodyNode findChildTags:@"table"];
        
        for (HTMLNode *spanNode in spanNodes) {
            if ([[spanNode getAttributeNamed:@"summary"] isEqualToString:@"Grunddaten zur Veranstaltung"]) {
                
                HTMLNode *cell1 = [spanNode findChildWithAttribute:@"headers" matchingName:@"basic_1" allowPartial:NO];
                HTMLNode *cell2 = [spanNode findChildWithAttribute:@"headers" matchingName:@"basic_2" allowPartial:NO];
                HTMLNode *cell3 = [spanNode findChildWithAttribute:@"headers" matchingName:@"basic_3" allowPartial:NO];
                HTMLNode *cell9 = [spanNode findChildWithAttribute:@"headers" matchingName:@"basic_9" allowPartial:NO];
                
                NSString* familyName = [cell1 contents];
                
                NSString* firstName = [cell3 contents];
                NSString* completeName = @"";
                if (firstName) {
                    completeName = [completeName stringByAppendingString:firstName];
                }
                
                if (familyName) {
                    completeName = [completeName stringByAppendingFormat:@" %@",familyName];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.name.text = completeName;
                });
                
                NSString* gender = [[cell2 contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (gender) {
                    [parsedInformations addObject:[gender capitalizedString]];
                    [heaerforInformations addObject:NSLocalizedString(@"Gender",nil)];
                }
                
                NSString* acadgrad = [cell9 contents];
                if (acadgrad && !([[acadgrad stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""]))
                {
                    [parsedInformations addObject:acadgrad];
                    [heaerforInformations addObject:NSLocalizedString(@"Academic degree",nil)];
                }
                
                
                
                
            }
            if([[spanNode getAttributeNamed:@"summary"] isEqualToString:@"Angaben zur Dienstadresse"]){
                HTMLNode *cell2 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_2" allowPartial:NO];
                HTMLNode *cell4 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_4" allowPartial:NO];
                HTMLNode *cell6 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_6" allowPartial:NO];
                cell6 = [cell6 findChildTag:@"a"];
                HTMLNode *cell7 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_7" allowPartial:NO];
                cell7 = [cell7 findChildTag:@"a"];
                HTMLNode *cell8 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_8" allowPartial:NO];
                cell8 = [cell8 findChildTag:@"a"];
                HTMLNode *cell9 = [spanNode findChildWithAttribute:@"headers" matchingName:@"pAdress_9" allowPartial:NO];
                cell9 = [cell9 findChildTag:@"a"];
                
                
                
                NSString* building = [cell9 contents];
                //check if empty
                if (building && !([[building stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])) {
                    if (building.length>=4) {
                        NSRange range = NSMakeRange(building.length-4, 4);
                        building = [building substringWithRange:range];
                        [parsedInformations addObject:building];
                        [heaerforInformations addObject:NSLocalizedString(@"Building",nil)];
                    }
                   
                }
                
                NSString* room = [cell7 contents];
                if (room && !([[room stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])) {
                    [parsedInformations addObject:[room stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    [heaerforInformations addObject:NSLocalizedString(@"Room",nil)];
                }
                
                NSString* tel = [[cell2 contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (tel && !([[tel stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])) {
                    [parsedInformations addObject:[tel stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    [heaerforInformations addObject:NSLocalizedString(@"Phone",nil)];
                }
                
                NSString* fax = [cell4 contents];
                if (fax && !([[fax stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])) {
                    [parsedInformations addObject:[fax stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    [heaerforInformations addObject:NSLocalizedString(@"Fax",nil)];
                }
                
                NSString* email = [cell6 contents];
                if (email && !([[email stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])) {
                    [parsedInformations addObject:[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    [heaerforInformations addObject:NSLocalizedString(@"E-mail",nil)];
                }
                
                
                
                /*NSString* hyperlink = [cell8 contents];
                
                if ([[Reachability class] websiteAvailable:hyperlink]) {
                    [parsedInformations addObject:hyperlink];
                    [heaerforInformations addObject:@"Hyperlink"];
                }*/
                
                
                
            }
            
        }
        
        [parsedInformations addObject:NSLocalizedString(@"More information",nil)];
        [heaerforInformations addObject:@" "];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.loadingView setHidden:YES];
            [self.activityIndicator stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        });

    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Please check your internet connection and try again",nil)];
        UIAlertView *reachabilityAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No internet conncetion",nil) message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [reachabilityAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        });

    }
}

//button on alertview has been clicked. (appears if no internet connection)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSelectorOnMainThread:@selector(popVC) withObject:nil waitUntilDone:NO];
}


-(void) popVC{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    self.parsedInformations = nil;
    self.heaerforInformations = nil;
    self.name = nil;
    self.selectedBuilding = nil;
    self.backgroundThread = nil;
    self.fullURL = nil;
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  parsedInformations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString* )tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return  [heaerforInformations objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [cell.textLabel setText:[parsedInformations objectAtIndex:indexPath.section]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if ([[heaerforInformations objectAtIndex:indexPath.section] isEqual:NSLocalizedString(@"E-mail",nil)]) {
        if ([MFMailComposeViewController canSendMail]) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    if ([[heaerforInformations objectAtIndex:indexPath.section] isEqual:NSLocalizedString(@"Building",nil)]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    if ([[parsedInformations objectAtIndex:indexPath.section] isEqual:NSLocalizedString(@"More information",nil)]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
        
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[heaerforInformations objectAtIndex:indexPath.section] isEqual:@"E-mail"] && [MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];  
        mc.mailComposeDelegate = self;  
        
     
        
        // set some recipients ... but you do not need to do this :) 
        [mc setToRecipients:[NSArray arrayWithObjects:[parsedInformations objectAtIndex:indexPath.section], nil]]; 
        
        // displaying our modal view controller on the screen with standard transition  
        [self presentViewController:mc animated:YES completion:nil];
    }
    else {
        if ([[heaerforInformations objectAtIndex:indexPath.section] isEqual:NSLocalizedString(@"Building",nil)]) {
            selectedBuilding = [parsedInformations objectAtIndex:indexPath.section];
            [self performSegueWithIdentifier:@"showBuildingOnMap" sender:self];
        }
        else {
            if ([[parsedInformations objectAtIndex:indexPath.section] isEqual:NSLocalizedString(@"More information",nil)] ){
                [self performSegueWithIdentifier:@"showInfo" sender:self];
            }
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error 
{ 
    if(error) NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqual:@"showInfo"]) {
        WebViewController* webVC = segue.destinationViewController;
        [webVC setUrlAsString:[fullURL absoluteString]];
    } else if ([segue.identifier isEqual:@"showBuildingOnMap"]){
        MapsViewController* mapVC =  segue.destinationViewController;
        NSString* building = [selectedBuilding stringByReplacingOccurrencesOfString:@" " withString:@""];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [mapVC pinPOIsThatIncludeSearchKey:building];
        });
    }

}




@end
