//
//  CampusSelectionViewController.m
//  Uni Saar
//
//  Created by Omer Asif on 1/29/15.
//  Copyright (c) 2015 Universität des Saarlandes. All rights reserved.
//

#import "CampusSelectionViewController.h"

@interface CampusSelectionViewController ()

@end

@implementation CampusSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //adjusts the background image if iPhone5
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        //BackgroundImage
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        backgroundImageView.image = [UIImage imageNamed:filename];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *campusVal;
    NSString *key = @"selectedCampus"; // the key for the data
    
    if (self.segmentedControl.selectedSegmentIndex == 0){
        
        campusVal = @"saar";
    }
    else{
        
        campusVal = @"hom";
    }
    
    [defaults setObject:campusVal forKey:key];
    [defaults synchronize];
    
    /*HomeViewController* homeVC = segue.destinationViewController;
    
    if (self.segmentedControl.selectedSegmentIndex == 0){
       
        [homeVC setSelectedCampus:@"saar"];
    }
    else{
        
        [homeVC setSelectedCampus:@"hom"];
    }*/

}


@end
