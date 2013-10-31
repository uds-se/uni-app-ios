//
//  UIRightPinAccessoryButton.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 09.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "UIRightPinAccessoryButton.h"

@implementation UIRightPinAccessoryButton

@synthesize annotPin;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detailDis" ofType:@"png"]] forState:UIControlStateNormal];
               
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}



@end
