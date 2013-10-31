//
//  NSString+HTMLCleaner.h
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 28.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTMLCleaner)

//removes/replaces all html nodes like <br> <p> from an NSString
-(NSString* )cleanHtmlCodeInString;

@end
