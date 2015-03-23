//
//  CategorieTableViewController.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 13.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "DetailedPOIListViewController.h"
#import "CategorieCell.h"

@protocol pinCategorieToMap <NSObject>
    -(void)pinCategorieWithKey:(NSString *)categorie;
@end


@interface CategorieTableViewController : UITableViewController{
    __weak id < pinCategorieToMap> delegate;
    
}

@property (nonatomic) NSString* selectedCampus;
@property (nonatomic,weak) id  delegate;
@property (nonatomic) NSArray* categoriesArr;
@property (nonatomic) NSArray* IDArr;


@end
