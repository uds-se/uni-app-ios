//
//  DetailedPOIListViewController.m
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 24.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "DetailedPOIListViewController.h"
#import "MapsViewController.h"


@interface DetailedPOIListViewController ()

@end

const int maxAmountForUngroupedList = 15;

@implementation DetailedPOIListViewController

@synthesize arrayOfArraysWithNames, delegate, indexArray, myTableView, selectedCampus;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.categorieTitle;
    
    NSArray* disablePinAllForCatIDArr = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
    // If categorieID == 1 (Buildings) then remove the pin all button
    if (![disablePinAllForCatIDArr containsObject:[NSNumber numberWithInt:self.categorieID]]) {
        UIBarButtonItem *btnPinAll = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pin All",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pinAllPressed)];
        [self.navigationItem setRightBarButtonItem:btnPinAll];
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
    
    self.isGrouped = NO;
    poiArray = [((MapsViewController*) self.delegate).database getPointsOfInterestForCategorieWithIDAndCampus:self.categorieID campus:self.selectedCampus].mutableCopy;
    [poiArray sortUsingSelector:@selector(compare:)];

    
    //if poiArray.count > maxAmountForUngroupedList, the list will automatically be grouped into sections (A, B, C...)
    if (poiArray.count > maxAmountForUngroupedList ) {
        self.isGrouped =YES;
        arrayOfArraysWithNames = [((MapsViewController*) self.delegate).database getArrayOfArraysWithTitlesAndIDsOfPOIForCategorieID:self.categorieID];
        indexArray = [[NSMutableArray alloc] init];
        NSString *indexName;
        NSRange range = NSMakeRange(0, 1);
        for (int i = 0; i<arrayOfArraysWithNames.count; i++) {
            //get first element of each section
            indexName = [[(NSArray*)[arrayOfArraysWithNames objectAtIndex:i] objectAtIndex:0] objectAtIndex:0];
            // get first letter of each section
            NSString *character =      [indexName substringWithRange:range] ;
            [indexArray addObject:character];
        }
    }
}


-(void)pinAllPressed{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.delegate pinCategorieWithID:self.categorieID];
    });
        
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    for( int i=0;i< viewContrlls.count;i++){
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[MapsViewController class]] ){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isGrouped) {
        return indexArray;
    }else {
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.isGrouped) {
        return [indexArray indexOfObject:title];
    }else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    if (self.isGrouped) {
        return [indexArray objectAtIndex:section];
    }else{
        return nil;
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isGrouped) {
        return arrayOfArraysWithNames.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isGrouped) {
        return ((NSArray*) [arrayOfArraysWithNames objectAtIndex:section]).count;
    }else{
        return poiArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell.textLabel.backgroundColor = [UIColor clearColor];

    if (self.isGrouped) {
        cell.textLabel.text = [[[arrayOfArraysWithNames objectAtIndex: indexPath.section] objectAtIndex: indexPath.row] objectAtIndex:0];
        
        cell.tag = [[[[arrayOfArraysWithNames objectAtIndex: indexPath.section] objectAtIndex: indexPath.row] objectAtIndex:1] integerValue];

    }else{
        cell.textLabel.text = ((PointOfInterest*)[poiArray objectAtIndex:indexPath.row]).title;
        
        cell.tag = ((PointOfInterest*)[poiArray objectAtIndex:indexPath.row]).ID;
    }
    [cell.textLabel setNumberOfLines:2];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    CGRect cg = [cell.textLabel frame];
    [cell.textLabel setFrame:CGRectMake(cg.origin.x, cg.origin.y-2, cg.size.width, cg.size.height+6)];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // return 50;
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [self.delegate pinPOIWithID:cell.tag];
    });
   
    
    NSArray *viewContrlls=[[self navigationController] viewControllers];
    for( int i=0;i< viewContrlls.count;i++){
        id obj=[viewContrlls objectAtIndex:i];
        if([obj isKindOfClass:[MapsViewController class]] ){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
}

@end
