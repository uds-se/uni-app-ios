//
//  CampusMapViewController.m
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//
/*
struct Building {
  
    char Letter;
    float Number ;
    float xPos;
    float yPos;
    
};
*/

#import "CampusMapViewController.h"

@interface CampusMapViewController ()

@end


@implementation CampusMapViewController
@synthesize OverviewTableView;
@synthesize BuildingsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _LocationPointer.hidden = true;
    OverviewTableView.hidden = true;
    BuildingsTableView.hidden = true;
    
    
//    current Location
    _CurrentLocationPointer.translatesAutoresizingMaskIntoConstraints = true;
    _CurrentLocationPointer.frame = CGRectMake(1810, 130, 50, 50);
    _CurrentLocationPointer.image = [UIImage imageNamed:@"locButton.png"];
    
//    
    BuildOverview = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
    BuildingsA = [[NSArray alloc] initWithObjects:@"A1", @"A2", @"A3", @"A4", @"A5", nil];
    BuildingsB = [[NSArray alloc] initWithObjects:@"B1", @"B2", @"B3", @"B4", @"B5", @"B6", nil];
    BuildingsC = [[NSArray alloc] initWithObjects:@"C1", @"C2", @"C3", @"C4", @"C5", nil];
    BuildingsD = [[NSArray alloc] initWithObjects:@"D1", @"D2", @"D3", @"D4", @"D5", @"D7", nil];
    BuildingsE = [[NSArray alloc] initWithObjects:@"E1", @"E2", @"E3", @"E4", @"E5", nil];

    InitPosition = CGRectMake(100, 100, 50, 50);
    //BuildingPosition = CGPointMake(xPos, yPos);
//    float xPosA[] = {100, 200, 300, 400, 500};
//    float yPosA[] = {100, 200, 300, 400, 500};
//    self.TextAusgabe.text = BuidingTemp;
//        xPosi = [[ NSArray alloc] initWithObjects:@100f,@200f , nil]
    NSArray *A11 = @[@"A1 1", @775.0f, @360.1f];
    NSArray *A21 = @[@"A1 2", @775.0f, @390.0f];
    NSArray *A31 = @[@"A1 3", @775.0f, @430.0f];
    NSArray *A41 = @[@"A1 4", @770.0f, @455.0f];
    NSArray *A51 = @[@"A1 5", @775.0f, @490.0f];
    GebA = [[NSArray alloc] initWithObjects:A11, A21, A31, A41, A51, nil];

    NSArray *B11 = @[@"B1 1", @773.0f, @725.1f];
    NSArray *B21 = @[@"B1 2", @200.0f, @200.0f];
    NSArray *B31 = @[@"B1 3", @300.0f, @300.0f];
    NSArray *B41 = @[@"B1 4", @400.0f, @400.0f];
    NSArray *B51 = @[@"B1 5", @500.0f, @500.0f];
    NSArray *B61 = @[@"B1 6", @500.0f, @500.0f];
    GebB = [[NSArray alloc] initWithObjects:B11, B21, B31, B41, B51, B61, nil];
    GebC = GebE = GebD = GebB;
//    NSArray *xPosA = @[@100.0f, @200.0f, @300.0f, @400.0f, @500.0f];
//    NSArray *yPosA = @[@100.0, @200.0, @300.0, @400.0, @500.0];
    
//    LocationPointer.translatesAutoresizingMaskIntoConstraints = true;
//    LocationPointer.frame = CGRectMake(300, 300, 50, 50);
//
        //        BuildOverview = [[NSArray alloc] initWithObjects:BuildingsA, BuildingsB, BuildingsC, BuildingsD, BuildingsE, nil];
    
//    struct Building A1_1;
//    
//    A1_1.Letter = 'A';
//    A1_1.Number = 1.1;
//    A1_1.xPos = 800;
//    A1_1.yPos = 500;
//    
  
    
 //   UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(500, 500, 50, 50)];
  //  [imgView setImage:[UIImage imageNamed: @"iconGpsPfeil.png"]];
    
   // UIImageView *imgView = [[UIImageView alloc] initWithImage:@"iconGpsPfeil.png"];


    
    // xPos = 800;
    // yPos = 500;
  //  CGPoint Test = CGPointMake(5, 7);
