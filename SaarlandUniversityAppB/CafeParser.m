//
//  CafeParser.m
//  SaarlandUniversityAppB
//
//  Created by Andreas Freund on 10.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "CafeParser.h"
#import "MensaItem.h"
#import "MensaFeedParser.h"

@implementation CafeParser
@synthesize item, days_dict, category, delegate;

- (void) initParser:(NSURL *)url withCategory:(NSString *)menuCategory withDict:(NSMutableDictionary *)dict andDelegate:(id<CafeParserDelegate>)theDelegate
{
    //init array of item objects, array of items and dictionary of items
    days_dict = dict;
    started = false;
    twotimes = false;
    wochentag = 2;
    self.category = menuCategory;
    self.delegate = theDelegate;
    endParsing = false;
    //init NSXMLParser with content of given URL
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    //set delegate
    [nsXmlParser setDelegate:self];
    
    [self removeOldCafeItems];
    
    
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

-(void)removeOldCafeItems{
    NSArray* keys = days_dict.allKeys;
    keys = [self getAllTimestampsFromThisWeek:keys];
    
    for (NSString* timestamp in keys) {
        NSMutableArray *items = [days_dict valueForKey:timestamp];
        for (MensaItem* mensaItem in items) {
            if ([mensaItem.category isEqual:self.category]) {
                [items removeObject:mensaItem];
                //NSLog(@"Removed %@",self.category);
            }
        }
        
    }

}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *s2 = [self filterString:string];
    if (!currentElementValue) {
        //init the ad hoc string with the value     
        currentElementValue = [[NSMutableString alloc] initWithString:s2];
    } else {
        //append value to the ad hoc string    
        [currentElementValue appendString:s2];
    }
} 

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([currentElementValue isEqual:nil]) { 
        //empty node
    }
    else {
        //weekday are in all 3 tables (AC, CIC, JC) written bold. So there is a big chance that bold (strong) written elements are weekdays.
        if ([elementName isEqualToString:@"strong"]) {
            if ([currentElementValue isEqualToString:@"Montag"] | [currentElementValue isEqualToString:@"Mo"]) {
                wochentag = 2;
                //now the table with daily menus has started
                started = true;
            } else if ([currentElementValue isEqualToString:@"Dienstag"] | [currentElementValue isEqualToString:@"Di"]) {
                wochentag = 3;
                started = true;
            } else if ([currentElementValue isEqualToString:@"Mittwoch"] | [currentElementValue isEqualToString:@"Mi"]) {
                wochentag = 4;
                started = true;
            } else if ([currentElementValue isEqualToString:@"Donnerstag"] | [currentElementValue isEqualToString:@"Do"]) {
                wochentag = 5;
                started = true;
            } else if ([currentElementValue isEqualToString:@"Freitag"] | [currentElementValue isEqualToString:@"Fr"]) {
                wochentag = 6;
                started = true;
                //lastday = true;
            }
        }

        if (started) {
            //if last day was parsed (friday) and some misc. will be display inside table node it'll be ignored. It doens't effect the friday menus, because they aren't written bold.
            if ([elementName isEqualToString:@"strong"]) {
                if ([currentElementValue isEqualToString:@"€uro"] || [currentElementValue isEqualToString:@"€"]) {
                    return;
                }
                if (lastday) {
                    //I don't know why but it doesn't return when it's reading return for the first time...some unknown circumstances lead to that it's ignoring it. so it is necessary to nullify currentElementValue. If it's ignoring return or not it has no more chance to write wrong data in the dictionary.
                    //currentElementValue = nil;
                    endParsing = true;
                    return;
                }
                /*if ([currentElementValue isEqualToString:@"Dienstag"] | [currentElementValue isEqualToString:@"Di"]) {
                    wochentag = 3;
                } else if ([currentElementValue isEqualToString:@"Mittwoch"] | [currentElementValue isEqualToString:@"Mi"]) {
                    wochentag = 4;
                } else if ([currentElementValue isEqualToString:@"Donnerstag"] | [currentElementValue isEqualToString:@"Do"]) {
                    wochentag = 5;
                } else */if ([currentElementValue isEqualToString:@"Freitag"] | [currentElementValue isEqualToString:@"Fr"]) {
                    wochentag = 6;
                    lastday = true;
                } else if ([currentElementValue isEqualToString:@"a)"]) {
                    twotimes = true;
                }
            }
            
            
            //one cell was read
            if ([elementName isEqualToString:@"td"]){
                //NSLog(@"%d",endParsing);
                if (currentElementValue.length > 0 && !endParsing && ![currentElementValue isEqualToString:@"€uro"] && ![currentElementValue isEqualToString:@"€"]) {
                    if (twotimes) {
                        if (currentElementValue.length > 4) {
                            placeholder = [self newItemWithTitle];
                        } else {
                            [self addPrice:placeholder];
                            [self addToDaysDict:item];
                            [self addToDaysDict:placeholder];
                            item = nil;
                            placeholder = nil;
                            twotimes = false; 
                        }
                    } else { 
                    //a meal has more than four characters (i guess..)
                    if (currentElementValue.length > 4) {
                        item = [self newItemWithTitle];
                    } else {
                        //price has exact 4 chars ("x.xx")
                        [self addPrice:item];
                        //add item to dict
                        [self addToDaysDict:item];
                        item = nil;
                    }
                    }
                }
            }
        }
        if ([elementName isEqualToString:@"br"]) {
            //sometimes you find a <br /> in messy html-code. this will make sure that it won't crash the parser accidently.   
            if (twotimes) {
                if (item.preis1.length < 1)  {
                    if (currentElementValue.length > 4){
                        if (item.title.length < 1){
                            item = [self newItemWithTitle];
                            currentElementValue = nil;
                        }
                } else {
                    [self addPrice:item];
                    currentElementValue = nil;
                }
                }
            }
        } else {
            currentElementValue = nil;
        }
    }
}

