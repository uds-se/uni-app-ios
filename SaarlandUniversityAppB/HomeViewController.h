//
//  HomeViewController.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideShow.h"

@interface HomeViewController : UIViewController{
    
    __weak IBOutlet UIImageView *imageView;
    SlideShow* slideShow ;
    __weak IBOutlet UIImageView *backgroundImageView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property SlideShow* slideShow ;

@end
