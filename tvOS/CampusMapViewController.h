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
    NSArray *BuildOverviewSaar;
    NSArray *BuildOverviewHom;
    NSArray *Buildings;


    NSIndexPath *OverviewCurrentlyAt;
    NSArray *BuildA;
    NSArray *BuildB;
    NSArray *BuildC;
    NSArray *BuildD;
    NSArray *BuildE;
    NSArray *AllBuildings;
    NSString *SelectedLocation;    
    NSString *SelectedCampus;
    float xOffset;
    float yOffset;
//    NSString *Person;
    NSArray *Test;
    NSString *TestA;
    float PinSizeX;
    float PinSizeY;
    
    BOOL Camp;
    NSArray *ChirZen;
    NSArray *ZenInMed;
    NSArray *IntZen;
    NSArray *ZenInf;
    NSArray *ZenFrKiAd;
    NSArray *NeuZen;
    NSArray *RadZen;
    NSArray *ZenZaMuKi;
    NSArray *ZenPaRe;
    NSArray *SpeKom;
    NSArray *GesStAuf;
    NSArray *Schu;
    NSArray *EinUdS;
    NSArray *InsThMed;
    NSArray *SonstEin;
    NSArray *DiVeWiTe;
    
}

@property (weak,nonatomic) NSString *Person;
@property (weak, nonatomic) IBOutlet UITableView *OverviewTableView;

@property (weak, nonatomic) IBOutlet UITableView *BuildingsTableView;


@property (weak, nonatomic) IBOutlet UIImageView *MapImage;
@property (weak, nonatomic) IBOutlet UIImageView *DestinationPointer;
@property (weak, nonatomic) IBOutlet UIImageView *CurrentLocationPointer;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *Button;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *DestinationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *DestinationImage;
@property (weak, nonatomic) IBOutlet UIImageView *LocationImage;
float getCoordinates (NSArray *TempCoord, int i);
- (IBAction)SearchButton:(id)sender;
- (NSArray*)getBuildingInfo: (NSString*) BuildingName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BuildingTablePos;





@end
