//
//  NewsArticleViewController.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 12.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "NewsArticleViewController.h"
#import "UILabel+UILabel_AutoHeight.h"


@interface NewsArticleViewController ()

@end

@implementation NewsArticleViewController

@synthesize newsArticle,link,priorityQueue;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) setNewsArticle:(NewsArticle*) aNewsArticle {
    newsArticle = aNewsArticle;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    priorityQueue = [NSOperationQueue new];
    
    appSettings = [AppSettings new];
    fontSizeToAdd = [self readFontSizeToAddFromPlist];

    if (newsArticle == NULL) {
        arTitleLabel.text = @"";
        arSubtitleLabel.text = @"";
        arDateLabel.text = @"";
        arArticleTextView.text = @"";
        if ([Reachability hasInternetConnection]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSInvocationOperation *parseArticleOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseNewsArticleWithLink:) object:link];
            //NSLog(@"%@",link);
            [parseArticleOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            [priorityQueue addOperation:parseArticleOperation];

        }else {
            [activityIndicatorView setHidden:YES];
            UIAlertView *internetErrorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No internet conncetion", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"Article couldn´t be loaded. Please check your internet connection and try again", nil)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [internetErrorAlert show];
        }
    } else {
        [self setStartFontSizes];
        [self updateViewItems];
    }
    
    UIBarButtonItem *btnDecrease = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textSizeSmallIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(decreaseTextSize)];
    UIBarButtonItem *btnIncrease = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textSizeBigIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(increaseTextSize)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnIncrease, btnDecrease, nil]];
   
    
    //scrollView.scrollEnabled = NO;
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setStartFontSizes{
    startSizeTitle = arTitleLabel.font.pointSize;
    startSizeSubtitle = arSubtitleLabel.font.pointSize;
    startSizeArticle = arArticleTextView.font.pointSize;
    startSizePubDate = arDateLabel.font.pointSize;
}


-(int)readFontSizeToAddFromPlist{
    return [appSettings readFontSizeToAdd];
}

-(void)saveFontSizeToAddToPlist{
    [appSettings saveFontSizeAddedWith:fontSizeToAdd];
}


-(void)increaseTextSize{
    int fontSize = fontSizeToAdd +2;
    if (fontSize <= maxFontSizeToAdd) {
        fontSizeToAdd = fontSize;
    }
    [self autoLayoutView];
}

-(void)decreaseTextSize{
    int fontsize = fontSizeToAdd - 2;
    if (fontsize >= minFontSizeToAdd) {
        fontSizeToAdd = fontsize;
    }
    [self autoLayoutView];
}

