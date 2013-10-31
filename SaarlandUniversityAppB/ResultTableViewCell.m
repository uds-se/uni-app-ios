//
//  ResultTableViewCell.m
//  SaarlandUniversityAppB
//
//  Created by Jianan Ma on 12-7-13.
//  Copyright (c) 2012年 Universität des Saarlandes. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell
@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
