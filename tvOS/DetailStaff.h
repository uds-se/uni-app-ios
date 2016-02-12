//
//  DetailStaff.h
//  Uni Saar
//
//  Created by Karsten on 27.01.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStaff.h"
#import "TFHpple.h"
#import "Reachability.h"
#import "CampusMapViewController.h"


@interface DetailStaff : UIViewController{

NSURL* fullURL;
NSOperationQueue* backgroundThread;
NSMutableArray *DetailsPerson;
    
}

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *geschlecht;
@property (weak, nonatomic) IBOutlet UILabel *akad;
@property (weak, nonatomic) IBOutlet UILabel *gebäude;
@property (weak, nonatomic) IBOutlet UILabel *raum;
@property (weak, nonatomic) IBOutlet UILabel *Telefon;
@property (weak, nonatomic) IBOutlet UILabel *fax;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nointernet;
@property (weak, nonatomic) IBOutlet UILabel *detailslabel;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *geschlechtlabel;
@property (weak, nonatomic) IBOutlet UILabel *akadlabel;
@property (weak, nonatomic) IBOutlet UILabel *gebäudelabel;
@property (weak, nonatomic) IBOutlet UILabel *raumlabel;
@property (weak, nonatomic) IBOutlet UILabel *telefonlabel;
@property (weak, nonatomic) IBOutlet UILabel *faxlabel;
@property (weak, nonatomic) IBOutlet UILabel *emaillabel;
@property (weak, nonatomic) IBOutlet UIButton *button;



@property NSURL* fullURL;
@property NSUserDefaults *defaults;
@property NSOperationQueue* backgroundThread;


-(void) parseInformations;

- (IBAction)buttonPressed:(id)sender;

@end
