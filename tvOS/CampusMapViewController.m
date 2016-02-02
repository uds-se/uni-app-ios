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
#import "TFHpple.h"

@interface CampusMapViewController ()

@end


@implementation CampusMapViewController
@synthesize OverviewTableView;
@synthesize BuildingsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    Campus = [defaults objectForKey:@"campus_selected"];
    if ([Campus  isEqual: @"hom"]){
    
        _MapImage.image = [UIImage imageNamed:@"Campus_Homburg.png"];
        _Button.hidden = true;
        _CurrentLocationPointer.hidden = true;
        _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
    }
    else {
        _MapImage.image = [UIImage imageNamed:@"campus.png"];
    }
    
    _LocationPointer.hidden = true;
    OverviewTableView.hidden = true;
    BuildingsTableView.hidden = true;
//    _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];


    
//    
    BuildOverview = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", nil];
  
    InitPosition = CGRectMake(100, 100, 50, 50);
    

    
    NSArray *A11 = @[@"A1 1", @775.0f, @355.1f];
    NSArray *A12 = @[@"A1 2", @775.0f, @390.0f];
    NSArray *A13 = @[@"A1 3", @775.0f, @430.0f];
    NSArray *A14 = @[@"A1 4", @770.0f, @455.0f];
    NSArray *A15 = @[@"A1 5", @775.0f, @490.0f];
    NSArray *A17 = @[@"A1 5", @775.0f, @490.0f];
    NSArray *A18 = @[@"A1 5", @775.0f, @490.0f];
    
    NSArray *A22 = @[@"A2 2", @775.0f, @490.0f];
    NSArray *A23 = @[@"A2 3", @775.0f, @490.0f];
    NSArray *A24 = @[@"A2 4", @775.0f, @490.0f];
 
    NSArray *A31 = @[@"A3 1", @775.0f, @490.0f];
    NSArray *A32 = @[@"A3 2", @775.0f, @490.0f];
    NSArray *A33 = @[@"A3 3", @775.0f, @490.0f];
    
    NSArray *A41 = @[@"A4 1", @775.0f, @490.0f];
    NSArray *A42 = @[@"A4 2", @775.0f, @490.0f];
    NSArray *A43 = @[@"A4 3", @775.0f, @490.0f];
    NSArray *A44 = @[@"A4 4", @775.0f, @490.0f];
    
    NSArray *A51 = @[@"A5 1", @775.0f, @490.0f];
    NSArray *A52 = @[@"A5 2", @775.0f, @490.0f];
    NSArray *A53 = @[@"A5 3", @775.0f, @490.0f];
    NSArray *A54 = @[@"A5 4", @775.0f, @490.0f];
    
    
    BuildA = [[NSArray alloc] initWithObjects:A11, A12, A13, A14, A15, A17, A18, A22, A23, A24, A31, A32, A33, A41, A42, A43, A44, A51, A52, A53, A54, nil];

    NSArray *B11 = @[@"B1 1", @100.0f, @100.1f];
    NSArray *B12 = @[@"B1 2", @200.0f, @200.0f];
    NSArray *B13 = @[@"B1 3", @300.0f, @300.0f];
    NSArray *B21 = @[@"B1 4", @400.0f, @400.0f];
    NSArray *B22 = @[@"B1 5", @500.0f, @500.0f];
    NSArray *B31 = @[@"B1 6", @500.0f, @500.0f];
    BuildB = [[NSArray alloc] initWithObjects:B11, B12, B13, B21, B22, B31, nil];
    
    
    NSArray *E11 = @[@"E1 1", @775.0f, @355.1f];
    NSArray *E12 = @[@"E1 2", @775.0f, @390.0f];
    NSArray *E13 = @[@"E1 3", @775.0f, @430.0f];
    NSArray *E14 = @[@"E1 4", @770.0f, @455.0f];
    NSArray *E15 = @[@"E1 5", @775.0f, @490.0f];
    NSArray *E16 = @[@"E1 6", @775.0f, @490.0f];
    NSArray *E17 = @[@"E1 7", @775.0f, @490.0f];
    
    NSArray *E21 = @[@"E2 1", @775.0f, @355.1f];
    NSArray *E22 = @[@"E2 2", @775.0f, @390.0f];
    NSArray *E23 = @[@"E2 3", @775.0f, @430.0f];
    NSArray *E24 = @[@"E2 4", @770.0f, @455.0f];
    NSArray *E25 = @[@"E2 5", @775.0f, @490.0f];
    NSArray *E26 = @[@"E2 6", @775.0f, @490.0f];
    NSArray *E27 = @[@"E2 7", @775.0f, @490.0f];
    NSArray *E28 = @[@"E2 8", @775.0f, @490.0f];
    NSArray *E29 = @[@"E2 9", @775.0f, @490.0f];
    
    NSArray *E31 = @[@"E3 1", @775.0f, @490.0f];
    NSArray *E71 = @[@"E7 1", @775.0f, @490.0f];
    NSArray *E72 = @[@"E7 2", @775.0f, @490.0f];
    NSArray *E81 = @[@"E8 1", @775.0f, @490.0f];
    NSArray *E91 = @[@"E9 1", @1840.0f, @20.0f];
    BuildE = @[E11, E12, E13, E14, E15, E16, E17, E21, E22, E21, E22, E23, E24, E25, E26, E27, E28, E29, E31, E71, E72, E81, E91];
    BuildC = BuildD = BuildB;
    
    
    //    current Location
    


    Location = [defaults objectForKey:@"building_selected"];
    bool isBuild = true;
    int i=0;
    
    if ([Location containsString:@"A"]) {
        Temp = BuildA;
    }
    else if ([Location containsString:@"B"]){
        Temp = BuildB;
    }
    else if ([Location containsString:@"C"]){
        Temp = BuildC;
    }
    else if ([Location containsString:@"D"]){
        Temp = BuildD;
    }
    else if ([Location containsString:@"E"]){
        Temp = BuildE;
    }
    else {
        Location = 0;
    }
        
    if (Location != 0) {
        
        
  
        while (isBuild ) {
            
            isBuild =! [[Temp objectAtIndex:i ]  containsObject:Location];
            
            i++;
    }
  
    _CurrentLocationPointer.translatesAutoresizingMaskIntoConstraints = true;
      
        NSNumber *x;
        NSNumber *y;

        x = [[Temp objectAtIndex:i-1]objectAtIndex:1];
        y = [[Temp objectAtIndex:i-1]objectAtIndex:2];

        float xTemp = [x floatValue];
        float yTemp = [y floatValue];

    _CurrentLocationPointer.frame = CGRectMake(xTemp, yTemp, 40, 64);
    _CurrentLocationPointer.image = [UIImage imageNamed:@"pin_green"];
        
           }
    else {
        _CurrentLocationPointer.hidden = true;
    }
    
    


    
    
    
