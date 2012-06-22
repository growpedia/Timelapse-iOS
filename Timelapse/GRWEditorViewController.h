//
//  GRWEditorViewController.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRWTimelapse.h"

@interface GRWEditorViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *descriptionField;
@property (nonatomic, retain) GRWTimelapse *timelapse;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UISlider *slider;

@end
