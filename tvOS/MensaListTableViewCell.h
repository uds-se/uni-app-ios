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
@property (nonatomic, weak) IBOutlet UILabel *Preis1;
@property (nonatomic, weak) IBOutlet UILabel *Preis2;
@property (nonatomic, weak) IBOutlet UILabel *Preis3;
@property (weak, nonatomic) IBOutlet UIImageView *colors;

@end
