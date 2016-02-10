//
//  EventsListTableViewCell.m
//  Uni Saar
//
//  Created by Steffen on 05.02.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "EventsListTableViewCell.h"

@implementation EventsListTableViewCell

@synthesize EventTitleView = _EventTitleView;
@synthesize EventSubTitleView = _EventSubTitleView;
@synthesize EventIcon =_EventIcon;
@synthesize date, dayView, monthView;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setDateImage{
    
    
    dayView.text = [self getDayNumberOutOfDate];
    dayView.transform = CGAffineTransformMakeRotation((-6 * M_PI)/100);
    
    monthView.text = [self getMonthOutOfDate];
    monthView.transform = CGAffineTransformMakeRotation((-6 * M_PI)/100);
    
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
        
        if ([dateString containsString:@"Januar"]) {
            dateString=NSLocalizedStringFromTable(@"January", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Februar"]) {
            dateString=NSLocalizedStringFromTable(@"February", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"März"]) {
            dateString=NSLocalizedStringFromTable(@"March", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"April"]) {
            dateString=NSLocalizedStringFromTable(@"April", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Mai"]) {
            dateString=NSLocalizedStringFromTable(@"May", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Juni"]) {
            dateString=NSLocalizedStringFromTable(@"June", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Juli"]) {
            dateString=NSLocalizedStringFromTable(@"July", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"August"]) {
            dateString=NSLocalizedStringFromTable(@"August", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"September"]) {
            dateString=NSLocalizedStringFromTable(@"September", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Oktober"]) {
            dateString=NSLocalizedStringFromTable(@"October", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"November"]) {
            dateString=NSLocalizedStringFromTable(@"November", @"tvosLocalisation", nil);
        }
        if ([dateString containsString:@"Dezember"]) {
            dateString=NSLocalizedStringFromTable(@"December", @"tvosLocalisation", nil);
        }
        
            
        
            return dateString;
        }
        
        
    return @"..";

}

@end