// gets called if article not yet parsed from NewsTableViewController
-(void) parseNewsArticleWithLink:(NSString*) urlString{
    NSError *error = nil;
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:NULL];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        //NSLog(@"Error: %@", error);
        return;
    }
    
    NSString* arPubDate = [NSString stringWithFormat:@""];
    NSString* arTitle = [NSString stringWithFormat:@""];
    NSString* arSubtitle = [NSString stringWithFormat:@""];
    NSString* arArticle = [NSString stringWithFormat:@""];
    
    
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    
    for (HTMLNode *spanNode in spanNodes) {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"news-single-item"]) {
            
            HTMLNode* time = [spanNode findChildWithAttribute:@"class" matchingName:@"news-single-rightbox" allowPartial:YES] ;
            
            if (time) {
                arPubDate = [[arPubDate stringByAppendingString:[time contents]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            HTMLNode* title = [spanNode findChildTag:@"h1"];
            if (title) {
                arTitle = [arTitle stringByAppendingString:[title contents]];
            }
            
            HTMLNode* subtitle = [spanNode findChildTag:@"h2"];
            if (subtitle) {
                arSubtitle = [arSubtitle stringByAppendingString:[subtitle contents]];
            }
            
            NSArray *pNodes = [spanNode findChildTags:@"p"];
            if (pNodes) {
                for (HTMLNode *pNode in pNodes) {
                    if ([arArticle isEqualToString:@""] ) {
                        arArticle = [pNode rawContents];
                        //arArticle = [NSString stringWithFormat:@"%@",[pNode allContents]];
                    }else {
                        arArticle = [NSString stringWithFormat:@"%@ %@", arArticle,[pNode rawContents]];
                        //arArticle = [NSString stringWithFormat:@"%@\n \n %@", arArticle,[pNode allContents]];
                    }
                }
            }
        }
        
    }
    
    //htmlclean
    arArticle = [arArticle cleanHtmlCodeInString];
    
       
    newsArticle = [[NewsArticle alloc] initWithTitle:arTitle subTitle:arSubtitle pubDate:arPubDate article:arArticle] ;
    [self performSelectorOnMainThread:@selector(setStartFontSizes) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(updateViewItems) withObject:nil waitUntilDone:NO];
    
    if([self.delegate respondsToSelector:@selector(setNewsArticle:forKey:)]){
        [self.delegate setNewsArticle:newsArticle forKey:urlString];
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



-(void) updateViewItems{
    activityIndicatorView.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    arArticleTextView.text=newsArticle.article;
    arTitleLabel.text=newsArticle.title;
    arSubtitleLabel.text=newsArticle.subTitle;
    arDateLabel.text=newsArticle.pubDate;
    [self autoLayoutView];
}


-(void)autoLayoutView{
    [self autoLayoutTitleLabel];
    [self autoLayoutSubtitleLabel];
    [self autoLayoutArticleTextView];
    [self autoLayoutDateLabel];
    [self autoLayoutScrollView];
}

-(void)autoLayoutTitleLabel{
    [arTitleLabel setFont:[UIFont systemFontOfSize:startSizeTitle+fontSizeToAdd]];
    [arTitleLabel adjustHeight];
}

-(void)autoLayoutSubtitleLabel{
    [arSubtitleLabel setFont:[UIFont systemFontOfSize:startSizeSubtitle+fontSizeToAdd]];
    CGRect frame = arSubtitleLabel.frame;
    frame.origin.y = arTitleLabel.frame.origin.y + arTitleLabel.frame.size.height +5;
    arSubtitleLabel.frame = frame;
    [arSubtitleLabel adjustHeight];
}

-(void)autoLayoutArticleTextView{
    [arArticleTextView setFont:[UIFont systemFontOfSize:startSizeArticle+fontSizeToAdd]];
//    NSString *version = [[UIDevice currentDevice] systemVersion];
//    BOOL isAtLeast7 = [version hasPrefix:@"7."];
//    if (isAtLeast7) {
//        [arArticleTextView.layoutManager ensureLayoutForTextContainer:arArticleTextView.textContainer];
//        [arArticleTextView layoutIfNeeded];
//
//    }
    CGRect frame = arArticleTextView.frame;
    CGSize size = [arArticleTextView sizeThatFits:CGSizeMake(frame.size.width, FLT_MAX)];
    frame.size.height = size.height;
    //frame.size.height = arArticleTextView.contentSize.height;
    frame.origin.y = arSubtitleLabel.frame.origin.y + arSubtitleLabel.frame.size.height + 5;
    arArticleTextView.frame = frame;

}

-(void)autoLayoutDateLabel{
    [arDateLabel setFont:[UIFont systemFontOfSize:startSizePubDate+fontSizeToAdd]];
    CGRect frame = arDateLabel.frame;
    frame.origin.y = arArticleTextView.frame.origin.y + arArticleTextView.frame.size.height + 2;
    arDateLabel.frame = frame;

}

-(void)autoLayoutScrollView{
    [scrollView setContentSize:(CGSizeMake(scrollView.frame.size.width, arDateLabel.frame.origin.y+arDateLabel.frame.size.height+3))];
}



-(void)viewWillAppear:(BOOL)animated{
    [self autoLayoutView];
}


-(void) viewWillDisappear:(BOOL)animated{
    [self saveFontSizeToAddToPlist];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidUnload
{
    arTitleLabel = nil;
    arSubtitleLabel = nil;
    arArticleTextView = nil;
    scrollView = nil;
    arDateLabel = nil;
    [super viewDidUnload];
    priorityQueue = nil;
    newsArticle = nil;
    link = nil;
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
