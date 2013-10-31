//
//  NewsArticleViewController.h
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "Reachability.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "AppSettings.h"
#import "NSString+HTMLCleaner.h"

@protocol NewsArticleToNewsTable <NSObject>
@required
-(void)setNewsArticle:(NewsArticle *)article forKey:(NSString *)key;
@end

@interface NewsArticleViewController : UIViewController<UIAlertViewDelegate>{
    
    NewsArticle* newsArticle;

    
    
    __weak IBOutlet UILabel *arSubtitleLabel;
    __weak IBOutlet UILabel *arTitleLabel;
    __weak IBOutlet UITextView *arArticleTextView;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *arDateLabel;
    __weak IBOutlet UIActivityIndicatorView* activityIndicatorView;

    
    __weak id <NewsArticleToNewsTable> delegate;

    NSString* link;
    NSOperationQueue *priorityQueue;
    NSDictionary* settingsDic;
    int fontSizeToAdd;
    AppSettings* appSettings;
    int startSizeTitle;
    int startSizeSubtitle;
    int startSizeArticle;
    int startSizePubDate;
}




@property(nonatomic,weak)id  delegate;
@property (nonatomic, copy) NewsArticle* newsArticle;
@property (nonatomic) NSString* link;
@property NSOperationQueue *priorityQueue;


-(void)increaseTextSize;
-(void)decreaseTextSize;

- (void) setNewsArticle:(NewsArticle*) newsArticle;
@end
