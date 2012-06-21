//
//  GRWTimelapseEditorViewController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWTimelapseEditorViewController.h"
#import "GRWStrings.h"

@interface GRWTimelapseEditorViewController ()

@end

@implementation GRWTimelapseEditorViewController
@synthesize nameField, nameLabel, descriptionField, descriptionLabel, timelapse;


- (void) dealloc {
    self.nameField = nil;
    self.nameLabel = nil;
    self.descriptionField = nil;
    self.descriptionLabel = nil;
    self.timelapse = nil;
}

- (id)init
{
    if (self = [super init]) {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.nameField.delegate = self;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.descriptionField.delegate = self;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhotoPressed:)];
    }
    return self;
}
                                        
- (void) takePhotoPressed:(id)sender {
    
}

- (void) setTimelapse:(GRWTimelapse *)newTimelapse {
    timelapse = newTimelapse;
    self.title = timelapse.name;
    [self refreshFields];

}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.timelapse.name = nameField.text;
    self.timelapse.description = descriptionField.text;
    [timelapse saveMetadata];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameField];
    [self.view addSubview:nameLabel];
    [self.view addSubview:descriptionField];
    [self.view addSubview:descriptionLabel];
    
    self.nameLabel.text = NAME_WORD;
    self.descriptionLabel.text = DESCRIPTION_WORD;
    
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.descriptionField.borderStyle = UITextBorderStyleRoundedRect;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameLabel.frame = CGRectMake(0, 0, 100, 50);
    self.nameField.frame = CGRectMake(100, 0, 200, 50);
    self.descriptionLabel.frame = CGRectMake(0, 100, 100, 50);
    self.descriptionField.frame = CGRectMake(100, 100, 200, 50);
    
    [self refreshFields];
}

- (void) refreshFields {
    self.nameField.text = timelapse.name;
    self.descriptionField.text = timelapse.description;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UISplitViewControllerDelegate methods

- (void) splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{  
    barButtonItem.title = BROWSER_TITLE;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