//  [NSObject UIAccessibilityTraitAdjustable];
    
 //   _BuildPos.centerXAnchor = ;
    
    
}
- (IBAction)SearchButton:(id)sender
{
    OverviewTableView.hidden = false;
    BuildingsTableView.hidden = false;
    //_MapImage.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    _MapImage.alpha = 0.2;
    _MapImage.opaque = NO;
//    _Button.accessibilityElementDidLoseFocus;
//    OverviewTableView.accessibilityElementIsFocused;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    if(tableView == [self OverviewTableView]) {
      
        return 1;
    }
    else {
        return 1;
    }

    
}
// //Gebaeude Info Mehtode
//- (NSArray *)getBuildingInfo: (NSArray *)info: (NSInteger) Nummer
//
////- (NSArray*)getBuildingInfo: (NSArray*)info
//{
////    for (NSString *element in info){
////        NSArray *bla = element objedctAtIndex:0
////        NSArray *Buildings = @[bla];
////    }
////        return Buildings;
//    
//    NSInteger j = [info count];
//    NSMutableArray *GebList;
//    for (NSInteger i=0; i < j; i++) {
//        NSArray *GebList = [info objectAtIndex:i];
//    }
//    return GebList;
//}

//- (NSString*) getName:(UITableView *) tableView
//{
//    return [tableView objectAtIndex:0]
//}

//void ausgabe(float x, float y)
//{
//    CGPoint BuildingPosition = CGPointMake(x, y);
//    UIImageView *PointOfInterest;
//    PointOfInterest = [[UIImageView alloc] init];
//    [MapImage.view addSubview:PointOfInterest];
//    PointOfInterest.image = [UIImage imageNamed:@"iconGpsPfeil.png"];
//    //[PointOfInterest setFrame:CGRectMake(xPos, yPos, 50, 50)];
//    [PointOfInterest setFrame:InitPosition];
//    [PointOfInterest setCenter:BuildingPosition];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == [self OverviewTableView]) {
        return [BuildOverview count];
    }
    else {
        return [Buildings count] ;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == [self OverviewTableView]) {
    
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverviewCell"];
        cell.textLabel.text = [BuildOverview objectAtIndex:indexPath.row];
    
        return cell;
    }
    else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingCell"];
