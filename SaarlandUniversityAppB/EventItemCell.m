//
//  EventItemCell.m
//  SaarlandUniversityAppB
//
//  Created by Matthias Sambale on 26.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "EventItemCell.h"

@implementation EventItemCell

@synthesize title, date, addedToIcal,dateNumber,dateMonth;

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

-(void) setDateImage{
    
    
    dateNumber.text = [self getDayNumberOutOfDate];
    dateNumber.transform = CGAffineTransformMakeRotation((-6 * M_PI)/100); 
    
    dateMonth.text = [self getMonthOutOfDate];
    dateMonth.transform = CGAffineTransformMakeRotation((-6 * M_PI)/100); 
    
}


-(NSString*) getDayNumberOutOfDate{
    if (date != nil) {
        NSString *numberString;
        
        NSScanner *scanner = [NSScanner scannerWithString:date.copy];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        
        return numberString;
    }
    return  @"..";
    
}


-(NSString*) getMonthOutOfDate{
    
    if (date != nil) {
        
        NSString* dateString = date.copy;
        
        dateString = [dateString substringWithRange:NSMakeRange(8, 3)];
        
        return dateString;
    }
    return @"..";
    
    
}


@end
