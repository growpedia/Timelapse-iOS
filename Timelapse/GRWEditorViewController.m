//
//  GRWEditorViewController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWEditorViewController.h"
#import "GRWStrings.h"

@interface GRWEditorViewController ()

@end

@implementation GRWEditorViewController
@synthesize nameField, descriptionField, timelapse, imagePicker, imageView;


- (void) dealloc {
    self.nameField = nil;
    self.descriptionField = nil;
    self.timelapse = nil;
    self.imagePicker = nil;
    self.imageView = nil;
}

- (id)init
{
    if (self = [super init]) {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.nameField.delegate = self;
        self.descriptionField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.descriptionField.delegate = self;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhotoPressed:)];
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return self;
}
                                        
- (void) takePhotoPressed:(id)sender {
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[timelapse.images lastObject]];
    overlayImageView.alpha = 0.5;
    CGFloat bottomControlsHeight = 53.0;
    overlayImageView.frame = CGRectMake(0, 0, 320, 480-bottomControlsHeight);
    self.imagePicker.cameraOverlayView = overlayImageView;
    [self presentModalViewController:imagePicker animated:YES];
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
    [self.view addSubview:descriptionField];
    [self.view addSubview:imageView];
    
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.placeholder = NAME_WORD;
    self.nameField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.descriptionField.borderStyle = UITextBorderStyleRoundedRect;
    self.descriptionField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.descriptionField.placeholder = DESCRIPTION_WORD;
    self.descriptionField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat fieldHeight = 30.0;
    self.nameField.frame = CGRectMake(0, 0, self.view.frame.size.width/2, fieldHeight);
    self.descriptionField.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, fieldHeight);
    self.imageView.frame = CGRectMake(0, fieldHeight, self.view.frame.size.width, self.view.frame.size.height-fieldHeight);
    [self refreshFields];
}

- (void) refreshFields {
    self.nameField.text = timelapse.name;
    self.descriptionField.text = timelapse.description;
    self.imageView.image = [timelapse.images lastObject];
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

#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imagePicker dismissModalViewControllerAnimated:YES];
    [self.timelapse addImage:image];
    [self refreshFields];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissModalViewControllerAnimated:YES];
}

- (void) didReceiveMemoryWarning {
    NSLog(@"Memory warning!");
}

@end
