//
//  Database.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 12.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "Database.h"

@implementation Database{
    sqlite3 *poiDB;
    NSString *dbPathString;
}

-(BOOL) openDb {
    // Den Pfad zur Documents-Directory in path speichern
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathString = [documentsDirectory stringByAppendingPathComponent:@"pointOfInterest.sqlite3"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Die Datenbank aus dem Bundle in die Documents-Directory kopieren
    NSString *pathInMainBundle = [[NSBundle mainBundle] pathForResource:@"pointOfInterest" ofType:@"sqlite3"];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        //NSLog(@"database not existing yet");
        [fileManager copyItemAtPath:pathInMainBundle toPath:dbPathString error:nil];
    }
    
    // Die Datenbank öffnen
    int result = sqlite3_open([dbPathString UTF8String], &poiDB);
    if (result != SQLITE_OK) {
        sqlite3_close(poiDB);
        NSLog(@"error opening database");
        return false;
    }
    //NSLog(@"opened database");
    return true;
}

-(void) closeDb {
    sqlite3_close(poiDB);
    //NSLog(@"closed database");
}

//CATEGORIE

//returns a PointOfInterest array
-(NSMutableArray *)getPointsOfInterestForCategorie:(NSString*) categorie{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    
    sqlite3_stmt *statement;
    PointOfInterest* poi;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT pointOfInterest.title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID FROM pointOfInterest,categorie  WHERE pointOfInterest.categorieID = categorie.ID AND categorie.key = '%s'", [categorie UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getPointOfInterestsForCategorie %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}

//returns a NSString array
/*-(NSMutableArray *)getAllCategorieTitles{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title FROM categorie"];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [result addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
        }
        sqlite3_finalize(statement);
    }else {
        NSLog(@"Prepare-error in getAllCategorieTitles %s", sqlite3_errmsg(poiDB));
    }
    
    [self closeDb];
    return result;
}
*/
-(NSMutableArray *)getAllCategorieTitlesForCampus:(NSString *) campus{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"select categorie.title from categorie, pointOfInterest where categorie.iD = pointOfInterest.categorieID and pointOfInterest.campus = '%s' group by categorie.title",[campus UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [result addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
        }
        sqlite3_finalize(statement);
    }else {
        NSLog(@"Prepare-error in getAllCategorieTitles %s", sqlite3_errmsg(poiDB));
    }
    
    [self closeDb];
    return result;

}

/*-(NSMutableArray *)getAllCategorieIDs{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT ID FROM categorie"];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [result addObject:[NSNumber numberWithInt:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]integerValue]]];
        }
        sqlite3_finalize(statement);
    }else {
        NSLog(@"Prepare-error in getAllCategorieIDs %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}
*/
-(NSMutableArray *)getAllCategorieIDsForCampus:(NSString *) campus{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT categorie.ID FROM categorie,pointOfInterest where categorie.ID = pointOfInterest.categorieID and pointOfInterest.campus = '%s' group by categorie.title",[campus UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [result addObject:[NSNumber numberWithInt:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]integerValue]]];
        }
        sqlite3_finalize(statement);
    }else {
        NSLog(@"Prepare-error in getAllCategorieIDsForCampus %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}


-(BOOL)isKeyACategorie:(NSString *) key{
    [self openDb];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT key FROM categorie  WHERE categorie.key = '%s'", [key UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    BOOL res = false;
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            res = true;
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in isKeyCategorie %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return res;
}

/*-(NSMutableArray *)getPointsOfInterestForCategorieWithID:(int) ID{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID FROM pointOfInterest  WHERE pointOfInterest.categorieID = '%s'", [[NSString stringWithFormat:@"%d",ID] UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getPointsOfInterestForCategorieWithID %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}
*/
-(NSMutableArray *)getPointsOfInterestForCategorieWithIDAndCampus:(int) ID campus:(NSString *) campusName{

    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID FROM pointOfInterest  WHERE pointOfInterest.categorieID = '%s' AND pointOfInterest.campus = '%s' ORDER BY title ASC", [[NSString stringWithFormat:@"%d",ID] UTF8String], [[NSString stringWithFormat:@"%@",campusName] UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getPointsOfInterestForCategorieWithID %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;





}




//returns .... description
-(NSMutableArray *)getAllPOITitlesAndIDsForCategorieOrderdASCWithID:(int) ID{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,pointOfInterest.ID FROM pointOfInterest  WHERE pointOfInterest.categorieID = '%s' ORDER BY title ASC", [[NSString stringWithFormat:@"%d",ID] UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [result addObject:[NSArray arrayWithObjects:
                               [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)],
                               [NSNumber numberWithInt:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] integerValue]],nil]];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getAllPOITitlesAndIDsForCategorieOrderdASCWithID %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}



