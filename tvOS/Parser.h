//
//  Parser.h
//  Uni Saar
//
//  Created by Daniel on 02/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject 



+ (NSMutableArray*)parseWithURL:(NSString*)urll andWithPath:(NSString*)path;

@end
