//
//  GRWBrowserViewController.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRWTimelapseController.h"

@interface GRWBrowserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *browserTableView;
@property (nonatomic, retain) GRWTimelapseController *timelapseController;

@end
