//
//  SettingsViewController.h
//  Uni Saar
//
//  Created by Daniel on 04/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    NSArray *SettingItems;
    NSMutableArray *SettingCurrentItems;
    NSArray *MensaItems;
    NSArray *BuildingItems;
    NSArray *LanguageItems;
    NSArray *SettingDetailItems;
    NSIndexPath *SettingCurrentlyAt;
    NSUserDefaults *defaults;
    
}

@property (weak, nonatomic) IBOutlet UITableView *SettingsTableView;
@property (weak, nonatomic) IBOutlet UITableView *SettingsDetailTableView;

- (void) loadCurrentSettings;
- (void) saveCampus:(NSInteger)option;

@end
