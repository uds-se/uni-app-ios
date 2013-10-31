//
//  NewsTableViewCell.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 30.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell{

    IBOutlet UILabel *pubDate;
    
    IBOutlet UILabel *title;
}

@property  (nonatomic,retain) IBOutlet UILabel *pubDate;

@property  (nonatomic,retain) IBOutlet UILabel *title;


@end