//POINTOFINTERESTS

/*
-(NSMutableArray* )getPointsOfInterestIncludingMappingForKey:(NSString*) key{
    
    NSMutableArray* result = [NSMutableArray new];
    
    //add mapped POIs
    sqlite3_stmt *statement;
    NSString *qStmtMapping = [NSString stringWithFormat:@"SELECT categorieID,pointofinterestID FROM mapping  WHERE keyToMap = '%s'", [key UTF8String]];
    const char *q_StmtMapping = [qStmtMapping UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_StmtMapping, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int mappedCatID = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue];
            int mappedPOIID = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] integerValue];
            
            if (mappedCatID >= 0) {
                [result addObjectsFromArray:[self getPointsOfInterestForCategorieWithID:mappedCatID]];
            }
            if (mappedPOIID >=0){
                [result addObjectsFromArray:[self getPointsOfInterestForIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:mappedPOIID]]]];
            }            
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getPointOfInterestsIncludingMappingForKey:  %s", sqlite3_errmsg(poiDB));
    }
    
    
    //add POIs
    [result addObjectsFromArray:[self getPointsOfInterestNotMappedForKey:key]];
    [result addObjectsFromArray:[self getPointsOfInterestForCategorie:key]];
    return result;

}
*/

//Searches POIs that partially match the title, subtitle or key of that POI
/*-(NSMutableArray *)getPointsOfInterestPartialMatchedForSearchKey:(NSString *) searchKey{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString* sKeyWithPercAtEnd = [searchKey stringByAppendingString:@"%"];
    
    NSString* sKeyWithPerAtBegEnd = [[@"% " stringByAppendingString:searchKey] stringByAppendingString:@"%"];
    
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID,categorieID FROM pointOfInterest  WHERE (title LIKE '%s' ) OR (subtitle LIKE '%s')  OR (searchkey LIKE '%s') OR ( title LIKE '%s' ) OR (subtitle LIKE '%s')  OR (searchkey LIKE '%s') ORDER BY title ASC" ,[sKeyWithPercAtEnd UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String]];
    
    //NSLog(@"'%s'",[qStmt UTF8String]);
    
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [poi setUTF8CategorieID:(char *)sqlite3_column_text(statement, 9)];
                        
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"getPointsOfInterestPartialMatchedForSearchKey %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}
*/

-(NSMutableArray *)getPointsOfInterestPartialMatchedForSearchKeyAndCampus:(NSString *) searchKey campus:(NSString *) campusName{

    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString* sKeyWithPercAtEnd = [searchKey stringByAppendingString:@"%"];
    
    NSString* sKeyWithPerAtBegEnd = [[@"% " stringByAppendingString:searchKey] stringByAppendingString:@"%"];
    
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID,categorieID FROM pointOfInterest  WHERE pointOfInterest.campus = '%s' AND ((title LIKE '%s' ) OR (subtitle LIKE '%s')  OR (searchkey LIKE '%s') OR ( title LIKE '%s' ) OR (subtitle LIKE '%s')  OR (searchkey LIKE '%s')) ORDER BY title ASC" ,[campusName UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String]];
    
    //NSLog(@"'%s'",[qStmt UTF8String]);
    
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [poi setUTF8CategorieID:(char *)sqlite3_column_text(statement, 9)];
            
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"getPointsOfInterestPartialMatchedForSearchKey %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;

}


