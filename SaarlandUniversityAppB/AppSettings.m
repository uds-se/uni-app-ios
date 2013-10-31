//
//  AppSettings.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 14.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings



//gets the settings dic
-(NSMutableDictionary *)dic{
    if (!dic) {
 

        NSString * path = [self filePathForSettingsPList];
        NSFileManager* fileManager = [NSFileManager defaultManager] ;
        NSString *pathInMainBundle = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        if ([fileManager fileExistsAtPath:path ]){
            dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
        else {
            [fileManager copyItemAtPath:pathInMainBundle toPath:path error:nil];
            dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        }
    }

    return dic;
}



-(int)readFontSizeToAdd{
    int fontSize = [[[self dic] objectForKey:@"fontSizeToAdd"] integerValue];
    if (fontSize> maxFontSizeToAdd) {
        [self saveFontSizeAddedWith:maxFontSizeToAdd];
        return maxFontSizeToAdd;
    }else if (fontSize <minFontSizeToAdd) {
        [self saveFontSizeAddedWith:minFontSizeToAdd];
        return minFontSizeToAdd;
    } else {
        return fontSize;
    }

}

-(void)saveFontSizeAddedWith:(int) num{
    if (num> maxFontSizeToAdd) {
        [[self dic] setValue:[NSNumber numberWithInt:num] forKey:@"fontSizeToAdd"];
    }else if (num <minFontSizeToAdd) {
        [[self dic] setValue:[NSNumber numberWithInt:num] forKey:@"fontSizeToAdd"];
    } else {
        [[self dic] setValue:[NSNumber numberWithInt:num] forKey:@"fontSizeToAdd"];
    }
    [self savePlist];
}




-(void)savePlist{
    NSString * path;
    path = [self filePathForSettingsPList];
    if([dic writeToFile:path atomically:YES]){
        NSLog(@"Settingsdic saved");
    } else {
        NSLog(@"Settingsdic not saved");
    }

}


-(NSString *) filePathForSettingsPList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@%@",
                      documentsDirectory,
                      @"/settings.plist"];
    return path;

}

@end
