//
//  EventsDataSourceAndDelegate.h
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "Parser.h"


@interface NewsSource : NSObject {
    NSMutableArray *ArticleElements;
    NSMutableArray *News;
    NSMutableArray *News1;
    NSMutableArray *News2;
    NSMutableArray *News3;
    NSMutableArray *bla;
    
}

-(void)loadData;
-(NSMutableArray*)getNews1;
-(NSMutableArray*)getNews2;
-(NSMutableArray*)getNews3;


@end
