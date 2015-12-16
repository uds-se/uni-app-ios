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
    animationSpeed = 1;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *interval_selected = [defaults objectForKey:@"interval_selected"];
    if ([interval_selected length] > 0) {
        interval = [interval_selected integerValue];
    }
    else {
        interval = 10;
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
       
        [NewsTable loadData];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [AiKiosk startAnimating];
            AiKiosk.hidden = true;
            KioskModeTitel.hidden = false;
            KioskModeTitel.alpha = 0;
            [self showNews1];
            
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNews1 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        NewsTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [NewsTable setData1];
            [NewsTableView reloadData];
            KioskModeTitel.text = NSLocalizedStringFromTable(@"News", @"tvosLocalisation", nil);
            [UIView animateWithDuration:animationSpeed animations:^(){
                NewsTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showNews2)];
}

- (void)showNews2 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        NewsTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [NewsTable setData2];
            [NewsTableView reloadData];
            KioskModeTitel.text = NSLocalizedStringFromTable(@"News", @"tvosLocalisation", nil);
//            KioskModeTitel.font = [UIFont systemFontOfSize:76];
            [UIView animateWithDuration:animationSpeed animations:^(){
                NewsTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showNews1)];
}

- (void)switchToNextView:(SEL)selector {
    [self performSelector:selector withObject:nil afterDelay:interval];
}












@end
