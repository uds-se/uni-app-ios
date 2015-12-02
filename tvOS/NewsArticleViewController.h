//
//  NewsArticleViewController.h
//  Uni Saar
//
//  Created by Daniel on 02/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"
#import "Parser.h"

@interface NewsArticleViewController : UIViewController {
    
    __weak IBOutlet UIActivityIndicatorView *AiArticleView;
    __weak IBOutlet UITextView *ContentTextBox;
}

@property (weak, nonatomic) IBOutlet UILabel *TitleView;
@property (weak, nonatomic) IBOutlet UILabel *SubTitleView;
@property (weak, nonatomic) IBOutlet UITextView *ContentView;

@property (strong, nonatomic) NewsArticle *article;


@end
