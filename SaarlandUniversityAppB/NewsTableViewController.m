//
//  NewsTableViewController.m
//  SaarlandUniversityTest
//
//  Created by Tom Michels on 29.05.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

@synthesize selectedItem, priorityQueue,newsItems,newsArticles;
/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/


//runs in background thread
- (void)RSSFeedParserDidEndDocument {
    NSLog(@"RssFeed Parsing ended");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    newsItems = rssFeed.feedItems.copy;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:NO];
    
    if (newsItems.count > 0) {
        [self saveNewsToFile];
    }
    
    [self parseAllArticlesWithOperation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    priorityQueue = [NSOperationQueue new];
    newsArticles = [[NSMutableDictionary alloc] init];


    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:7/255.0f green:49/255.0f blue:92/255.0f alpha:1.0f];
    refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    refreshControl.activityIndicatorViewColor = [UIColor colorWithRed:17/255.0f green:56/255.0f blue:92/255.0f alpha:1.0f];

    
    
    //facebook button
    UIImage *image = [UIImage imageNamed:@"facebookIcon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage: image forState:UIControlStateNormal];
    //[button setBackgroundImage: [[UIImage imageNamed: @"right_clicked.png"] stretchableImageWithLeftCapWidth:7.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:self action:@selector(openFacebook)    forControlEvents:UIControlEventTouchUpInside];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    [view addSubview:button];
    UIBarButtonItem *facebookButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem= facebookButton;

    
    
    
    //update information
    [self loadSavedData];
    
    if ([Reachability hasInternetConnection]) {
        [self refreshData];
        [refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, -45) animated:YES];

    }else {
        if (newsItems.count<= 0) {
            UIAlertView *internetErrorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No internet conncetion", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"News couldn´t be loaded. Please check your internet connection and try again", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [internetErrorAlert show];
            [refreshControl endRefreshing];
        }
    }
}


-(void)beginRefresh{
    [refreshControl beginRefreshing];
}

-(void)endRefresh{
    [refreshControl endRefreshing];
}





// runs in background thread
-(void) parseAllArticlesWithOperation {
    for (FeedItem* feedItem in newsItems){
        if (![newsArticles objectForKey:feedItem.link]) {
            [self parseNewsArticleWithLink:feedItem.link]; 
        }
    }
    [self saveArticlesToFile];    
    NSLog(@"Parsing done");
}



// runs in background thread
-(void) parseNewsArticleWithLink:(NSString*) urlString{
    NSError *error = nil;
    
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
            
            HTMLNode* time = [spanNode findChildWithAttribute:@"class" matchingName:@"news-single-timedata" allowPartial:YES] ;
            
            if (time) {
                arPubDate = [arPubDate stringByAppendingString:[time contents]];
            }
           // NSLog(@"%@",[time contents]);
            
            HTMLNode* title = [spanNode findChildTag:@"h1"];
            if (title) {
                arTitle = [arTitle stringByAppendingString:[title contents]];
            }
             //NSLog(@"%@",[arTitle contents]);
            
            HTMLNode* subtitle = [spanNode findChildTag:@"h2"];
            if (subtitle) {
                arSubtitle = [arSubtitle stringByAppendingString:[subtitle contents]];
            }
           // NSLog(@"%@",[subtitle contents]);
            
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
                    //NSLog(@"%@",[pNode rawContents]);
                }
            }
        }
        
    }
    
    //htmlclean
    arArticle = [arArticle cleanHtmlCodeInString];
    NewsArticle *article = [[NewsArticle alloc] initWithTitle:arTitle subTitle:arSubtitle pubDate:arPubDate article:arArticle] ;
    [newsArticles setObject:article forKey: urlString];
    

}

