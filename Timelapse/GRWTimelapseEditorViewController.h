//
//  GRWTimelapseEditorViewController.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRWTimelapse.h"

@interface GRWTimelapseEditorViewController : UIViewController

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *descriptionField;
@property (nonatomic, retain) GRWTimelapse *timelapse;

- (id) initWithTimelapse:(GRWTimelapse*)newTimelapse;

@end
