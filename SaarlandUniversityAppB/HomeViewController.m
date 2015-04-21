//
//  HomeViewController.m
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize imageView,slideShow, selectedCampus, campusLabel;

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
    
    //initiates the slideshow on the iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        slideShow = [[SlideShow alloc] init];
        [self showNewImage];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showNewImage) userInfo:nil repeats:YES];
    }
    
    //adjusts the background image if iPhone5
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        //BackgroundImage
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        backgroundImageView.image = [UIImage imageNamed:filename];
        
        
    } 
    if( [selectedCampus isEqualToString:@"saar"]){
        [campusLabel setText:@"Saarbrücken Campus"];
    }
    else{
        [campusLabel setText:@"Homburg Campus"];
    }
}



-(void)showNewImage{
    [imageView setImage:[slideShow getRandomImage]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@", segue.identifier);
    if(segue.identifier !=NULL){
        if([segue.identifier isEqualToString:@"showMensa"]){
            MensaViewController *mensaVC = segue.destinationViewController;
            mensaVC.selectedCampus = self.selectedCampus;
        }
        else if([segue.identifier isEqualToString:@"showBuses"]){
            BusTableViewController *busVC = segue.destinationViewController;
            busVC.selectedCampus = self.selectedCampus;
        }
        else if([segue.identifier isEqualToString:@"showMap"]){
            MapsViewController *mapVC = segue.destinationViewController;
            mapVC.selectedCampus = self.selectedCampus;
        }
    }
    
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    imageView = nil;
    slideShow = nil;
    [self setSlideShow:nil];
    backgroundImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
