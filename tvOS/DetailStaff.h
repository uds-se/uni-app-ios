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

@property NSURL* fullURL;

@property NSOperationQueue* backgroundThread;


-(void) parseInformations;

@end
