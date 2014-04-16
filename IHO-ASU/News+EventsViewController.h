//
//  News+EventsViewController.h
//  IHO
//
//  Created by Cynosure on 11/17/13.
//  Copyright (c) 2013 asu. All rights reserved.
//


#import <sqlite3.h>
#import <UIKit/UIKit.h>

@class NewsDetailViewController;

@interface News_EventsViewController : UITableViewController

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *asuIHO;


-(NSArray *) newsDetailInfo;

@end
