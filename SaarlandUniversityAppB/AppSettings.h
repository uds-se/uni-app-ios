//
//  AppSettings.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 14.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int maxFontSizeToAdd = 10 ;
static const int minFontSizeToAdd = 0 ;

@interface AppSettings : NSObject{
    NSMutableDictionary* dic;
}


//saves the number to the settingsdic that tells how much the font size from the Interfacebuilder should be increased/decreased
-(void)saveFontSizeAddedWith:(int)num;

//reads the number that shoul be added to the font size.  (News and Event articles only)
-(int)readFontSizeToAdd;

@end
