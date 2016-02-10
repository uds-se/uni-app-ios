//
//  EventsListTableViewCell.h
//  Uni Saar
//
//  Created by Steffen on 05.02.16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsListTableViewCell : UITableViewCell{

NSString* date;
}

@property  (nonatomic,retain) NSString *date;
@property (weak, nonatomic) IBOutlet UILabel *EventTitleView;
@property (weak, nonatomic) IBOutlet UILabel *EventSubTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *EventIcon;
@property (weak, nonatomic) IBOutlet UILabel *dayView;
@property (weak, nonatomic) IBOutlet UILabel *monthView;


-(void) setDateImage;

@end
