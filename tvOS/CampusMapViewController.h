//
//  CampusMapViewController.h
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CampusMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    NSArray *BuildOverview;
    NSArray *Buildings;
    NSArray *BuildingX;
    NSArray *BuildingsA;
    NSArray *BuildingsB;
    NSArray *BuildingsC;
    NSArray *BuildingsD;
    NSArray *BuildingsE;
    NSIndexPath *OverviewCurrentlyAt;
    NSString *BuidingTemp;
    NSArray *Destination;
    NSNumber *xPosition;
    NSNumber *yPosition;
    CGRect InitPosition;
    CGPoint BuildingPosition;
    NSArray *BuildA;
    NSArray *BuildB;
    NSArray *BuildC;
    NSArray *BuildD;
    NSArray *BuildE;
    float xPosA;
    float yPosA;
    NSArray *xPosi;
    NSArray *BuildingsList;
    NSArray *CurrentLocation;
    NSString *Location;
    NSArray *Temp;
    NSString *Campus;
}


@property (weak, nonatomic) IBOutlet UITableView *OverviewTableView;

@property (weak, nonatomic) IBOutlet UITableView *BuildingsTableView;

// nur Tests---------------------------

@property (weak, nonatomic) IBOutlet UIImageView *MapImage;
@property (weak, nonatomic) IBOutlet UIImageView *LocationPointer;
@property (weak, nonatomic) IBOutlet UIImageView *CurrentLocationPointer;
- (IBAction)SearchButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *Button;





// Tests ende---------------------------


@end
