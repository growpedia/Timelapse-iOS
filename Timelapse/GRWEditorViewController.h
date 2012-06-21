//
//  GRWEditorViewController.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRWTimelapse.h"

@interface GRWEditorViewController : UIViewController <UISplitViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *descriptionField;
@property (nonatomic, retain) GRWTimelapse *timelapse;

@end