//Searches POIs where the key is included in the searchKey colum
/*-(NSMutableArray *)getPointsOfInterestWhereOneOfSearchKeysMatchesKey:(NSString *) key{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString* sKeyWithPercAtEnd = [key stringByAppendingString:@"%"];
    
    NSString* sKeyWithPerAtBegEnd = [[@"% " stringByAppendingString:key] stringByAppendingString:@"%"];
    
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID,categorieID FROM pointOfInterest  WHERE (searchkey LIKE '%s') OR (searchkey LIKE '%s') OR (title LIKE '%s') OR (title LIKE '%s') ORDER BY title ASC" ,[sKeyWithPercAtEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String],[sKeyWithPercAtEnd UTF8String],[sKeyWithPerAtBegEnd UTF8String]];
        
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [poi setUTF8CategorieID:(char *)sqlite3_column_text(statement, 9)];
            
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"getPointsOfInterestWhereOneOfSearchKeysMatchesKey: %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;
}
*/
-(NSMutableArray *)getPointsOfInterestWhereOneOfSearchKeysMatchesKeyAndCampus:(NSString *) key campus:(NSString *) campusName{

    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    
    NSString *searchKey = [self replaceAccentedCharacters:key];
    printf("Search Key : %s",[searchKey cStringUsingEncoding:NSUTF8StringEncoding]);
    NSString* searchKeyWithPercAtEnd = [searchKey stringByAppendingString:@"%"];
    
    NSString* searchKeyWithPerAtBegEnd = [[@"% " stringByAppendingString:searchKey] stringByAppendingString:@"%"];
    
    NSString* sKeyWithPercAtEnd = [key stringByAppendingString:@"%"];
    
    NSString* sKeyWithPerAtBegEnd = [[@"% " stringByAppendingString:key] stringByAppendingString:@"%"];
    
//    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID,categorieID FROM pointOfInterest  WHERE pointOfInterest.campus= '%s' AND ((searchkey LIKE '%s') OR (searchkey LIKE '%s') OR (title LIKE '%s') OR (title LIKE '%s')) ORDER BY title ASC" , [campusName UTF8String],[searchKeyWithPercAtEnd UTF8String],[searchKeyWithPerAtBegEnd UTF8String],[[sKeyWithPercAtEnd.copy capitalizedString] UTF8String],[[sKeyWithPerAtBegEnd.copy capitalizedString] UTF8String]];
    
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID,categorieID FROM pointOfInterest  WHERE pointOfInterest.campus= '%s' AND ((searchkey LIKE '%s') OR (searchkey LIKE '%s') OR (searchkey LIKE '%s') OR (searchkey LIKE '%s') OR (title LIKE '%s') OR (title LIKE '%s')) ORDER BY title ASC" , [campusName UTF8String],[searchKeyWithPercAtEnd UTF8String],[searchKeyWithPerAtBegEnd UTF8String],[[sKeyWithPercAtEnd.copy capitalizedString] UTF8String],[[sKeyWithPerAtBegEnd.copy capitalizedString] UTF8String], [[sKeyWithPercAtEnd.copy capitalizedString] UTF8String],[[sKeyWithPerAtBegEnd.copy capitalizedString] UTF8String]];
    
    const char *q_Stmt = [qStmt UTF8String];
    
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
            [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
            [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
            [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
            [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
            [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
            [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
            [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
            [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
            [poi setUTF8CategorieID:(char *)sqlite3_column_text(statement, 9)];
            
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"getPointsOfInterestWhereOneOfSearchKeysMatchesKeyAndCampus: %s", sqlite3_errmsg(poiDB));
    }
    [self closeDb];
    return result;



}

-(NSMutableArray *)getPointsOfInterestForIDs:(NSArray* ) IDs{
    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    PointOfInterest* poi;
    if (IDs.count>=1) {
        NSString* idList = [NSString stringWithFormat:@"%d",[[IDs objectAtIndex:0] integerValue]];
        for (int i = 1; i<IDs.count; i++) {
            idList = [idList stringByAppendingString:[NSString stringWithFormat:@", %d",[[IDs objectAtIndex:i] integerValue]]];
        }
        //NSLog(@"ID list: %@", idList);
        
        NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID FROM pointOfInterest  WHERE pointOfInterest.ID = '%s'", [idList UTF8String]];
        const char *q_Stmt = [qStmt UTF8String];
        
        if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                poi = [PointOfInterest new];
                [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
                [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
                [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
                [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
                [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
                [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
                [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
                [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
                [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
                
                [result addObject:poi];
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"Prepare-error in getPointsOfInterestForIDs %s", sqlite3_errmsg(poiDB));
        }
    }
    [self closeDb];
    return result;
}

-(NSMutableArray *)getPointsOfInterestForIDsAndCampus:(NSArray* ) IDs campus:(NSString *) campusName{

    [self openDb];
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    PointOfInterest* poi;
    if (IDs.count>=1) {
        NSString* idList = [NSString stringWithFormat:@"%d",[[IDs objectAtIndex:0] integerValue]];
        for (int i = 1; i<IDs.count; i++) {
            idList = [idList stringByAppendingString:[NSString stringWithFormat:@", %d",[[IDs objectAtIndex:i] integerValue]]];
        }
        //NSLog(@"ID list: %@", idList);
        
        NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,pointOfInterest.ID FROM pointOfInterest  WHERE pointOfInterest.ID = '%s' AND pointOfInterest.campus= '%s'", [idList UTF8String],[campusName UTF8String]];
        const char *q_Stmt = [qStmt UTF8String];
        
        if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                poi = [PointOfInterest new];
                [poi setUTF8Title:(char *)sqlite3_column_text(statement, 0)];
                [poi setUTF8Subtitle:(char *)sqlite3_column_text(statement, 1)];
                [poi setUTF8CanShowLeftCallout:(char *)sqlite3_column_text(statement, 2)];
                [poi setUTF8CanShowRightCallout: (char *)sqlite3_column_text(statement, 3)];
                [poi setUTF8Color:(char *)sqlite3_column_text(statement, 4)];
                [poi setUTF8Website:(char *)sqlite3_column_text(statement, 5)];
                [poi setLatitude:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue]];
                [poi setLongitude: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue]];
                [poi setID:[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue]];
                
                [result addObject:poi];
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"Prepare-error in getPointsOfInterestForIDs %s", sqlite3_errmsg(poiDB));
        }
    }
    [self closeDb];
    return result;



}



/*// Returns a PointOfInterest array without considering the mapping. Should be called for Search.
// Use getPointsOfInterestIncludingMapping as general Search
-(NSMutableArray *)getPointsOfInterestNotMappedForKey:(NSString*) key{
    
    NSMutableArray* result = [NSMutableArray new];
    sqlite3_stmt *statement;
    NSString *qStmt = [NSString stringWithFormat:@"SELECT title,subtitle,canshowleftcallout,canshowrightcallout,color,website,lat,longi,ID FROM pointOfInterest  WHERE pointOfInterest.searchKey = '%s'", [key UTF8String]];
    const char *q_Stmt = [qStmt UTF8String];
     
    if (sqlite3_prepare_v2(poiDB, q_Stmt, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            PointOfInterest* poi = [PointOfInterest new];
            poi.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            poi.subtitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            poi.canShowLeftCallout = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] boolValue];
            poi.canShowRightCallout = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] boolValue];
            poi.color = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] integerValue];
            poi.website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            poi.latitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] floatValue];
            poi.longitude = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] floatValue];
            poi.ID = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] integerValue];
            
            [result addObject:poi];
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Prepare-error in getPointsOfInterestNotMappedForKey  %s", sqlite3_errmsg(poiDB));
    }
    NSLog(@"4 : %@",result);
    return result;
}*/


-(NSArray*) getArrayOfArraysWithTitlesAndIDsOfPOIForCategorieID:(int) ID{
    [self openDb];
    NSMutableArray* titleArray = [[NSMutableArray alloc] initWithArray:[self getAllPOITitlesAndIDsForCategorieOrderdASCWithID:ID] copyItems:YES];
    
    NSRange range;
    range.location=0;
    
    NSInteger removed = 0;
    NSMutableArray *arrayWithSectionArrays = [[NSMutableArray alloc] init];
    NSString * word = [[titleArray objectAtIndex:0] objectAtIndex:0];
    
    if (titleArray.count == 1) {
        [arrayWithSectionArrays addObject:[NSArray arrayWithObjects:[titleArray objectAtIndex:0], nil]];
    } else{
        for (int i = 0; i < titleArray.count ; i++) {
            if (([[[titleArray objectAtIndex:i] objectAtIndex:0] characterAtIndex:0] !=  [word characterAtIndex:0]) || (i == titleArray.count-1)  ) {
                range.length = i-removed;
                if (i == titleArray.count-1) {
                    if ([[[titleArray objectAtIndex:i] objectAtIndex:0] characterAtIndex:0] !=  [word characterAtIndex:0]) {
                        [arrayWithSectionArrays addObject:[NSArray arrayWithObjects:[titleArray objectAtIndex:i], nil]];
                    }else {
                        range.length = i+1-removed;
                        
                    }
                }
                NSArray *section = [[NSArray alloc] initWithArray:[titleArray subarrayWithRange:range]];
                [arrayWithSectionArrays addObject:section];
                
                
                
                range.location = i;
                word = [[titleArray objectAtIndex:i] objectAtIndex:0];
                removed = i;
            }
        }
    }
    [self closeDb];
        //NSLog(@"%@",arrayWithSectionArrays);
    return  arrayWithSectionArrays;
}



+(NSString *)changeFormatOfString:(NSString *) key{
    key = key.uppercaseString;
    //key = [key stringByReplacingOccurrencesOfString:@"É" withString:@"E"];
    if (key.length == 4) {
        if ([[key stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@""] isEqualToString:[key stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
            return [key stringByReplacingOccurrencesOfString:@" " withString:@""];

        }
    }
    return key;
}

-(NSString *)replaceAccentedCharacters:(NSString *) key{

    NSString *searchKey = [key stringByReplacingOccurrencesOfString:@"Ä" withString:@"AE"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"Ö" withString:@"OE"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"Ü" withString:@"UE"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"ß" withString:@"SS"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"ẞ" withString:@"SS"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"É" withString:@"E"];
    
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"ö" withString:@"oe"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"ü" withString:@"ue"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"ä" withString:@"ae"];
    searchKey = [searchKey stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    return searchKey;
}







@end
