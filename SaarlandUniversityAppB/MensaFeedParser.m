//
//  MensaFeedParser.m
//  SaarlandUniversityAppB
//
//  Created by Andreas Freund on 28.06.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "MensaFeedParser.h"
#import "MensaItem.h"

@implementation MensaFeedParser;
@synthesize item, items, days_dict, delegate;

- (void) initParser:(NSURL *)url withDict:(NSMutableDictionary *)days_Dict andDelegate:(id<MensaFeedParserDelegate>)theDelegate{
    //init array of item objects, array of items and dictionary of items
    items = [[NSMutableArray alloc] init];
    days_dict = days_Dict;

    self.delegate = theDelegate;
    //init NSXMLParser with content of given URL
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    //set delegate
    [nsXmlParser setDelegate:self];
    //parse!
    BOOL success = [nsXmlParser parse];
    //testing
    if (success) {
        //no errors, it's a beatiful world
        //inform the delegate that parsing ended and transfer the data
        [delegate parsingDidEnd:days_dict];
    } else {
        NSLog(@"Error parsing URL!");
      
    }
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"tag"]) {
        //a new day has risen
        date = [[attributeDict valueForKey:@"timestamp"] doubleValue];
        items = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"item"]) {
        //found new yummy
        item = [[MensaItem alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        //init the ad hoc string with the value     
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
        //append value to the ad hoc string    
        [currentElementValue appendString:string];
    }
}  

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"speiseplan"]) {
        //end of the XML document
        
        //NSLog(@"%@",days_dict);
        
        return;
    }
    if ([elementName isEqualToString:@"tag"]) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
        [components setHour:0];
        NSDate *today0am = [calendar dateFromComponents:components];
        
        NSDate *tagDate = [[NSDate alloc] initWithTimeIntervalSince1970:date];

        //falls der Datum des Tags nicht in der Vergangenheit liegt
        if ([[today0am laterDate:tagDate] isEqualToDate:tagDate]) {
            NSString* dateString = [NSString stringWithFormat:@"%.0f",date];
            //NSMutableArray *menuArray = [days_dict objectForKey:dateString];
            //NSLog(@"%@",menuArray);
            //if (!menuArray) {
            [days_dict setObject:items forKey:dateString];
            //}
        }
        
        //clear items
        items = nil;
    }
    if ([elementName isEqualToString:@"item"]) {
        //set date for this item
        [item setTag:[[NSDate alloc] initWithTimeIntervalSince1970:date]];
        //done with one item, adding it to items array
        [items addObject:item];
        //clear item
        item = nil;
    } else 
        if ([elementName isEqualToString:@"description"]) {
            //this has to be done, because you can't use a variable named
            //"description" in objective-c
            currentElementValue = [self filterString:currentElementValue];
            [item setDesc:currentElementValue];
        } else {
            @try {
                currentElementValue = [self filterString:currentElementValue];
                //we hit one of the elements, adding to the same named element in item 
                [item setValue:currentElementValue forKey:elementName];
            }
            @catch (NSException *exception) {
                //nothing to do here, just ignore it
            }
            @finally {
                //nothing to do here, just ingore it
            }
        }
    currentElementValue = nil;
}

- (NSMutableString *)filterString:(NSMutableString *) unfilteredString {
    //initialize a string that will hold the result  
    NSMutableString *resultString = [NSMutableString stringWithCapacity:unfilteredString.length];  
    
    NSScanner *scanner = [NSScanner scannerWithString:unfilteredString];  
    //define the allowed characters, here only numbers from one to three, equal and plus  
    NSCharacterSet *allowedChars = [[NSCharacterSet characterSetWithCharactersInString:@""] invertedSet];  
    
    while ([scanner isAtEnd] == NO) {  
        NSString *buffer;  
        if ([scanner scanCharactersFromSet:allowedChars intoString:&buffer]) {  
            [resultString appendString:buffer];       
        } else {  
            [scanner setScanLocation:([scanner scanLocation] + 1)];  
        }
    }
    return resultString;
    
}

@end