//
//  DetailStaff.m
//  Uni Saar
//
//  Created by Karsten on 27.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "DetailStaff.h"

@implementation DetailStaff

@synthesize fullURL,backgroundThread;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundThread = [NSOperationQueue new];
    NSInvocationOperation *parseOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseInformations) object:nil];
    [parseOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [backgroundThread addOperation:parseOperation];
    
    [self.loadingView setHidden:NO];
    [self.activityIndicator startAnimating];
    [self.nointernet setHidden:YES];
    [self.button setTitle:NSLocalizedStringFromTable(@"show building", @"tvosLocalisation", nil) forState:0] ;    
}

-(void) parseInformations{
    
    if ([Reachability hasInternetConnection]){
    
    NSData *data = [NSData dataWithContentsOfURL:fullURL];
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    html = [html stringByReplacingOccurrencesOfString:@"<!--" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"--!>" withString:@""];
    data = [html dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *Parser = [TFHpple hppleWithHTMLData:data];
    NSArray *Nodes = [Parser searchWithXPathQuery:@"//th[@class='mod'] | //td[@class='mod_n_basic']"];
    DetailsPerson = [NSMutableArray array];
    NSString *firstName;
    NSString *familyName;
    NSString *aka;
    NSString *phone;
    NSString *sex;
    NSString *faxx;
    NSString *mail;
    NSString *room;
    NSString *building;
    
    
    for (TFHppleElement *elem in Nodes){
        //if (!([[elem content] isEqual:@""])) {
        NSString *cont = [elem content];
        cont = [cont stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        cont = [cont stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        cont = [cont stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        [DetailsPerson addObject:cont];
        //  }
    }
    
    for (int i = 0; i<DetailsPerson.count-1;i++){
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Nachname"]) {
            familyName = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Geschlecht"]) {
            sex = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Vorname"]) {
            firstName = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Akad. Grad"]) {
            aka = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Telefon"]) {
            phone = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Fax"]) {
            faxx = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"E-Mail-Adresse"]) {
            mail = [DetailsPerson objectAtIndex:i+1];
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Dienstzimmer"]) {
            room = [DetailsPerson objectAtIndex:i+1];
            if (room.length >= 5){
            NSRange range = NSMakeRange(1, 8);
            room = [room stringByReplacingCharactersInRange:range withString:@""];
            }
        }
        
        if ([[DetailsPerson objectAtIndex:i] isEqualToString:@"Gebäude"]) {
            building = [DetailsPerson objectAtIndex:i+1];
            building = [building stringByReplacingOccurrencesOfString:@"-->" withString:@""];
            building = [building stringByReplacingOccurrencesOfString:@"Gebäude " withString:@""];
        }
        
        
        NSString* completeName = @"";
        if (firstName) {
            completeName = [completeName stringByAppendingString:firstName];
        }
        
        if (familyName) {
            completeName = [completeName stringByAppendingFormat:@" %@",familyName];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setHidden:YES];
            [self.activityIndicator stopAnimating];
            self.name.text = completeName;
            self.Telefon.text = phone;
            self.akad.text = aka;
            self.geschlecht.text = sex;
            self.fax.text = faxx;
            self.email.text = mail;
            self.raum.text = room;
            self.gebäude.text = building;    
        });
        
        
        
        
    }
    }
    
    else {
        [self.nointernet setHidden:NO];
        [self.name setHidden:YES];
        [self.Telefon setHidden:YES];
        [self.akad setHidden:YES];
        [self.geschlecht setHidden:YES];
        [self.fax setHidden:YES];
        [self.email setHidden:YES];
        [self.raum setHidden:YES];
        [self.gebäude setHidden:YES];
        [self.namelabel setHidden:YES];
        [self.detailslabel setHidden:YES];
        [self.telefonlabel setHidden:YES];
        [self.akadlabel setHidden:YES];
        [self.emaillabel setHidden:YES];
        [self.geschlechtlabel setHidden:YES];
        [self.gebäudelabel setHidden:YES];
        [self.raumlabel setHidden:YES];
        [self.faxlabel setHidden:YES];
        [self.loadingView setHidden:YES];
        [self.button setHidden:YES];
    }
   
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CampusMapViewController* cMap = segue.destinationViewController;
    [cMap setPerson:self.gebäude.text];    
}

- (IBAction)buttonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"showBuilding" sender:self];
    
}


@end