-(void)setNewsArticle:(NewsArticle *)article forKey:(NSString *)key{
    [newsArticles setObject:article forKey:key];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.title.text = [[newsItems objectAtIndex:indexPath.row] title];
    
    cell.pubDate.text = [[newsItems objectAtIndex:indexPath.row] publicationDate];
    


	return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItem = [newsItems objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
     if ([segue.identifier isEqualToString:@"showArticle"]) {
         NewsArticleViewController* newsArticleViewController = segue.destinationViewController;
         NewsArticle* newsArticle = [newsArticles objectForKey:selectedItem.link];
         [newsArticleViewController setLink:selectedItem.link];
         [newsArticleViewController setNewsArticle:newsArticle];
         newsArticleViewController.delegate = self;
     }

}

-(void) parseNewInformations{
    rssFeed = [[RSSFeed alloc] initWithPath:@"http://www.uni-saarland.de/aktuelles/presse/pms.html?type=100&tx_ttnews[cat]=26" andDelegate:self];
    [rssFeed parse];
    //[self parseAllArticlesWithOperation];
    
}

-(void)loadSavedData{
    [self loadNewsFromFile];
    if (newsItems.count > 0) {
        [self.tableView reloadData];
    }
    
    NSInvocationOperation *loadArticlesOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadArticlesFromFile) object:nil];
    [loadArticlesOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [priorityQueue addOperation:loadArticlesOperation];
}


-(void) refreshData{
    @try {
        
        if (newsItems.count<=0) {
            [self loadSavedData];
        }
        
        if ([Reachability hasInternetConnection]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            NSInvocationOperation *parseNewInformationsOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseNewInformations) object:nil];
            [parseNewInformationsOperation setQueuePriority:NSOperationQueuePriorityVeryHigh];
            [priorityQueue addOperation:parseNewInformationsOperation];
        } else {
            UIAlertView *internetErrorAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No internet conncetion", nil)] message:[NSString stringWithFormat:NSLocalizedString(@"News couldn´t be updated. Please check your internet connection and try again", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [internetErrorAlert show];
            
            [refreshControl endRefreshing];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
    }
    @catch (NSException *exception) {
    }
}


-(void)openFacebook{
    NSURL *facebookLink = [NSURL URLWithString:@"fb://profile/120807804649363"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookLink]) {
        [[UIApplication sharedApplication] openURL:facebookLink];
    }else{
        UIAlertView *facebookAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"No Facebook App installed", nil)]  message:[NSString stringWithFormat:NSLocalizedString(@"Please install the Facebook App and try again", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];;
        
        [facebookAlert show];
    }
                                  
                                  
                                                           

}


// should run in background thread
-(void) loadArticlesFromFile {
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedNewsArticlesDic"];
    
    NSDictionary* dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (dic.count>0) {
        newsArticles =  [[NSMutableDictionary alloc] initWithDictionary:dic];
    } else {
        newsArticles =  [[NSMutableDictionary alloc] init];
    }
}

// should run in background thread
-(void) saveArticlesToFile {
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedNewsArticlesDic"];
    BOOL succeed = [[NSKeyedArchiver archivedDataWithRootObject:newsArticles] writeToFile:filePath atomically:YES];
    if (!succeed){ // do something  }
        NSLog(@"News articles not Saved");
    }
}


-(void) loadNewsFromFile {
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedNewsArray"];
    
    NSArray* arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arr.count>0) {
        newsItems = [[NSMutableArray alloc] initWithArray:arr];
    }else{
        newsItems = [[NSMutableArray alloc] init];
    }
    
}

-(void) saveNewsToFile {
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"mySavedNewsArray"];
    BOOL succeed = [[NSKeyedArchiver archivedDataWithRootObject:newsItems] writeToFile:filePath atomically:YES];
    if (!succeed){ // do something  }
        NSLog(@"Newsitems not Saved");
    }
}

-(NSString*)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    return documentsDirectory;
}

-(void)viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    newsItems = nil;
    newsArticles = nil;
    priorityQueue = nil;
    rssFeed = nil;
    selectedItem = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
