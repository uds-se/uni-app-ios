//
//  CustomMensaKioskCell.h
//  Uni Saar
//
//  Created by Daniel on 28/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMensaKioskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *CustomCategory;
@property (weak, nonatomic) IBOutlet UILabel *CustomFood;
@property (weak, nonatomic) IBOutlet UILabel *CustomPrice1;
@property (weak, nonatomic) IBOutlet UILabel *CustomPrice2;
@property (weak, nonatomic) IBOutlet UILabel *CustomPrice3;
@property (weak, nonatomic) IBOutlet UIImageView *CustomStripe;



@end
