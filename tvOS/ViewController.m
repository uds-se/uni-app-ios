//
//  ViewController.m
//  tvOS
//
//  Created by Daniel on 01/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://www.uni-saarland.de/aktuelles/presse/pms.html"];
    NSData  *data      = [NSData dataWithContentsOfURL:url];
    TFHpple *Parser = [TFHpple hppleWithHTMLData:data];
    NSString *QueryString = @"//div[@class='news-list-item']//span | //div[@class='news-list-item']//h1 | //div[@class='news-list-item']//p | //div//h1//a/@href";
    NSArray *Nodes = [Parser searchWithXPathQuery:QueryString];
    
    NSMutableArray *Content = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement * elem in Nodes) {
        [Content addObject:[elem content]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
