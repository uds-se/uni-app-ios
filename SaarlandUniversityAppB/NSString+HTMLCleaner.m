//
//  NSString+HTMLCleaner.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 28.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "NSString+HTMLCleaner.h"

@implementation NSString (HTMLCleaner)


//removes/replaces all html nodes like <br> <p> from an NSString
-(NSString* )cleanHtmlCodeInString{
    NSString* result = self;
    result = [result stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    result = [result stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    result = [result stringByReplacingOccurrencesOfString:@"(at)" withString:@"@"];
    
    NSRange r;
    while ((r = [result rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        result = [result stringByReplacingCharactersInRange:r withString:@""];
    }
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    result = [result stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    
    return result;
}



@end
