//
//  MensaListTableViewCell.m
//  Uni Saar
//
//  Created by Nathan on 18.12.15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "MensaListTableViewCell.h"

@implementation MensaListTableViewCell

@synthesize Gericht_Art = _Gericht_Art;
@synthesize Details = _Details;
@synthesize Preise = _Preise;
@synthesize Tag = _Tag;
@synthesize colors = _colors;
@synthesize Gericht_Name = _Gericht_Name;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
