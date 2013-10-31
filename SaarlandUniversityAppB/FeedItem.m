//
//  FeedItem.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

@synthesize title;
@synthesize description;
@synthesize publicationDate;
@synthesize link;


- (id)init {
	if (self = [super init]) {
		// Initialise the member variables to empty strings
		self.title = [[NSMutableString alloc] initWithString:@""];
		self.description = [[NSMutableString alloc] initWithString:@""];
		self.publicationDate = [[NSMutableString alloc] initWithString:@""];;
		self.link = [[NSMutableString alloc] initWithString:@""];;
	}
	return self;
}


#define kTitleKey            @"title"
#define kDescriptionKey      @"description"
#define kPubDateKey          @"pubDate"
#define kLinkKey             @"link"


#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: title forKey:kTitleKey];
    [encoder encodeObject: description forKey:kDescriptionKey];
    [encoder encodeObject: publicationDate forKey:kPubDateKey];
    [encoder encodeObject: link forKey:kLinkKey];

}

- (id)initWithCoder:(NSCoder *)decoder {
    title = [decoder decodeObjectForKey:kTitleKey];
    description = [decoder decodeObjectForKey:kDescriptionKey];
    publicationDate = [decoder decodeObjectForKey:kPubDateKey];
    link = [decoder decodeObjectForKey:kLinkKey];
    return self;
}



@end
