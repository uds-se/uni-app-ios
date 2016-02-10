//
//  CampusMapViewController.m
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "CampusMapViewController.h"
#import "TFHpple.h"

@interface CampusMapViewController ()

@end


@implementation CampusMapViewController
@synthesize OverviewTableView;
@synthesize BuildingsTableView;
@synthesize Person;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    SelectedCampus = [defaults objectForKey:@"campus_selected"];
    


    
    _CurrentLocationPointer.translatesAutoresizingMaskIntoConstraints = true;
    _DestinationPointer.translatesAutoresizingMaskIntoConstraints = true;
    _Button.translatesAutoresizingMaskIntoConstraints = true;
    _LocationImage.translatesAutoresizingMaskIntoConstraints = true;
    
    _DestinationPointer.hidden = true;
    OverviewTableView.hidden = true;
    BuildingsTableView.hidden = true;
    _DestinationLabel.hidden = true;
    _LocationImage.image =[UIImage imageNamed:@"pin_green.png"];
    _DestinationImage.hidden = true;
    [_Button setTitle:NSLocalizedStringFromTable(@"Search Building", @"tvosLocalisation", nil) forState:(UIControlStateNormal)];
    _Button.hidden = false;
    _DestinationPointer.image = [UIImage imageNamed:@"pin_red"];
    //       Location Pointer from https: //pixabay.com/static/uploads/photo/2013/07/12/17/00/location-151669_960_720.png

    
//    _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];


//Position offset for buildings
    xOffset = 20;
    yOffset = 58;
    PinSizeX = 40;
    PinSizeY = 64;


    
    
