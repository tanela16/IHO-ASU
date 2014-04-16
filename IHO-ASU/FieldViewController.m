//
//  FieldViewController.m
//  IHO
//
//  Created by Cynosure on 12/11/13.
//  Copyright (c) 2013 asu. All rights reserved.
//

#import "FieldViewController.h"
#import "LecturerDetail.h"
#import "LecturerDetailsViewController.h"

@interface FieldViewController ()
{
NSArray *lectItems;
}
@end

@implementation FieldViewController

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
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.22f green:0.42f blue:0.62f alpha:1.0 ]];
    lectItems = [[NSArray alloc] init];
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"asuIHO" ofType:@"db"];
    
    if (sqlite3_open([sqLiteDb UTF8String],&_asuIHO)==SQLITE_OK)
    {
        lectItems = [self lectDetailInfo];
        
    }
}



-(NSArray *) lectDetailInfo{
    
    NSMutableArray *obj = [[NSMutableArray alloc ] init ];
    sqlite3_stmt *statement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT LectID,Name,Image,Title,Bio,Link,Email FROM Lecturer"];
    const char *query_stmt = [query UTF8String];
    if(sqlite3_prepare_v2(_asuIHO,query_stmt,-1,&statement,NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            
            int LectID = sqlite3_column_int(statement, 0);
            
            //read data from the result
            NSString *Name =  [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSData *imgData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 2) length:sqlite3_column_bytes(statement, 2)];
             NSString *title =  [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *Bio = [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSString *link  = [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            NSString *email =  [NSString  stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            LecturerDetail *newItem = [[LecturerDetail alloc] initWithLectid:LectID name:Name title:title image:imgData bio:Bio link:link email:email];
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
    if(section==0)
    return [lectItems count];
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
   
    if(section==0)
        return @"Choose a lecture";
    else if(section==1)
        return @"New Science";
    else if(section==2)
        return @"Who is Lucy?";
    
   return @"Student Blog-Notes from the Field";
       
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *CellIdentifier = @"newsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
      if(indexPath.section==0){
    //imageView.image = [images objectAtIndex:indexPath.row];
  
    LecturerDetail *Item = [lectItems objectAtIndex:indexPath.row];
     [cell.textLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
    [cell.textLabel setText:[NSString stringWithString:Item.name]];
    
    }
    if(indexPath.section==1){
       
    }
    if(indexPath.section==2){
        
    }
    if(indexPath.section==3){
        
    }
    // Configure the cell...
    
    return nil;;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
   LecturerDetail *info = [lectItems objectAtIndex:indexPath.row];
    LecturerDetailsViewController *getDetails = segue.destinationViewController;
    getDetails.lectID= info.lectID;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
