//
//  GRWBrowserViewController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWBrowserViewController.h"
#import "GRWStrings.h"
#import "GRWTimelapse.h"
#import "GRWTimelapseEditorViewController.h"

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
        self.timelapseController = [[GRWTimelapseController alloc] init];
        self.title = BROWSER_TITLE;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTimelapse:)];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    self.browserTableView.frame = self.view.bounds;
    self.browserTableView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    [self.browserTableView reloadData];
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
    [self.view addSubview:browserTableView];
}

- (void) newTimelapse:(id)sender 
{
    GRWTimelapse *timelapse = [timelapseController newTimelapse];
    [self editTimelapse:timelapse];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) editTimelapse:(GRWTimelapse*)timelapse
{
    GRWTimelapseEditorViewController *timelapseEditor = [[GRWTimelapseEditorViewController alloc] initWithTimelapse:timelapse];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:timelapseEditor];
    [self presentModalViewController:navController animated:YES];
}

#pragma mark UITableViewDelegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    GRWTimelapse *timelapse = [timelapseController.timelapses objectAtIndex:indexPath.row];
    [self editTimelapse:timelapse];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark UITableViewDataSource methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [timelapseController.timelapses count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    GRWTimelapse *timelapse = [timelapseController.timelapses objectAtIndex:indexPath.row];
    cell.textLabel.text = timelapse.name;
    cell.detailTextLabel.text = timelapse.description;
    return cell;
}

@end
