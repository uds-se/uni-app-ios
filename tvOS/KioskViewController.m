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
    
    if ([Reachability hasInternetConnection]) {
        NoInternet.hidden = true;
    }
    else {
        NoInternet.hidden = false;
        NoInternet.text = NSLocalizedStringFromTable(@"NoInternet", @"tvosLocalisation", nil);
        
    }
    
    
    EventsTable = [[EventsDataSourceAndDelegate alloc]init];
    EventsTableView.dataSource = EventsTable;
    EventsTableView.delegate = EventsTable;
    MensaTable = [[MensaDataSourceAndDelegate alloc]init];
    MensaTableView.dataSource = MensaTable;
    MensaTableView.delegate = MensaTable;
    NewsTextSource = [[NewsSource alloc]init];
    
    [super viewDidLoad];
    
    EventsTableView.estimatedRowHeight = 150.0;
    EventsTableView.rowHeight = UITableViewAutomaticDimension;
    MensaTableView.estimatedRowHeight = 150.0;
    MensaTableView.rowHeight = UITableViewAutomaticDimension;
    [AiKiosk startAnimating];
    AiKiosk.hidden = false;
    KioskModeTitel.hidden = true;
    CampusImageView.alpha = 0;
    animationSpeed = 1;
    loopCount = 0;
    BackgroundLogo.hidden = true;
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *interval_selected = [defaults objectForKey:@"interval_selected"];
    if ([interval_selected length] > 0) {
        interval = [interval_selected integerValue];
    }
    else {
        interval = 20;
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
       
        [EventsTable loadData];
        [NewsTextSource loadData];
        [MensaTable loadData];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [AiKiosk stopAnimating];
            AiKiosk.hidden = true;
            KioskModeTitel.hidden = false;
            KioskModeTitel.alpha = 0;
            EventsTableView.alpha = 0;
            NewsTextView.alpha = 0;
            MensaTableView.alpha = 0;
            CampusImageView.alpha = 0;
            [self showNews1];
            
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkForRefresh {
    
    loopCount++;
    
    if (loopCount >= (400/interval)) {
        CampusImageView.alpha = 0;
        KioskModeTitel.alpha = 0;
        BackgroundLogo.alpha = 0.05;
        [AiKiosk startAnimating];
        AiKiosk.hidden = false;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [EventsTable loadData];
            [NewsTextSource loadData];
            [MensaTable loadData];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [AiKiosk stopAnimating];
                AiKiosk.hidden = true;
                KioskModeTitel.hidden = false;
                [self showNews1];
                
            });
        });
    }
    else {
        [self showNews1];
    }
    
    
}

- (void) showNews1 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        CampusImageView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([[NewsTextSource getNews1] count]==2) {
                NewsTextView.text = [[NewsTextSource getNews1] objectAtIndex:0];
                KioskModeTitel.text = [[NewsTextSource getNews1] objectAtIndex:1];
            }
            else {
                NewsTextView.text = @" ";
                KioskModeTitel.text = @" ";
            }
            [UIView animateWithDuration:animationSpeed animations:^(){
                NewsTextView.alpha = 1;
                KioskModeTitel.alpha = 1;
                BackgroundLogo.alpha = 0.05;
            }];
        }
    }];
    [self switchToNextView:@selector(showNews2)];
}

- (void) showNews2 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        NewsTextView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([[NewsTextSource getNews1] count]==2) {
                NewsTextView.text = [[NewsTextSource getNews2] objectAtIndex:0];
                KioskModeTitel.text = [[NewsTextSource getNews2] objectAtIndex:1];
            }
            else {
                NewsTextView.text = @" ";
                KioskModeTitel.text = @" ";
            }
            [UIView animateWithDuration:animationSpeed animations:^(){
                NewsTextView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showNews3)];
}

- (void) showNews3 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        NewsTextView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([[NewsTextSource getNews1] count]==2) {
                NewsTextView.text = [[NewsTextSource getNews3] objectAtIndex:0];
                KioskModeTitel.text = [[NewsTextSource getNews3] objectAtIndex:1];
            }
            else {
                NewsTextView.text = @" ";
                KioskModeTitel.text = @" ";
            }
            [UIView animateWithDuration:animationSpeed animations:^(){
                NewsTextView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showEvents1)];
}

