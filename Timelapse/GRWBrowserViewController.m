//
//  GRWBrowserViewController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWBrowserViewController.h"
#import "Strings.h"

@interface GRWBrowserViewController ()

@end

@implementation GRWBrowserViewController
@synthesize browserTableView;

- (void) dealloc 
{
    self.browserTableView = nil;
}

- (id)init
{
    if (self = [super init]) 
    {
        self.browserTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.title = BROWSER_TITLE;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    self.browserTableView.frame = self.view.bounds;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTimelapse:)];
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
    [self.view addSubview:browserTableView];
}

- (void) newTimelapse:(id)sender 
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