//    do {
//        blabla =! [[BuildA objectAtIndex:i ]  containsObject:@"A1 5"];
//        
//        i++;
//
//    } while (blabla);
//    NSUInteger x = [BuildA [objectAtIndex:0]indexOfObject : @"A1 5"];
    
    
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
                Buildings = BuildA;
             //   BuildingsTableView.allowsSelection = true ;
//                BuildingsTableView.accessibilityElementIsFocused;
            
                break;
            case 1:
//                Buildings = BuildingsB;
               // BuildingsTableView.allowsSelection = YES;
                Buildings = BuildB;
                break;
            case 2:
                Buildings = BuildC;
               // BuildingsTableView.allowsSelection = YES;
                break;
            case 3:
                Buildings = BuildD;
               // BuildingsTableView.allowsSelection = YES;
                break;
            case 4:
                Buildings = BuildE;
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
        
            _LocationPointer.image = [UIImage imageNamed:@"pin_red"];
//       Location Pointer from https: //pixabay.com/static/uploads/photo/2013/07/12/17/00/location-151669_960_720.png
            _LocationPointer.translatesAutoresizingMaskIntoConstraints = true;
            
       //---ohne switch case--------
        
        Destination = [Buildings objectAtIndex:indexPath.row];
        xPosition = [Destination objectAtIndex:1];
        yPosition = [Destination objectAtIndex:2];
        xPosA = [xPosition floatValue];
        yPosA = [yPosition floatValue];

        _LocationPointer.frame = CGRectMake(xPosA, yPosA, 40, 64);
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
