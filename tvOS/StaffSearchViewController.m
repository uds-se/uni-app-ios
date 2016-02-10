//
//  StaffSearchViewController.m
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "StaffSearchViewController.h"

@implementation StaffSearchViewController


-(void)viewDidLoad{
    
    [self.nointernet setHidden:YES];
    [self.segmentedControl setTitle: NSLocalizedStringFromTable(@"Professors", @"tvosLocalisation", nil) forSegmentAtIndex:0];
    [self.segmentedControl setTitle: NSLocalizedStringFromTable(@"All", @"tvosLocalisation", nil) forSegmentAtIndex:1];
    [self.button setTitle:NSLocalizedStringFromTable(@"Search", @"tvosLocalisation", nil) forState:0] ;
}

// check internetconnection when view appears
- (void)viewDidAppear:(BOOL)animated {
    
    if ([Reachability hasInternetConnection]){
        [self.nointernet setHidden:YES];
    }
    
    
    else {
        
        [self.nointernet setHidden:NO];
        [self.stafflabel setHidden:YES];
        [self.vnamelabel setHidden:YES];
        [self.button setHidden:YES];
        [self.segmentedControl setHidden:YES];
        [self.vorname setHidden:YES];
        [self.nachname setHidden:YES];
        [self.nnamelabel setHidden:YES];
        
        
    }
    
}
// done when button is pressed
- (IBAction)buttonPressed:(id)sender {
   //if there are no inputs in the Textfields
    if (self.vorname.text.length<=0 && self.nachname.text.length<=0) {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Keine Eingabe" message:@"Bitte mindestens ein Suchfeld ausfüllen" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
    // if 'all' is selected and there are not enough inputs
    else if (self.segmentedControl.selectedSegmentIndex == 1 && self.vorname.text.length<=2 && self.nachname.text.length<=2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Zu wenig Information" message:@"Bei der Suche unter 'Alle' bitte mindestens ein Suchfeld mit mindestens 3 Buchstaben ausfüllen" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    }
        
    else{
        
        queryUrl = [[NSString alloc] init];
        
        //get user input
        NSString* Vorname = self.vorname.text;
        NSString* Nachname = self.nachname.text;
        
        //if there is no input in one of the textfields
        if (!self.nachname.text) {
            Nachname = @"";
        }
        if (!self.vorname.text) {
            Vorname = @"";
        }
        
        
        NSString* allQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=40&_form=display",Vorname,Nachname];
        NSString* profQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&choice.r_funktion.pfid=y&r_funktion.pfid=171&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=50&_form=display",Vorname,Nachname];
        
        
        //set the url depending of the selection 'all' or 'nur Professoren'
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            queryUrl = allQueryUrl;
        }else if (self.segmentedControl.selectedSegmentIndex == 0){
            queryUrl = profQueryUrl;
        }
        
        
        [self performSegueWithIdentifier:@"showResults" sender:self];
        
    
    
        }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ResultStaffSearchViewController* resultVC = segue.destinationViewController;
    [resultVC setFullURL:queryUrl];
    if (self.segmentedControl.selectedSegmentIndex == 1){
        [resultVC setSearchParam:@"All"];
    }
    else{
        [resultVC setSearchParam:@"Profs"];
    }
    
}
@end
