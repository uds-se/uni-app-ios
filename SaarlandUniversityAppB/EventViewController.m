//
//  EventViewController.m
//  SaarlandUniversityAppB
//
//  Created by Tom Michels on 14.07.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize  event,link,priorityQueue;
@synthesize delegate = _delegate;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) setEvent:(Event*) anEvent{
    event = anEvent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    priorityQueue = [NSOperationQueue new];
    
    appSettings = [AppSettings new];
    fontSizeToAdd = [self readFontSizeToAddFromPlist];
    
    if (event == NULL) {
        evTitleLabel.text = @"";
        evSubTitleLabel.text = @"";
        evPubDateLabel.text = @"";
        evDescriptionTextView.text = @"";
        if ([Reachability hasInternetConnection]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSInvocationOperation *parseEventOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseEventInformationsWithLink:) object:link];
            [parseEventOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            [priorityQueue addOperation:parseEventOperation];
            
        }else {
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
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setStartFontSizes{
    startSizeTitle = evTitleLabel.font.pointSize;
    startSizeSubtitle = evSubTitleLabel.font.pointSize;
    startSizeArticle = evDescriptionTextView.font.pointSize;
    startSizePubDate = evPubDateLabel.font.pointSize;
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






-(void) parseEventInformationsWithLink:(NSString*) urlString{
    NSError *error = nil;
    
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:NULL];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        //NSLog(@"Error: %@", error);
        return;
    }
    
    
    
    NSString* evePubDate = [NSString stringWithFormat:@""];
    NSString* eveTitle = [NSString stringWithFormat:@""];
    NSString* eveSubtitle = [NSString stringWithFormat:@""];
    NSString* eveDescription = [NSString stringWithFormat:@""];
    
    
    
    HTMLNode *bodyNode = [parser body];
    NSArray *spanNodes = [bodyNode findChildTags:@"div"];
    
    for (HTMLNode *spanNode in spanNodes) {
        if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"news-single-item"]) {
            
            HTMLNode* time = [spanNode findChildWithAttribute:@"class" matchingName:@"news-single-timedata" allowPartial:YES] ;
            
            if (time) {
                evePubDate = [evePubDate stringByAppendingString:[time contents]];
            }
            // NSLog(@"%@",[time contents]);
            
            HTMLNode* title = [spanNode findChildTag:@"h2"];
            if (title) {
                eveTitle = [eveTitle stringByAppendingString:[title contents]];
            }
            
            HTMLNode* subtitle = [spanNode findChildTag:@"h3"];
            if (subtitle) {
                eveSubtitle = [eveSubtitle stringByAppendingString:[subtitle contents]];
            }
            // NSLog(@"%@",[subtitle contents]);
            
            NSArray *pNodes = [spanNode findChildTags:@"p"];
            if (pNodes) {
                for (HTMLNode *pNode in pNodes) {
                    if ([eveDescription isEqualToString:@""] ) {
                        eveDescription = [pNode rawContents];
                    }else {
                        eveDescription = [NSString stringWithFormat:@"%@ %@", eveDescription,[pNode rawContents]];
                    }
                }
            }
        }
        
    }
    
    eveDescription = [eveDescription cleanHtmlCodeInString];
    
    
    event = [[Event alloc] initWithTitle:eveTitle subTitle:eveSubtitle pubDate:evePubDate description:eveDescription];
    [self performSelectorOnMainThread:@selector(setStartFontSizes) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(updateViewItems) withObject:nil waitUntilDone:NO];

    if([self.delegate respondsToSelector:@selector(setEvent:forKey:)]){
        [self.delegate setEvent:event forKey:urlString];
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    
}


-(void) updateViewItems{
    activityIndicatorView.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    evTitleLabel.text = event.title;
    evSubTitleLabel.text = event.subTitle;
    evPubDateLabel.text = event.pubDate;
    evDescriptionTextView.text = event.description;
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
    [evTitleLabel setFont:[UIFont systemFontOfSize:startSizeTitle+fontSizeToAdd]];
    [evTitleLabel adjustHeight];
}

-(void)autoLayoutSubtitleLabel{
    [evSubTitleLabel setFont:[UIFont systemFontOfSize:startSizeSubtitle+fontSizeToAdd]];
    CGRect frame = evSubTitleLabel.frame;
    frame.origin.y = evTitleLabel.frame.origin.y + evTitleLabel.frame.size.height +5;
    evSubTitleLabel.frame = frame;
    [evSubTitleLabel adjustHeight];
}

-(void)autoLayoutArticleTextView{
    [evDescriptionTextView setFont:[UIFont systemFontOfSize:startSizeArticle+fontSizeToAdd]];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast7 = [version hasPrefix:@"7."];
    if (isAtLeast7) {
        [evDescriptionTextView.layoutManager ensureLayoutForTextContainer:evDescriptionTextView.textContainer];
        [evDescriptionTextView layoutIfNeeded];
    }
    CGRect frame = evDescriptionTextView.frame;
    frame.size.height = evDescriptionTextView.contentSize.height;
    frame.origin.y = evSubTitleLabel.frame.origin.y + evSubTitleLabel.frame.size.height + 5;
    evDescriptionTextView.frame = frame;
}

-(void)autoLayoutDateLabel{
    [evPubDateLabel setFont:[UIFont systemFontOfSize:startSizePubDate+fontSizeToAdd]];
    CGRect frame = evPubDateLabel.frame;
    frame.origin.y = evDescriptionTextView.frame.origin.y + evDescriptionTextView.frame.size.height + 2;
    evPubDateLabel.frame = frame;
    
}

-(void)autoLayoutScrollView{
    [scrollView setContentSize:(CGSizeMake(scrollView.frame.size.width, evPubDateLabel.frame.origin.y+evPubDateLabel.frame.size.height+3))];
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
    [super viewDidUnload];
    event = nil;
    priorityQueue = nil;
    link = nil;
    evPubDateLabel = nil;
    evTitleLabel = nil;
    evSubTitleLabel = nil;
    evDescriptionTextView = nil;
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
