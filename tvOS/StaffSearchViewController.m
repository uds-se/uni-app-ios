//
//  StaffSearchViewController.m
//  Uni Saar
//
//  Created by Karsten on 26.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "StaffSearchViewController.h"

@implementation StaffSearchViewController

- (IBAction)buttonPressed:(id)sender {
   
    if (self.vorname.text.length<=0 && self.nachname.text.length<=0) {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Keine Eingabe" message:@"Bitte mindestens ein Suchfeld ausfüllen" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        queryUrl = [[NSString alloc] init];
        NSString* Vorname = self.vorname.text;
        NSString* Nachname = self.nachname.text;
        
        if (!self.nachname.text) {
            Nachname = @"";
        }
        if (!self.vorname.text) {
            Vorname = @"";
        }
        
        
        NSString* allQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=40&_form=display",Vorname,Nachname];
        NSString* profQueryUrl = [NSString stringWithFormat: @"https://www.lsf.uni-saarland.de/qisserver/rds?state=wsearchv&search=7&purge=y&moduleParameter=person/person&choice.r_funktion.pfid=y&r_funktion.pfid=171&personal.vorname=%@&personal.nachname=%@&P_start=0&P_anzahl=50&_form=display",Vorname,Nachname];
        
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            queryUrl = allQueryUrl;
        }else if (self.segmentedControl.selectedSegmentIndex == 0){
            queryUrl = profQueryUrl;
        }
        
        
        [self performSegueWithIdentifier:@"showResults" sender:self];    }
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