//BUILDINGS
    
    BuildOverview = @[@"A", @"B", @"C", @"D", @"E"];
    
    NSArray *A11 = @[@"A1 1", @798.0f, @405.0f];
    NSArray *A12 = @[@"A1 2", @798.0f, @442.0f];
    NSArray *A13 = @[@"A1 3", @795.0f, @480.0f];
    NSArray *A14 = @[@"A1 4", @792.0f, @520.0f];
    NSArray *A15 = @[@"A1 5", @795.0f, @550.0f];
    NSArray *A17 = @[@"A1 7", @767.0f, @622.0f];
    NSArray *A18 = @[@"A1 8", @750.0f, @530.0f];
    NSArray *A22 = @[@"A2 2", @863.0f, @427.0f];
    NSArray *A23 = @[@"A2 3", @863.0f, @519.0f];
    NSArray *A24 = @[@"A2 4", @863.0f, @613.0f];
    NSArray *A31 = @[@"A3 1", @909.0f, @447.0f];
    NSArray *A32 = @[@"A3 2", @961.0f, @450.0f];
    NSArray *A33 = @[@"A3 3", @935.0f, @404.0f];
    NSArray *A41 = @[@"A4 1", @979.0f, @622.0f];
    NSArray *A42 = @[@"A4 2", @938.0f, @601.0f];
    NSArray *A43 = @[@"A4 3", @901.0f, @612.0f];
    NSArray *A44 = @[@"A4 4", @938.0f, @575.0f];
    NSArray *A51 = @[@"A5 1", @1016.0f, @429.0f];
    NSArray *A52 = @[@"A5 2", @1016.0f, @485.0f];
    NSArray *A53 = @[@"A5 3", @1019.0f, @518.0f];
    NSArray *A54 = @[@"A5 4", @1016.0f, @608.0f];

    BuildA = @[A11, A12, A13, A14, A15, A17, A18, A22, A23, A24, A31, A32, A33, A41, A42, A43, A44, A51, A52, A53, A54];
    
    NSArray *B11 = @[@"B1 1", @773.0f, @725.1f];
    NSArray *B12 = @[@"B1 2", @746.0f, @690.0f];
    NSArray *B21 = @[@"B2 1", @863.0f, @665.0f];
    NSArray *B22 = @[@"B2 2", @918.0f, @665.0f];
    NSArray *B31 = @[@"B3 1", @985.0f, @724.0f];
    NSArray *B32 = @[@"B3 2", @953.0f, @771.0f];
    NSArray *B33 = @[@"B3 3", @972.0f, @754.0f];
    NSArray *B41 = @[@"B4 1", @874.0f, @818.0f];
    NSArray *B42 = @[@"B4 2", @817.0f, @901.0f];
    NSArray *B43 = @[@"B4 3", @817.0f, @877.0f];
    NSArray *B44 = @[@"B4 4", @870.0f, @896.0f];
    NSArray *B51 = @[@"B5 1", @784.0f, @820.0f];
    NSArray *B52 = @[@"B5 2", @731.0f, @797.0f];
    NSArray *B61 = @[@"B6 1", @706.0f, @804.0f];
    NSArray *B62 = @[@"B6 2", @706.0f, @792.0f];
    NSArray *B63 = @[@"B6 3", @693.0f, @771.0f];
    NSArray *B64 = @[@"B6 4", @693.0f, @759.0f];
    NSArray *B65 = @[@"B6 5", @680.0f, @738.0f];
    NSArray *B66 = @[@"B6 6", @680.0f, @726.0f];
    NSArray *B68 = @[@"B6 8", @622.0f, @728.0f];
    NSArray *B71 = @[@"B7 1", @659.0f, @671.0f];
    NSArray *B72 = @[@"B7 2", @659.0f, @684.0f];
    NSArray *B73 = @[@"B7 3", @659.0f, @700.0f];
    NSArray *B81 = @[@"B8 1", @850.0f, @955.0f];
    NSArray *B82 = @[@"B8 2", @821.0f, @966.0f];
    NSArray *B83 = @[@"B8 3", @785.0f, @988.0f];
    
    BuildB = @[B11, B12, B21, B22, B31, B32, B33, B41, B42, B43, B44, B51, B52, B61, B62, B63,B64, B65, B66, B68, B71, B72, B73, B81, B82, B83];
    
    NSArray *C11 = @[@"C1 1", @1055.0f, @407.0f];
    NSArray *C12 = @[@"C1 2", @1055.0f, @448.0f];
    NSArray *C13 = @[@"C1 3", @1070.0f, @485.0f];
    NSArray *C21 = @[@"C2 1", @1115.0f, @443.0f];
    NSArray *C22 = @[@"C2 2", @1157.0f, @440.0f];
    NSArray *C23 = @[@"C2 3", @1213.0f, @441.0f];
    NSArray *C31 = @[@"C3 1", @1067.0f, @535.0f];
    NSArray *C41 = @[@"C4 1", @1228.0f, @516.0f];
    NSArray *C42 = @[@"C4 2", @1151.0f, @515.0f];
    NSArray *C43 = @[@"C4 3", @1183.0f, @519.0f];
    NSArray *C44 = @[@"C4 4", @1116.0f, @530.0f];
    NSArray *C45 = @[@"C4 5", @1120.0f, @491.0f];
    NSArray *C46 = @[@"C4 6", @1205.0f, @547.0f];
    NSArray *C51 = @[@"C5 1", @1015.0f, @696.0f];
    NSArray *C52 = @[@"C5 2", @1109.0f, @690.0f];
    NSArray *C53 = @[@"C5 3", @1057.0f, @631.0f];
    NSArray *C54 = @[@"C5 4", @1134.0f, @646.0f];
    NSArray *C55 = @[@"C5 5", @1059.0f, @584.0f];
    NSArray *C62 = @[@"C6 2", @1232.0f, @565.0f];
    NSArray *C63 = @[@"C6 3", @1205.0f, @573.0f];
    NSArray *C64 = @[@"C6 4", @1189.0f, @626.0f];
    NSArray *C65 = @[@"C6 5", @1222.0f, @615.0f];
    NSArray *C71 = @[@"C7 1", @1023.0f, @782.0f];
    NSArray *C72 = @[@"C7 2", @1002.0f, @817.0f];
    NSArray *C73 = @[@"C7 3", @1012.0f, @804.0f];
    NSArray *C74 = @[@"C7 4", @1045.0f, @843.0f];
    NSArray *C75 = @[@"C7 5", @1070.0f, @774.0f];
    NSArray *C76 = @[@"C7 6", @1115.0f, @757.0f];
    NSArray *C77 = @[@"C7 7", @1090.0f, @768.0f];
    NSArray *C81 = @[@"C8 1", @1177.0f, @694.0f];
    NSArray *C82 = @[@"C8 2", @1221.0f, @692.0f];
    NSArray *C83 = @[@"C8 3", @1233.0f, @666.0f];
    NSArray *C91 = @[@"C9 1", @1318.0f, @577.0f];
    NSArray *C92 = @[@"C9 2", @1409.0f, @585.0f];
    NSArray *C93 = @[@"C9 3", @1394.0f, @669.0f];
    
    BuildC = @[C11, C12, C13,C21, C22, C23, C31, C41, C42, C43, C44, C45, C46, C51, C52, C53, C54, C55, C62, C63, C64, C65, C71, C72, C73, C74, C75, C76, C77, C81, C82, C83, C91, C92, C93];
    
    NSArray *D11 = @[@"D1 1", @679.0f, @455.0f];
    NSArray *D12 = @[@"D1 2", @778.0f, @352.0f];
    NSArray *D21 = @[@"D2 1", @875.0f, @319.0f];
    NSArray *D22 = @[@"D2 2", @937.0f, @325.0f];
    NSArray *D23 = @[@"D2 3", @982.0f, @299.0f];
    NSArray *D24 = @[@"D2 4", @904.0f, @302.0f];
    NSArray *D25 = @[@"D2 5", @940.0f, @286.0f];
    NSArray *D31 = @[@"D3 1", @1037.0f, @341.0f];
    NSArray *D32 = @[@"D3 2", @1083.0f, @309.0f];
    NSArray *D33 = @[@"D3 3", @1050.0f, @275.0f];
    NSArray *D41 = @[@"D4 1", @1178.0f, @267.0f];
    NSArray *D43 = @[@"D4 3", @1202.0f, @211.0f];
    NSArray *D44 = @[@"D4 4", @1188.0f, @217.0f];
    NSArray *D45 = @[@"D4 5", @1219.0f, @353.0f];
    NSArray *D51 = @[@"D5 1", @1234.0f, @172.0f];
    
    BuildD = @[D11, D12, D21, D22, D23, D24, D25, D31, D32, D33, D41, D43, D44, D45, D51];
    
    NSArray *E11 = @[@"E1 1", @1332.0f, @304.1f];
    NSArray *E12 = @[@"E1 2", @1331.0f, @280.0f];
    NSArray *E13 = @[@"E1 3", @1321.0f, @237.0f];
    NSArray *E14 = @[@"E1 4", @1394.0f, @230.0f];
    NSArray *E15 = @[@"E1 5", @1426.0f, @285.0f];
    NSArray *E16 = @[@"E1 6", @1259.0f, @297.0f];
    NSArray *E17 = @[@"E1 7", @1294.0f, @331.0f];
    NSArray *E21 = @[@"E2 1", @1471.0f, @349.1f];
    NSArray *E22 = @[@"E2 2", @1367.0f, @373.0f];
    NSArray *E23 = @[@"E2 3", @1414.0f, @402.0f];
    NSArray *E24 = @[@"E2 4", @1326.0f, @404.0f];
    NSArray *E25 = @[@"E2 5", @1365.0f, @443.0f];
    NSArray *E26 = @[@"E2 6", @1317.0f, @474.0f];
    NSArray *E27 = @[@"E2 7", @1315.0f, @526.0f];
    NSArray *E28 = @[@"E2 8", @1291.0f, @550.0f];
    NSArray *E29 = @[@"E2 9", @1276.0f, @557.0f];
    NSArray *E31 = @[@"E3 1", @1553.0f, @215.0f];
    NSArray *E71 = @[@"E7 1", @1708.0f, @167.0f];
    NSArray *E72 = @[@"E7 2", @1649.0f, @191.0f];
    NSArray *E81 = @[@"E8 1", @1744.0f, @226.0f];
    NSArray *E91 = @[@"E9 1", @1862.0f, @99.0f];
    
    BuildE = @[E11, E12, E13, E14, E15, E16, E17, E21, E22, E21, E22, E23, E24, E25, E26, E27, E28, E29, E31, E71, E72, E81, E91];
  

    
    // staff search inclusion dummy
    
    //Person = @"E9 2";
