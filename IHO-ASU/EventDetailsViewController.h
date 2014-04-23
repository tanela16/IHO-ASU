//
//  EventDetailsViewController.h
//  IHO-ASU
//
//  Created by Cynosure on 4/23/14.
//  Copyright (c) 2014 ASU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailsViewController : UIViewController{
    int _eventID;
}
@property (weak, nonatomic) IBOutlet UITextView *whenDetail;

@property (weak, nonatomic) IBOutlet UITextView *whereDetail;

@property (weak, nonatomic) IBOutlet UITextView *descDetail;

- (IBAction)mapIt:(id)sender;

- (IBAction)registerLink:(id)sender;
@property (nonatomic,assign) int eventId;

@property (nonatomic) sqlite3 *asuIHO;

-(EventsDetail *)eventDetail:(int)eventId;


@end
