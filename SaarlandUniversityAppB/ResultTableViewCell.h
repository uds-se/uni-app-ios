//
//  ResultTableViewCell.h
//  SaarlandUniversityAppB
//
//  Created by Jianan Ma on 12-7-12.
//  Copyright (c) 2012年 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell{
        IBOutlet UILabel *name;
//        NSURL *link;
}

@property  (nonatomic,retain) IBOutlet UILabel *name;
//@property  NSURL *link;


@end
