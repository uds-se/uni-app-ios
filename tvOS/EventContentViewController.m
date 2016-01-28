//
//  EventContentViewController.m
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "EventContentViewController.h"

@interface EventContentViewController ()

@end

@implementation EventContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.TitleView.text = [[self event] title];
    self.SubTitleView.text = [[self event] subTitle];
    
    
    [AiEventContent startAnimating];
    AiEventContent.hidden = false;
   
    
    self.ContentView.userInteractionEnabled = true;
    self.ContentView.scrollEnabled = true;
    self.ContentView.panGestureRecognizer.allowedTouchTypes = @[ @(UITouchTypeIndirect) ];
    self.ContentView.showsVerticalScrollIndicator = true;
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSMutableArray *EventContent = [Parser parseWithURL:[[self event] description] andWithPath:@"//div[@class='newscontent']"];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if  ([EventContent count] > 0) {
                self.ContentView.text = [EventContent objectAtIndex:0];
                AiEventContent.hidden = true;
                [AiEventContent stopAnimating];
            }
            
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
