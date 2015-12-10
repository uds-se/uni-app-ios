//
//  SettingsViewController.m
//  Uni Saar
//
//  Created by Daniel on 04/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize SettingsTableView;
@synthesize SettingsDetailTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SettingItems = [NSArray arrayWithObjects:@"Campus", @"Kiosk Mode Interval", @"Language", @"Building", nil];
    MensaItems = [NSArray arrayWithObjects:@"Saarbrücken", @"Homburg", nil];
    BuildingItems = [NSArray arrayWithObjects:@"Building1", @"Building2", @"Building3", nil];
    LanguageItems = [NSArray arrayWithObjects:@"Automatically chosen depending ", @"on system language.", nil];
    IntervalItems = [NSArray arrayWithObjects:@"10", @"20", @"30", @"60", nil];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"de", nil] forKey:@"AppleLanguages"];
    defaults = [NSUserDefaults standardUserDefaults];
    SettingCurrentItems = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadCurrentSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == [self SettingsTableView]) {
        return [SettingItems count];
    }
    else {
        return [SettingDetailItems count];
    }    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == [self SettingsTableView]) {
        static NSString *CellIdentifier = @"SettingsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [SettingItems objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [SettingCurrentItems objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"SettingsDetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [SettingDetailItems objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [SettingDetailItems objectAtIndex:indexPath.row];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == [self SettingsTableView]) {
        SettingCurrentlyAt = indexPath;
        switch (indexPath.row) {
            case 0:
                SettingDetailItems = MensaItems;
                SettingsDetailTableView.allowsSelection = YES;
                break;
            case 1:
                SettingDetailItems = IntervalItems;
                SettingsDetailTableView.allowsSelection = YES;
                break;
            case 2:
                SettingDetailItems = LanguageItems;
                SettingsDetailTableView.allowsSelection = NO;
                break;
            case 3:
                SettingDetailItems = BuildingItems;
                SettingsDetailTableView.allowsSelection = YES;
            default:
                break;
        }
        [SettingsDetailTableView reloadData];
    }
    else {
        //save setting with SettingCurrentlyAt und SettingDetailItems objectAtIndex:indexPath.row
        switch (SettingCurrentlyAt.row) {
            case 0:
                [self saveCampus:indexPath.row];
                break;
            case 1:
                [self saveInterval:indexPath.row];
                break;
            case 2:
                break;
            case 3:
                break;
            default:
                break;
        }
        [self loadCurrentSettings];
        [SettingsTableView reloadData];
        
    }
}

- (void) loadCurrentSettings {
    NSString *campus_selected = [defaults objectForKey:@"campus_selected"];
    NSString *interval_selected = [defaults objectForKey:@"interval_selected"];
    [SettingCurrentItems removeAllObjects];
    if (([campus_selected length] > 0) && [campus_selected isEqualToString:@"hom"]) {
        [SettingCurrentItems addObject:@"Homburg"];
    }
    else {
        [SettingCurrentItems addObject:@"Saarbrücken"];
    }
    if ([interval_selected length] > 0) {
        [SettingCurrentItems addObject:interval_selected];
    }
    else {
        [SettingCurrentItems addObject:@"10"];
    }
    [SettingCurrentItems addObject:[[NSLocale preferredLanguages] objectAtIndex:0]];
    [SettingCurrentItems addObject:@"none"];
}

- (void) saveCampus:(NSInteger)option {
    if (option == 0) {
        [defaults setObject:@"saar" forKey:@"campus_selected"];
        [defaults synchronize];
    }
    else {
        [defaults setObject:@"hom" forKey:@"campus_selected"];
        [defaults synchronize];
    }
}

- (void) saveInterval:(NSInteger)option {
    [defaults setObject:[IntervalItems objectAtIndex:option] forKey:@"interval_selected"];
    [defaults synchronize];
}



@end








