//
//  AppDelegate.h
//  SaarlandUniversityAppB
//
//  Created by Tobias Tykvart on 25.6.12.
//  Copyright (c) 2012 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableString *QueryURL;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableString *QueryURL;
@property (strong, nonatomic) NSURL *detailURL;
@end
