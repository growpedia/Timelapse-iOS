//
//  GRWTimelapseController.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRWTimelapse.h"

@interface GRWTimelapseController : NSObject

@property (nonatomic, retain) NSMutableArray *timelapses;

- (GRWTimelapse*) newTimelapse;

@end
