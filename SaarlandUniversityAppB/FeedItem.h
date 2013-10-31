//
//  FeedItem.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedItem : NSObject {
	NSMutableString		*title;
	NSMutableString		*description;
	NSMutableString		*publicationDate;
	NSMutableString		*link;
}

@property	(nonatomic, retain)		NSMutableString		*title;
@property	(nonatomic, retain)		NSMutableString		*description;
@property	(nonatomic, retain)		NSMutableString		*publicationDate;
@property	(nonatomic, retain)		NSMutableString		*link;

@end
