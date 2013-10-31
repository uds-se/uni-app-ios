//
//  OpeningHoursViewController.m
//  SaarlandUniversityAppB
//
//  Created by Tobias Tykvart on 24.7.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "OpeningHoursViewController.h"

@interface OpeningHoursViewController ()

@end

@implementation OpeningHoursViewController

@synthesize scrollView;

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
    
    scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [self bottomOfLowestContent:scrollView]);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSString *filename = @"HomeScreenBackgroundiPhone.jpg";
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        if (screenRect.size.height == 568.0f)
            filename = [filename stringByReplacingOccurrencesOfString:@".jpg" withString:@"-568@2x.jpg"];
        
        backgroundImageView.image = [UIImage imageNamed:filename];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (CGFloat) bottomOfLowestContent:(UIView*) view
{
    CGFloat lowestPoint = 0.0;
    
    BOOL restoreHorizontal = NO;
    BOOL restoreVertical = NO;
    
    if ([view respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [view respondsToSelector:@selector(setShowsVerticalScrollIndicator:)])
    {
        if ([(UIScrollView*)view showsHorizontalScrollIndicator])
        {
            restoreHorizontal = YES;
            [(UIScrollView*)view setShowsHorizontalScrollIndicator:NO];
        }
        if ([(UIScrollView*)view showsVerticalScrollIndicator])
        {
            restoreVertical = YES;
            [(UIScrollView*)view setShowsVerticalScrollIndicator:NO];
        }
    }
    for (UIView *subView in view.subviews)
    {
        if (!subView.hidden)
        {
            CGFloat maxY = CGRectGetMaxY(subView.frame);
            if (maxY > lowestPoint)
            {
                lowestPoint = maxY;
            }
        }
    }
    if ([view respondsToSelector:@selector(setShowsHorizontalScrollIndicator:)] && [view respondsToSelector:@selector(setShowsVerticalScrollIndicator:)])
    {
        if (restoreHorizontal)
        {
            [(UIScrollView*)view setShowsHorizontalScrollIndicator:YES];
        }
        if (restoreVertical)
        {
            [(UIScrollView*)view setShowsVerticalScrollIndicator:YES];
        }
    }
    
    return lowestPoint;
}

- (void)viewDidUnload
{
    backgroundImageView = nil;
    [super viewDidUnload];
    scrollView = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
