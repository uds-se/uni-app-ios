//
//  RssFeed.m
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 2012 Universität des Saarlandes. All rights reserved.
//

#import "RssFeed.h"
#import "Reachability.h"


@implementation RSSFeed

@synthesize feedItems;
@synthesize delegate;
@synthesize path;
@synthesize feedItemsDateGrouped;


const int MAXAMOUNTARTICLES =70;


// Initialise this class with a feed path and delegate.  We force the delegate as this is required.
- (id)initWithPath:(NSString *)feedPath andDelegate:(id<RSSFeedDelegate>)theDelegate {
	if (self = [super init]) {
        path = feedPath;
		// Init our feed items array
		self.feedItems = [[NSMutableArray alloc] init];
        self.feedItemsDateGrouped = [[NSMutableArray alloc] init];
		
		// Create an NSURL object using our passed feed path
		NSURL *feedURL = [[NSURL alloc] initWithString:feedPath];
		
		// Init our current feed element string
		currentFeedElement = @"";
	
		// Init our feed parser with the created NSURL
		feedParser = [[NSXMLParser alloc] initWithContentsOfURL:feedURL];
        	
        [feedParser setShouldProcessNamespaces:NO];
		[feedParser setShouldReportNamespacePrefixes:NO];
		[feedParser setShouldResolveExternalEntities:NO];
		
		// Set this class as the xml parser delegate so that we can respond to the parser's callback methods
		[feedParser setDelegate:self];
		
		// Assign this classes RSSFeedDelegate to the passed delegate
		self.delegate = theDelegate;
	}
	return self;
}

#pragma mark -
#pragma mark Action Methods

// Parse the xml feed!
- (void)parse {
	[feedParser parse];
}



// return an Array of Arrays so that each subarray contains all the items of the same pubDate
- (NSMutableArray *) getFeedItemsDateGrouped { 
    
    
    if (feedItems.count > 0) {
        NSMutableArray* resArray = [[NSMutableArray alloc] init];
        NSMutableArray *elemsOfSameDate = [[NSMutableArray alloc] init];
        NSString *refDate = [[feedItems objectAtIndex:0] publicationDate].copy;
        [elemsOfSameDate addObject:[feedItems objectAtIndex:0]];
        
        
        for (int i = 1; i < feedItems.count; i++) {
            if ([[[feedItems objectAtIndex:i] publicationDate] isEqual:refDate]) {
                [elemsOfSameDate addObject:[feedItems objectAtIndex:i]];
            } else {
                [resArray addObject:elemsOfSameDate.copy];
                [elemsOfSameDate removeAllObjects];
                
                refDate = [[feedItems objectAtIndex:i] publicationDate].copy ;
                [elemsOfSameDate addObject:[feedItems objectAtIndex:i]];
            }
        }
        [resArray addObject:elemsOfSameDate];
        return resArray;
    } else {
        return feedItems;
    }
}




#pragma mark -
#pragma mark XMLParser Delegate Methods

// An error occured during the parsing
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString *message;
    if (![[Reachability class] hasInternetConnection]) {
        message = [NSString stringWithFormat:@"Data couldn´t be loaded. Please check your Internet Connection and try again"];
        [self performSelectorOnMainThread:@selector(showAlert:) withObject:message waitUntilDone:NO];

    }
   /* else {
        if (![[Reachability class] websiteAvailable:@"www.apple.com"]) {
            NSLog(path);
            message = [NSString stringWithFormat:@"Website not available. Try again later"];
        }else {
            message = [NSString stringWithFormat:@"Error when parsing feed.  Error Code: %d", [parseError code]];
        }

    }

    [self performSelectorOnMainThread:@selector(showAlert:) withObject:message waitUntilDone:NO];
    */
}


-(void)showAlert:(NSString *) message{
    UIAlertView *parseErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:message 
delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [parseErrorAlert show];

}



// This is the delegate that is called everytime the parser starts a new element in the rss feed, starting tag - <elementName>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
	// Get a copy of the current feed element name
	currentFeedElement = [elementName copy];
	
	if ([currentFeedElement isEqualToString:@"item"]) {
		// Create a new feed item object and add it to our array of feed items
		FeedItem *feedItem = [[FeedItem alloc] init];
		[self.feedItems addObject:feedItem];

		// Point our current feed item reference to the last object (feed item) we placed in the feed items array
		refFeedItem = [self.feedItems lastObject];
	}
}

// This is the ending tag for the element - </elementName>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
	// In this instance, we don't need to do anything here
}

// This is what the parser finds in between an elements start and closing tag
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	// Check to see what the current feed element is so we know what to do with this string of characters
	if ([currentFeedElement isEqualToString:@"title"]) {
		[refFeedItem.title appendString:string];
	} else if ([currentFeedElement isEqualToString:@"pubDate"]) {
        int posTimeStartsInPubDate = [string rangeOfString:@":"].location - 3;
        if (posTimeStartsInPubDate > 0 && string.length > posTimeStartsInPubDate) {
           // NSLog(@"%i",posTimeStartsInPubDate);
            [refFeedItem.publicationDate appendString:[string substringWithRange:NSMakeRange(0, posTimeStartsInPubDate)]]; 
        }
	} else if ([currentFeedElement isEqualToString:@"link"]) {
		// Get rid of any spaces, tabs or newlines in the link string
		string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];		// space
		string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];	// newline
		string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];	// tab
		
		[refFeedItem.link appendString:string];
        //NSLog(@"%@",refFeedItem.link);
	} else if ([currentFeedElement isEqualToString:@"content:encoded"]) {
		[refFeedItem.description appendString:string];
	} 
    
}

// Delegate method for when the parser has completed parsing the document
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    int maxNumberOfArticles = MAXAMOUNTARTICLES;
    
    if (self.feedItems.count > maxNumberOfArticles) {
        NSRange range = NSMakeRange(0, maxNumberOfArticles-1);
        self.feedItems = ((NSArray*)[NSArray arrayWithArray: [self.feedItems subarrayWithRange:range]]).mutableCopy;
    }

    self.feedItemsDateGrouped = [self getFeedItemsDateGrouped];

    
	[delegate RSSFeedParserDidEndDocument];
}








@end
