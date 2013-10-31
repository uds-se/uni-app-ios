//
//  SlideShow.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 15.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "SlideShow.h"

@implementation SlideShow

@synthesize currentImageIndex;

//inits the photo slideshow
-(id) init{
    self = [super init];
    images = [[NSMutableArray alloc] init];
    int i = 1;
    while ([UIImage imageNamed:[NSString stringWithFormat:@"slideShowImage%i.jpg",i]] != NULL) {
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"slideShowImage%i.jpg",i]];
        if (image != nil) {
            [images addObject:image];
        }
        i++;
    }

    return self;
}

-(UIImage*) getRandomImage{
    int newIndex =  [self getRandomNumberBetweenMin:0 andMax:images.count-1];
    while (currentImageIndex == newIndex)  {
        newIndex =  [self getRandomNumberBetweenMin:0 andMax:images.count-1];
    }
    return [images objectAtIndex:newIndex];
}


-(int) getRandomNumberBetweenMin:(int)min andMax:(int)max
{
	return ( (arc4random() % (max-min+1)) + min );
}

@end