-(void)readCells{}

- (NSString *)filterString:(NSString *) unfilteredString {
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

- (MensaItem *)newItemWithTitle {
    MensaItem *item1 = [[MensaItem alloc] init];
    [item1 setCategory:category];
    [item1 setTitle:currentElementValue];
    return item1;
}

- (void) addPrice:(MensaItem *)item1 {
    [item1 setPreis1:currentElementValue];
    [item1 setPreis2:currentElementValue];
    [item1 setPreis3:currentElementValue];
}

- (void) addToDaysDict:(MensaItem *)item1 {
    if (item1.title.length < 1) {
        NSLog(@"huh... something went wrong...");
    } else {
        NSArray* keys = days_dict.allKeys;
        keys = [self getAllTimestampsFromThisWeek:keys];
        for (NSString* timestamp in keys) {
            NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:[timestamp floatValue]];
            NSCalendar* cal = [NSCalendar currentCalendar];
            NSDateComponents* components = [cal components:NSWeekdayCalendarUnit fromDate:currentDate];
            //1 == Sunday, 2 == Monday, ...
            NSInteger weekday = [components weekday];
            
            if (weekday == wochentag) {
                NSMutableArray *items = [days_dict valueForKey:timestamp];
                if (items.count == 0) {
                    items = [[NSMutableArray alloc] init];
                }
                
                
                
                //if (![self doesArray:items containMensaItem:item1]) {
                    [items addObject:item1];
                    if (items != nil) {
                        [days_dict setObject:items forKey:timestamp];
                    }
               // }
                
                
            }
        }
        
        /*
        
        weekdayString = [[NSNumber numberWithInt:wochentag] stringValue];
        NSMutableArray *items = [days_dict valueForKey:weekdayString];
        if (items.count == 0) {
            items = [[NSMutableArray alloc] init];
        }
        [items addObject:item1];
        if (items != nil) {
            [days_dict setObject:items forKey:weekdayString];
        }*/
    }
}

-(NSArray *)getAllTimestampsFromThisWeek:(NSArray *)keys{
    NSMutableArray* res = [NSMutableArray new];
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //[calendar setLocale:[NSLocale currentLocale]];
    NSDateComponents *currentComponents = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:currentDate];
    [currentComponents setHour:0];
    NSDate* todayAt0Am = [calendar dateFromComponents:currentComponents];

    //NSCalendar* cal = [NSCalendar currentCalendar];
    //NSDateComponents* components = [cal components:NSWeekdayCalendarUnit fromDate:currentDate];
    //1 == Sunday, 2 == Monday, ...
    //NSInteger currentWeekday = [components weekday];
    
    for (NSString* timestamp in keys) {
        
        // get date of upcoming sunday
        NSDateComponents *sundayComponents = [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:currentDate];
        
        [sundayComponents setWeekday:1]; //Sunday
        [sundayComponents setWeek: [sundayComponents week] + 1]; //Next week
        [sundayComponents setHour:0]; 
        NSDate *dateOfUpcomingSunday = [calendar dateFromComponents:sundayComponents];
        
        NSDate *timestampDate = [[NSDate alloc] initWithTimeIntervalSince1970:[timestamp floatValue]];
        //NSDateComponents* components2 = [cal components:NSWeekdayCalendarUnit fromDate:currentDate];
        //1 == Sunday, 2 == Monday, ...
        //NSInteger weekdayTimestamp = [components2 weekday];
        
     
        //is timestampDate not in the past & from this week
        if ([[todayAt0Am laterDate:timestampDate] isEqualToDate:timestampDate] && [[timestampDate laterDate:dateOfUpcomingSunday] isEqualToDate:dateOfUpcomingSunday]) {
            [res addObject:timestamp];
        }
        
    }
    return  res;
        

}


-(BOOL) doesArray:(NSArray*) arr containMensaItem:(MensaItem*)mItem{
    NSString* itemTitle = mItem.title;
    
    for (MensaItem* mensaItem in arr) {
        if ([mensaItem.title isEqual:itemTitle]) {
            return YES;
        }
    }
    return NO;
    
}
 /*
-(int)dateDiffrenceFromDate:(NSDate *)startDate second:(NSDate *)endDate {

    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        
    int dayDiff = [difference day];
    return dayDiff;
}
*/


@end
