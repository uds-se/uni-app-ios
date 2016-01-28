//
//  MensaDataSourceAndDelegate.h
//  Uni Saar
//
//  Created by Daniel on 08/12/15.
//  Copyright © 2015 Universität des Saarlandes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"
#import "MensaKioskItem.h"
#import "CustomMensaKioskCell.h"


@interface MensaDataSourceAndDelegate : UITableView<UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *MensaContent;
    NSMutableArray *MensaContentClean;
    NSMutableArray *MensaContentMerged;
    NSMutableArray *MensaMenus;
    NSMutableArray *Menu1;
    NSMutableArray *Menu2;
    NSMutableArray *Menu3;
    NSMutableArray *CurrentMenus;
    
    
}

- (void) loadData;
- (void) setData1;
- (void) setData2;
- (void) setData3;
- (void) splitMenus;
- (NSInteger) getDay;

@end
