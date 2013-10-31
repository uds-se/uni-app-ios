//
//  MensaView.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 10.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "MensaView.h"

@implementation MensaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.backgroundView = nil;

    }
    return self;
}



@end
