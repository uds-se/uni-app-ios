//
//  KioskViewController.m
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "KioskViewController.h"

@interface KioskViewController ()

@end

@implementation KioskViewController

- (void)viewDidLoad {
    
    NewsTable = [[NewsDataSourceAndDelegate alloc]init];
    NewsTableView.dataSource = NewsTable;
    NewsTableView.delegate = NewsTable;
    
    [super viewDidLoad];
    
    NewsTableView.estimatedRowHeight = 150.0;
    NewsTableView.rowHeight = UITableViewAutomaticDimension;
    [AiKiosk startAnimating];
    AiKiosk.hidden = false;
    KioskModeTitel.hidden = true;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
       
        [NewsTable loadData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [AiKiosk startAnimating];
            AiKiosk.hidden = true;
            [self showNews1];
            KioskModeTitel.hidden = false;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNews1 {
    [NewsTable setData1];
    [NewsTableView reloadData];
    [self switchToNextView:@selector(showNews2)];
    KioskModeTitel.text = NSLocalizedStringFromTable(@"News", @"tvosLocalisation", nil);
}

- (void)showNews2 {    
    [NewsTable setData2];
    [NewsTableView reloadData];
    [self switchToNextView:@selector(showNews1)];
    KioskModeTitel.text = NSLocalizedStringFromTable(@"News", @"tvosLocalisation", nil);
}

- (void)switchToNextView:(SEL)selector {
    [self performSelector:selector withObject:nil afterDelay:5.0];
}












@end
