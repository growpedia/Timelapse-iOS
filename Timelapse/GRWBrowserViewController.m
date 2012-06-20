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
@synthesize browserTableView, timelapseController;

- (void) dealloc 
{
    self.browserTableView = nil;
    self.timelapseController = nil;
}

- (id)init
{
    if (self = [super init]) 
    {
        self.browserTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.browserTableView.delegate = self;
        self.browserTableView.dataSource = self;
        self.title = BROWSER_TITLE;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    self.browserTableView.frame = self.view.bounds;
    self.browserTableView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
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
    return YES;
}

#pragma mark UITableViewDelegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.text = @"Asdf";
        cell.detailTextLabel.text= @"Fdsa";
    }
    return cell;
}

@end
