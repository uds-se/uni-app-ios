//
//  SlideShow.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 15.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideShow : NSObject{
    NSMutableArray* images;
    int currentImageIndex;
}

@property int currentImageIndex;

-(UIImage*) getRandomImage;


@end
