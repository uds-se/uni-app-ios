//
//  CategorieTableViewController.m
//  SaarlandUniversityApp
//
//  Created by Tom Michels on 13.04.13.
//  Copyright (c) 2013 Universität des Saarlandes. All rights reserved.
//

#import "CategorieTableViewController.h"

@interface CategorieTableViewController ()

@end

@implementation CategorieTableViewController

@synthesize delegate, selectedCampus;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategorieCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    cell.categorieTitleLabel.text = NSLocalizedString(((NSString*)[self.categoriesArr objectAtIndex:indexPath.row]),nil);
    [cell.categorieTitleLabel setNumberOfLines:2];
    [cell.categorieTitleLabel setFont:[UIFont systemFontOfSize:13]];
    CGRect cg = [cell.categorieTitleLabel frame];
    [cell.categorieTitleLabel setFrame:CGRectMake(cg.origin.x, cg.origin.y-2, cg.size.width, cg.size.height+6)];
    // cell text can be overwritten here. Categorie will be pinned using ID
    int ID = [[self.IDArr objectAtIndex:indexPath.row] integerValue];
    cell.tag =  ID;
    cell.categorieImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"cat%d",ID]];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString: @"showDetails"]) {
        DetailedPOIListViewController *myDetViewCont = segue.destinationViewController;
        myDetViewCont.delegate = self.delegate;
        myDetViewCont.selectedCampus = self.selectedCampus;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];

        int ID = [[self.IDArr objectAtIndex:selectedIndexPath.row] integerValue];
        myDetViewCont.categorieID =  ID;
        
        myDetViewCont.categorieTitle = NSLocalizedString(((NSString*)[self.categoriesArr objectAtIndex:selectedIndexPath.row]),nil);
        //myDetViewCont.categoriesArr = [self.database getAllCategorieTitles];
    }
}

@end
