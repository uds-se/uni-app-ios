//
//  Database.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 12.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "PointOfInterest.h"

@interface Database : NSObject

-(BOOL) openDb;
-(void) closeDb;
-(NSMutableArray *)getPointsOfInterestForIDs:(NSArray* ) IDs;
-(NSMutableArray *)getPointsOfInterestForCategorieWithID:(int) ID;
-(NSMutableArray *)getPointsOfInterestForCategorie:(NSString*) categorie;
-(NSMutableArray *)getAllCategorieIDs;
-(NSMutableArray *)getAllCategorieTitles;
-(NSArray*) getArrayOfArraysWithTitlesAndIDsOfPOIForCategorieID:(int) ID;
+(NSString *)changeFormatOfString:(NSString *) key;
-(BOOL)isKeyACategorie:(NSString *) key;
-(NSMutableArray *)getPointsOfInterestPartialMatchedForSearchKey:(NSString *) searchKey;
-(NSMutableArray *)getPointsOfInterestWhereOneOfSearchKeysMatchesKey:(NSString *) key;


//-(void)transformPlistToSQL;

@end
