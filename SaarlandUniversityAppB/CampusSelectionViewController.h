//
//  CampusSelectionViewController.h
//  Uni Saar
//
//  Created by Omer Asif on 1/29/15.
//  Copyright (c) 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"


@interface CampusSelectionViewController : UIViewController{
__weak IBOutlet UIImageView *backgroundImageView;
}

@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@end