//        Buildings =
//        cell.textLabel.text = [Buildings objectAtIndex:indexPath.row];
        BuidingTemp = [[Buildings objectAtIndex:indexPath.row]objectAtIndex:0];
        cell.textLabel.text = BuidingTemp;
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == [self OverviewTableView]) {
        OverviewCurrentlyAt = indexPath;
        switch (indexPath.row) {
            case 0:
//                Buildings = BuildingsA;
//                BuildingsTableView.allowsSelection = YES;
//                BuildingX = [GebA.A11 objectAtIndex:indexPath.row];
//                Buildings = [BuildingX objectAtIndex:0];
//                NSInteger j = [indexPath count];
//                NSMutableArray *GebList;
//                for (NSInteger i=0; i < j; i++) {
//                    NSArray *GebList = [info objectAtIndex:i];
//                Buildings = BuildingsA;
                Buildings = GebA;
             //   BuildingsTableView.allowsSelection = true ;
//                BuildingsTableView.accessibilityElementIsFocused;
            
                break;
            case 1:
//                Buildings = BuildingsB;
               // BuildingsTableView.allowsSelection = YES;
                Buildings = GebB;
                break;
            case 2:
                Buildings = GebC;
               // BuildingsTableView.allowsSelection = YES;
                break;
            case 3:
                Buildings = GebD;
               // BuildingsTableView.allowsSelection = YES;
                break;
            case 4:
                Buildings = GebE;
             //   BuildingsTableView.allowsSelection = YES;
            default:
                break;
        }
        [BuildingsTableView reloadData];
        
    }
    else {
        //save setting with SettingCurrentlyAt und SettingDetailItems objectAtIndex:indexPath.row
   //     Buildings[indexPath.row] = CurrentPosition;
   //     xPos = [xPosA objectAtIndex:indexPath.row ];
        
//        CurrentPosition = [[BuildingsList objectAtIndex:indexPath.row]objectAtIndex:0] ;
//        self.TextAusgabe.text = CurrentPosition;
      
        //  UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(500, 500, 50, 50)];
      //  [imgView setImage:[UIImage imageNamed: @"locButton.png"]];
//        xPos = 800;
//        yPos = 500;
        
        //CGRect InitPosition = CGRectMake(500, 600, 50, 50);
        //CGPoint BuildingPosition = CGPointMake(900, 800);
        
//        BuildingPosition = CGPointMake(xPos, yPos);
//        UIImageView *PointOfInterest;
//        
//        PointOfInterest = [[UIImageView alloc] init];
//        if (self.view == PointOfInterest){
//            PointOfInterest.frame = CGRectMake(100, 400, 50, 50);
//        }
//        else {
//        [self.view addSubview:PointOfInterest];
//        PointOfInterest.image = [UIImage imageNamed:@"iconGpsPfeil.png"];
////        [PointOfInterest setFrame:CGRectMake(xPos, yPos, 50, 50)];
//        [PointOfInterest setFrame:InitPosition];
////        [PointOfInterest setCenter:BuildingPosition];
        
            _LocationPointer.image = [UIImage imageNamed:@"location-151669_640.png"];
//       Location Pointer from https: //pixabay.com/static/uploads/photo/2013/07/12/17/00/location-151669_960_720.png
            _LocationPointer.translatesAutoresizingMaskIntoConstraints = true;
            
       //---ohne switch case--------
        
        Destination = [Buildings objectAtIndex:indexPath.row];
        xPosition = [Destination objectAtIndex:1];
        yPosition = [Destination objectAtIndex:2];
        xPosA = [xPosition floatValue];
        yPosA = [yPosition floatValue];

        _LocationPointer.frame = CGRectMake(xPosA, yPosA, 30, 60);
        _LocationPointer.hidden = false;
        _MapImage.hidden = false;
        OverviewTableView.hidden = true;
        BuildingsTableView.hidden = true;
        //_Button.selected = true;
//        _Button.accessibilityElementIsFocused;
      //  _Button; animated = YES;
        _MapImage.alpha = 1;

       
//        switch (indexPath.row) {
//            case 0:
//                Destination = [GebA objectAtIndex:indexPath.row];
//                xPosition = [Destination objectAtIndex:1];
//                yPosition = [Destination objectAtIndex:2];
////                BuildingPosition = CGPointMake(300, 300);
////                _LocationPointer.frame = CGRectMake(100, 100, 50, 50);
//                break;
//            case 1:
////                 *xPos = 200;
////                yPos = 200;
//                 _LocationPointer.frame = CGRectMake(200, 200, 50, 50);
//                 [BuildingsTableView reloadData];
//
//                break;
//            case 2:
////                xPos = 300;
////                yPos = 300;
//                 _LocationPointer.frame = CGRectMake(300, 300, 50, 50);
//                 [BuildingsTableView reloadData];
//
//                break;
////            case 3:
////                xPos = 400;
////                yPos = 400;
////                 [BuildingsTableView reloadData];
////                break;
////            case 4:
////                xPos = 500;
////                yPos = 500;
//            default:
//                break;
//        }
//        if (self.view == _LocationPointer){
//            
// //           _LocationPointer.center = CGPointMake(xPos, yPos);
//        }
//        
//        else{
//            xPosA = [xPosition floatValue];
//        //  _LocationPointer.frame = CGRectMake(xPosA, yPos, 50, 50);
//        }
//            [BuildingsTableView reloadData];
//        BuildingPosition = CGPointMake(xPos, yPos);
//        PointOfInterest.translatesAutoresizingMaskIntoConstraints = true;
//        [PointOfInterest setCenter:BuildingPosition];
//    
    
    }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//
//- (IBAction)SelectBuilding:(id)sender {
}


@end
