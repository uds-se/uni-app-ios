//
//  DetailedPOIListViewController.h
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 24.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"


@protocol detailedTableToMap <NSObject>
    -(void)pinCategorieWithID:(int)ID;
    -(void)pinPOIWithID:(int)ID;
@end

@interface DetailedPOIListViewController : UITableViewController{
    NSArray *arrayOfArraysWithNames;
    NSMutableArray *poiArray;
    __weak id < detailedTableToMap> delegate;
    NSMutableArray *indexArray;    
}

//MapsViewController is the delegate
@property (nonatomic,weak)id  delegate;

@property NSArray *arrayOfArraysWithNames;

@property NSMutableArray *indexArray;

@property NSString* categorieTitle;
@property (nonatomic) NSString* selectedCampus;

@property BOOL isGrouped;

@property int categorieID;

@property (nonatomic,retain) IBOutlet UITableView *myTableView;




@end
