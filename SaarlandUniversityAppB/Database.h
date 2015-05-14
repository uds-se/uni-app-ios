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
/*-(NSMutableArray *)getPointsOfInterestForIDs:(NSArray* ) IDs;*/
-(NSMutableArray *)getPointsOfInterestForIDsAndCampus:(NSArray* ) IDs campus:(NSString *) campusName;
/*-(NSMutableArray *)getPointsOfInterestForCategorieWithID:(int) ID;*/
-(NSMutableArray *)getPointsOfInterestForCategorieWithIDAndCampus:(int) ID campus:(NSString *) campusName;
-(NSMutableArray *)getPointsOfInterestForCategorie:(NSString*) categorie;
/*-(NSMutableArray *)getAllCategorieIDs;*/
-(NSMutableArray *)getAllCategorieIDsForCampus:(NSString *) campus;
/*-(NSMutableArray *)getAllCategorieTitles;*/
-(NSMutableArray *)getAllCategorieTitlesForCampus:(NSString *) campus;
-(NSArray*) getArrayOfArraysWithTitlesAndIDsOfPOIForCategorieID:(int) ID;
+(NSString *)changeFormatOfString:(NSString *) key;
-(NSString *)replaceAccentedCharacters:(NSString *) key;
-(BOOL)isKeyACategorie:(NSString *) key;
/*-(NSMutableArray *)getPointsOfInterestPartialMatchedForSearchKey:(NSString *) searchKey;*/
-(NSMutableArray *)getPointsOfInterestPartialMatchedForSearchKeyAndCampus:(NSString *) searchKey campus:(NSString *) campusName;
/*-(NSMutableArray *)getPointsOfInterestWhereOneOfSearchKeysMatchesKey:(NSString *) key;*/
-(NSMutableArray *)getPointsOfInterestWhereOneOfSearchKeysMatchesKeyAndCampus:(NSString *) key campus:(NSString *) campusName;


//-(void)transformPlistToSQL;

@end
