//
//  GRWEditorViewController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWEditorViewController.h"
#import "GRWStrings.h"

@interface GRWEditorViewController (Private)
- (void) exportPressed:(id)sender;
- (void) deletePressed:(id)sender;
@end

@implementation GRWEditorViewController
@synthesize nameField, descriptionField, timelapse, imagePicker, imageView, slider, imageNavigationLabel, exportButton, deleteButton;


- (void) dealloc {
    self.nameField = nil;
    self.descriptionField = nil;
    self.timelapse = nil;
    self.imagePicker = nil;
    self.imageView = nil;
    self.slider = nil;
    self.imageNavigationLabel = nil;
    self.exportButton = nil;
    self.deleteButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
        [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        slider.value = slider.maximumValue;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFields) name:kGRWTimelapseImagesLoadedNotification object:nil];
        self.imageNavigationLabel = [[UIBarButtonItem alloc] initWithTitle:@"0/0" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(exportPressed:)];
        self.deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePressed:)];
        UIBarButtonItem	*flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolbarItems = [NSArray arrayWithObjects:imageNavigationLabel, deleteButton, flexibleSpace, exportButton, nil];
    }
    return self;
}

- (void) exportPressed:(id)sender {
    
}

- (void) deletePressed:(id)sender {
    
}
         

- (void) sliderValueChanged:(id)sender {
    NSUInteger sliderIndex = floor(([timelapse.images count]-1) * slider.value);
    if (sliderIndex < [timelapse.images count]) {
        UIImage *selectedImage = [timelapse.images objectAtIndex:sliderIndex];
        self.imageView.image = selectedImage;
    }
    self.imageNavigationLabel.title = [NSString stringWithFormat:@"%d/%d",sliderIndex+1, [timelapse.images count]];
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
    [self.view addSubview:slider];
    
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.placeholder = NAME_WORD;
    self.nameField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.descriptionField.borderStyle = UITextBorderStyleRoundedRect;
    self.descriptionField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.descriptionField.placeholder = DESCRIPTION_WORD;
    self.descriptionField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
    CGFloat fieldHeight = 30.0;
    self.nameField.frame = CGRectMake(0, 0, self.view.frame.size.width/2, fieldHeight);
    self.descriptionField.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, fieldHeight);
    CGFloat sliderHeight = 45.0;    
    self.slider.frame = CGRectMake(0, self.view.frame.size.height-sliderHeight, self.view.frame.size.width, sliderHeight);
    self.imageView.frame = CGRectMake(0, fieldHeight, self.view.frame.size.width, self.view.frame.size.height-fieldHeight-sliderHeight);
    [self refreshFields];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void) refreshFields {
    self.nameField.text = timelapse.name;
    self.descriptionField.text = timelapse.description;
    self.imageView.image = timelapse.lastImage;
    self.slider.value = self.slider.maximumValue;
    [self sliderValueChanged:nil];
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
