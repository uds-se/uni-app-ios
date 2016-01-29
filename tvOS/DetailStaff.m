//
//  DetailStaff.m
//  Uni Saar
//
//  Created by Karsten on 27.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "DetailStaff.h"

@implementation DetailStaff

@synthesize fullURL,name,backgroundThread,geschlecht;


- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundThread = [NSOperationQueue new];
    name.text = [NSString stringWithFormat:@""];
    geschlecht.text = [NSString stringWithFormat:@""];
   
    
    
    NSInvocationOperation *parseOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseInformations) object:nil];
    [parseOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [backgroundThread addOperation:parseOperation];
    
    
}

-(void) parseInformations{
    
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
                                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.geschlecht.text = gender;
                    });
                    
                /* Auskommentiert da benötigte infos im html code ebenfalls auskommentiert
                NSString* acadgrad = [cell9 contents];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.akad.text = acadgrad;
                });
                
                
                
                
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
                
                
                    if (building.length>=4) {
                        NSRange range = NSMakeRange(building.length-4, 4);
                        building = [building substringWithRange:range];
                        
                 
                 self.gebäude.text = building;
                        
                        
                }
                
                NSString* room = [cell7 contents];
                
                    self.raum.text = room;
                
               
                
                NSString* tel = [[cell2 contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                    self.Telefon.text = tel;
                    
                
                NSString* fax = [cell4 contents];
                
                    self.fax.text = fax;
                    
                
                NSString* email = [cell6 contents];
                
                    
                    self.email.text = email;
                
                */
                
            }}}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.name = nil;
    self.backgroundThread = nil;
    self.fullURL = nil;
    
}

@end
