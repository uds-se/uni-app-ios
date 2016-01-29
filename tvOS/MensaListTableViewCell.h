//
//  MensaListTableViewCell.h
//  Uni Saar
//
//  Created by Nathan on 18.12.15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MensaListTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *Gericht_Art;
@property (nonatomic, weak) IBOutlet UILabel *Gericht_Name;
@property (nonatomic, weak) IBOutlet UILabel *Details;
@property (nonatomic, weak) IBOutlet UILabel *Preise;
@property (nonatomic, weak) IBOutlet UILabel *Tag;
@property (nonatomic, weak) IBOutlet UIImage *colors;

//@property (nonatomic) NSMutableArray *contentForTables;
//@property (nonatomic) NSMutableArray *contentForHeaders;
//@property (nonatomic) NSMutableArray *contentForFooters;

@end