- (void)showEvents1 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        NewsTextView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [EventsTable setData1];
            [EventsTableView reloadData];
            KioskModeTitel.text = NSLocalizedStringFromTable(@"Events", @"tvosLocalisation", nil);
            [UIView animateWithDuration:animationSpeed animations:^(){
                EventsTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showEvents2)];
}

- (void)showEvents2 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        EventsTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [EventsTable setData2];
            [EventsTableView reloadData];
            KioskModeTitel.text = NSLocalizedStringFromTable(@"Events", @"tvosLocalisation", nil);
//            KioskModeTitel.font = [UIFont systemFontOfSize:76];
            [UIView animateWithDuration:animationSpeed animations:^(){
                EventsTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    [self switchToNextView:@selector(showMensa1)];
}

- (void) showMensa1 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        EventsTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [MensaTable setData1];
            [MensaTableView reloadData];
            KioskModeTitel.text = [NSLocalizedStringFromTable(@"Mensa", @"tvosLocalisation", nil) stringByAppendingString:@" 1/3"];
            //            KioskModeTitel.font = [UIFont systemFontOfSize:76];
            [UIView animateWithDuration:animationSpeed animations:^(){
                MensaTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    if ([[MensaTable Menu1] count] > 0) {
        [self switchToNextView:@selector(showMensa2)];
    }
    else {
        [self performSelector:@selector(showMensa2) withObject:nil afterDelay:1];
    }
    
}

- (void) showMensa2 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        MensaTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [MensaTable setData2];
            [MensaTableView reloadData];
            KioskModeTitel.text = [NSLocalizedStringFromTable(@"Mensa", @"tvosLocalisation", nil) stringByAppendingString:@" 2/3"];
            //            KioskModeTitel.font = [UIFont systemFontOfSize:76];
            [UIView animateWithDuration:animationSpeed animations:^(){
                MensaTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    if ([[MensaTable Menu2] count] > 0) {
        [self switchToNextView:@selector(showMensa3)];
    }
    else {
        [self performSelector:@selector(showMensa3) withObject:nil afterDelay:1];
    }
}

- (void) showMensa3 {
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        MensaTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [MensaTable setData3];
            [MensaTableView reloadData];
            KioskModeTitel.text = [NSLocalizedStringFromTable(@"Mensa", @"tvosLocalisation", nil) stringByAppendingString:@" 3/3"];
            if ([[MensaTable Menu3] count] == 0) {
                KioskModeTitel.text = @"";
            }
            //            KioskModeTitel.font = [UIFont systemFontOfSize:76];
            [UIView animateWithDuration:animationSpeed animations:^(){
                MensaTableView.alpha = 1;
                KioskModeTitel.alpha = 1;
            }];
        }
    }];
    if ([[MensaTable Menu3] count] > 0) {
        [self switchToNextView:@selector(showMap)];
    }
    else {
        [self performSelector:@selector(showMap) withObject:nil afterDelay:1];
    }
    
}

- (void) showMap {
    
    
    [UIView animateWithDuration:animationSpeed animations:^(){
        MensaTableView.alpha = 0;
        KioskModeTitel.alpha = 0;
        BackgroundLogo.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            defaults = [NSUserDefaults standardUserDefaults];
            NSString *campus_selected = [defaults objectForKey:@"campus_selected"];
            if ([campus_selected isEqualToString:@"hom"]) {
                CampusMap.image = [UIImage imageNamed:@"campus_homburg.png"];
            }
            [UIView animateWithDuration:animationSpeed animations:^(){
                CampusImageView.alpha = 1;
                if ([campus_selected isEqualToString:@"hom"]) {
                    KioskModeTitel.text = @"Campus Homburg";
                    KioskModeTitel.alpha = 1;
                }
                else {
                    KioskModeTitel.text = @"";
                }
            }];
        }
    }];
    [self performSelector:@selector(checkForRefresh) withObject:nil afterDelay:(interval*3)];
    
}

- (void)switchToNextView:(SEL)selector {
    [self performSelector:selector withObject:nil afterDelay:interval];
}












@end
