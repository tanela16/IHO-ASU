//
//  News+EventsViewController.m
//  IHO
//
//  Created by Cynosure on 11/17/13.
//  Copyright (c) 2013 asu. All rights reserved.
//

#import "News+EventsViewController.h"
#import "NewsDetailViewController.h"
#import "NewsDetail.h"

@interface News_EventsViewController ()
{
    NSArray *newsItems;
}
@end

@implementation News_EventsViewController

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
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    //menubar specifications
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.62f alpha:1.0 ]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    newsItems = [[NSArray alloc] init];
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"asuIHO" ofType:@"db"];
    
    if (sqlite3_open([sqLiteDb UTF8String],&_asuIHO)==SQLITE_OK)
    {
        newsItems = [self newsDetailInfo];
    }
    
}


-(NSArray *) newsDetailInfo{
    
    NSMutableArray *obj = [[NSMutableArray alloc ] init ];
    sqlite3_stmt *statement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT NewsId,NewsTitle,NewsImage,NewsText,NewsLink FROM News"];
    const char *query_stmt = [query UTF8String];
    if(sqlite3_prepare_v2(_asuIHO,query_stmt,-1,&statement,NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            int iD = sqlite3_column_int(statement, 0);
            
            //read data from the result
            NSString *title =  [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 2) length:sqlite3_column_bytes(statement, 2)];
            NSString *text = [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *link  = [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NewsDetail *newItem = [[NewsDetail alloc] initWithnewsid:iD newstitle:title image:imgData text:text newslink:link];
            if(title==nil)
                NSLog(@"No data present");
            else
                //UIImage *img = [[UIImage alloc]initWithData:imgData ];
                [obj addObject:newItem];
            
            
            NSLog(@"retrieved data");
            
        }
    }
    sqlite3_finalize(statement);
    
    sqlite3_close(_asuIHO);
    return obj;
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [newsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
      //imageView.image = [images objectAtIndex:indexPath.row];
   
    NewsDetail *Item = [newsItems objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.62f alpha:1.0 ]];
    [cell.textLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [cell.textLabel setText:[NSString stringWithString:Item.newslink]];
    
    
    // Configure the cell...
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
   
    NewsDetail *info = [newsItems objectAtIndex:indexPath.row];
    NewsDetailViewController *getDetails = segue.destinationViewController;
    getDetails.newsId = info.newsId;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
