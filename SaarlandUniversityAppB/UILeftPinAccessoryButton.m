//
//  UILeftPinAccessoryButton.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 17.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "UILeftPinAccessoryButton.h"

@implementation UILeftPinAccessoryButton

@synthesize coord,title,description;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wayPointsButton" ofType:@"png"]] forState:UIControlStateNormal];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}




@end
