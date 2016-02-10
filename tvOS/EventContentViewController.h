//
//  EventContentViewController.h
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Parser.h"
#import "Reachability.h"

@interface EventContentViewController : UIViewController{



    __weak IBOutlet UILabel *NoInternet;
    __weak IBOutlet UIActivityIndicatorView *AiEventContent;

}
@property (weak, nonatomic) IBOutlet UILabel *TitleView;
@property (weak, nonatomic) IBOutlet UILabel *SubTitleView;
@property (weak, nonatomic) IBOutlet UITextView *ContentView;


@property (strong, nonatomic) Event *event;

@end
