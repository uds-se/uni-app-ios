//
//  UIRightPinAccessoryButton.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 09.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotations.h"

@interface UIRightPinAccessoryButton : UIButton{
    Annotations *annotPin;
    
}

@property (nonatomic) Annotations *annotPin;



@end
