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
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    
    if ([[defaults objectForKey:@"campus_selected"] length] == 0) {
        [defaults setObject:@"saar" forKey:@"campus_selected"];
        }
    if ([[defaults objectForKey:@"interval_selected"] length] == 0) {
        [defaults setObject:@"20" forKey:@"interval_selected"];
    }
    if ([[defaults objectForKey:@"building_selected"] length] == 0) {
        [defaults setObject:@"none" forKey:@"building_selected"];
    }
    [defaults synchronize];
    /*
    NSLog([defaults objectForKey:@"campus_selected"]);
    NSLog([defaults objectForKey:@"interval_selected"]);
    NSLog([defaults objectForKey:@"building_selected"]);
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