//    Person = 0;
    if (Person ==0) {
        
    }
    else{

        NSArray *PersonBuilding = [self getBuildingInfo:Person];
        [self setDestination:PersonBuilding];

    }
    
//Current Location
    
    SelectedLocation = [defaults objectForKey:@"building_selected"];
    NSArray *CurrentBuilding = [self getBuildingInfo: SelectedLocation];
    
    [self setCurrentLocation:CurrentBuilding];

//Campus selection
    
    [self SelectCampus:SelectedCampus];
  
    
} 


// evaluates, which campus is selected
-(void) SelectCampus: (NSString*) Campus
{
    if ([Campus  isEqual: @"hom"]){
        _MapImage.image = [UIImage imageNamed:@"campus_homburg.png"];
        _Button.hidden = true;
        _CurrentLocationPointer.hidden = true;
//        _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
        _LocationImage.hidden = true;
        _LocationLabel.hidden = true;
        _DestinationImage.hidden = true;
        _DestinationLabel.hidden = true;
        _DestinationPointer.hidden = true;
        Person = 0;
        
        
    }
    else {
        _MapImage.image = [UIImage imageNamed:@"campus.png"];
    }
}


// set the pin for the building selected in the setting
-(void) setCurrentLocation: (NSArray*) Loc
{
    
    if (Loc != 0) {
        
        _CurrentLocationPointer.frame = CGRectMake(getCoordinates(Loc,1)-xOffset, getCoordinates(Loc,2)-yOffset, PinSizeX, PinSizeY);
        _CurrentLocationPointer.image = [UIImage imageNamed:@"pin_green"];
        _LocationLabel.text = [NSLocalizedStringFromTable(@"Your location", @"tvosLocalisation", nil) stringByAppendingString:[Loc objectAtIndex:0]];
    
    }
    else {
        _CurrentLocationPointer.hidden = true;
        _LocationLabel.text = NSLocalizedStringFromTable(@"No location configured", @"tvosLocalisation", nil);
    }
    
}

