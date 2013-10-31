//
//  OpeningHoursViewController.h
//  SaarlandUniversityAppB
//
//  Created by Tobias Tykvart on 24.7.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningHoursViewController : UIViewController { 
    IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *backgroundImageView;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
