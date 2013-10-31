//
//  UILabel+UILabel_AutoHeight.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 14.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "UILabel+UILabel_AutoHeight.h"

@implementation UILabel (UILabel_AutoHeight)


//Autoadjusts the height of a Label, to fit the whole content (text)
- (void)adjustHeight {
    
    if (self.text == nil) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 0);
        return;
    }
    
    CGSize aSize = self.bounds.size;
    CGSize tmpSize = CGRectInfinite.size;
    tmpSize.width = aSize.width;
    
    tmpSize = [self.text sizeWithFont:self.font constrainedToSize:tmpSize];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, aSize.width, tmpSize.height);
}

@end
