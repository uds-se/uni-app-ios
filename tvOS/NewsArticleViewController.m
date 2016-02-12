//
//  NewsArticleViewController.m
//  Uni Saar
//
//  Created by Daniel on 02/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "NewsArticleViewController.h"
#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface NewsArticleViewController () 

@end

@implementation NewsArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Reachability hasInternetConnection]) {
        NoInternet.hidden = true;
    }
    else {
        NoInternet.hidden = false;
        NoInternet.text = NSLocalizedStringFromTable(@"NoInternet", @"tvosLocalisation", nil);
        self.TitleView.alpha = 0;
        self.SubTitleView.alpha = 0;
    }
    
    self.TitleView.text = [[self article] title];
    self.SubTitleView.text = [[self article] subTitle];
    AiArticleView.color= [UIColor blackColor];

    [AiArticleView startAnimating];
    AiArticleView.hidden = false;
    
    ContentTextBox.userInteractionEnabled = true;
    ContentTextBox.scrollEnabled = true;
    ContentTextBox.panGestureRecognizer.allowedTouchTypes = @[ @(UITouchTypeIndirect) ];
    ContentTextBox.showsVerticalScrollIndicator = true;

    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableArray *NewsContent = [Parser parseWithURL:[[self article] article] andWithPath:@"//div[@class='newscontent']"];        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if  ([NewsContent count] > 0) {
                self.ContentView.text = [NewsContent objectAtIndex:0];
            }
            AiArticleView.hidden = true;
            [AiArticleView stopAnimating];            
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