// get cordinates as float from an array
float getCoordinates (NSArray *Blablubb, int i)
{
    id Temp = [Blablubb objectAtIndex:i];
    float Coordinate = [Temp floatValue];
    return Coordinate;
}


//set pointer for selected destination
-(void) setDestination: (NSArray*) Dest
{
    if (Dest ==0) {
        _DestinationLabel.text = NSLocalizedStringFromTable(@"Building not found", @"tvosLocalisation", nil);
        _DestinationLabel.hidden = false;
        _DestinationImage.image = [UIImage imageNamed:@"pin_red.png"];
        _DestinationImage.hidden = false;
        _DestinationPointer.hidden = true;
    }
    else {
        
        
        _DestinationLabel.text = [NSLocalizedStringFromTable(@"Destination", @"tvosLocalisation", nil) stringByAppendingString:[Dest objectAtIndex:0]];
        _DestinationLabel.hidden = false;
        _DestinationImage.image = [UIImage imageNamed:@"pin_red.png"];
        _DestinationImage.hidden = false;
        _DestinationPointer.frame = CGRectMake(getCoordinates(Dest,1)-xOffset, getCoordinates(Dest,2)-yOffset, PinSizeX, PinSizeY);
        _DestinationPointer.hidden = false;
    }
}


// searches buildings by name and returns name and coordinates in an array
- (NSArray*)getBuildingInfo: (NSString*) BuildingName
{
    NSArray *TempBuilding;

    
    
    if ([BuildingName containsString:@"A"]) {
        TempBuilding = BuildA;
    }
    else if ([BuildingName containsString:@"B"]){
        TempBuilding = BuildB;
    }
    else if ([BuildingName containsString:@"C"]){
        TempBuilding = BuildC;
    }
    else if ([BuildingName containsString:@"D"]){
        TempBuilding = BuildD;
    }
    else if ([BuildingName containsString:@"E"]){
        TempBuilding = BuildE;
    }
    else {
        TempBuilding = 0;
    }
    
    if (TempBuilding != 0) {
        
        bool isBuild = true;
        int i=0;
        NSUInteger j = TempBuilding.count;
        
    
        while (isBuild == true && i<=j) {
            
            if (i>=j) {
                return 0;
            }
            else {
            isBuild =! [[TempBuilding objectAtIndex:i ]  containsObject:BuildingName];
            
            i++;
            }
        }
            NSArray *BuildingInfo = @[[[TempBuilding objectAtIndex:i-1]objectAtIndex:0], [[TempBuilding objectAtIndex:i-1]objectAtIndex:1], [[TempBuilding objectAtIndex:i-1]objectAtIndex:2]];
            
            
            return BuildingInfo;
        }

   
    else {
        return 0;
    }

}

// shows the building list
- (IBAction)SearchButton:(id)sender
{
    OverviewTableView.hidden = false;
    BuildingsTableView.hidden = false;
    _MapImage.alpha = 0.2;
    _MapImage.opaque = NO;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



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

        
        cell.textLabel.text = [[Buildings objectAtIndex:indexPath.row]objectAtIndex:0];
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == [self OverviewTableView]) {
        OverviewCurrentlyAt = indexPath;
        switch (indexPath.row) {
            case 0:
                Buildings = BuildA;
                break;
            case 1:
                Buildings = BuildB;
                break;
            case 2:
                Buildings = BuildC;
                  break;
            case 3:
                Buildings = BuildD;
                 break;
            case 4:
                Buildings = BuildE;
                  default:
                break;
        }
        [BuildingsTableView reloadData];
        
    }
    else {
      

        
        [self setDestination:[Buildings objectAtIndex:indexPath.row]];
        OverviewTableView.hidden = true;
        BuildingsTableView.hidden = true;
        _MapImage.alpha = 1;
        
 
        
        
    }


/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

}


@end
