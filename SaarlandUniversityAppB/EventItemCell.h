//
//  EventItemCell.h
//  SaarlandUniversityAppB
//
//  Created by Matthias Sambale on 26.06.12.
//  Revised by Tom Michels  05-2013
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventItemCell : UITableViewCell{
    
    NSString* date;
    
}


//getters and setters 
@property  (nonatomic,retain) IBOutlet UILabel *title;
@property  (nonatomic,retain) NSString *date;

@property BOOL *addedToIcal;


@property (nonatomic) IBOutlet UILabel *dateNumber;
@property (nonatomic) IBOutlet UILabel *dateMonth;


-(void) setDateImage;

@end


