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
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (id) initWithTimelapse:(GRWTimelapse*)newTimelapse
{
    if (self = [self init]) {
        self.timelapse = newTimelapse;
        self.title = timelapse.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:DONE_WORD style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:CANCEL_WORD style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    }
    return self;
}

- (void) doneButtonPressed:(id)sender {
    self.timelapse.name = nameField.text;
    self.timelapse.description = descriptionField.text;
    [timelapse saveMetadata];
    [self dismissModalViewControllerAnimated:YES];
}
                                                 
- (void) cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    self.nameField.frame = CGRectMake(100, 0, 100, 50);
    self.descriptionLabel.frame = CGRectMake(0, 100, 100, 50);
    self.descriptionField.frame = CGRectMake(100, 100, 100, 50);
    
    self.nameField.text = timelapse.name;
    self.descriptionField.text = timelapse.description;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
