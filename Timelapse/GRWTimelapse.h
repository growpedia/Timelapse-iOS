//
//  GRWTimelapse.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 TimeLapse Model
 Name
 Description
 Date created
 Date modified
 String filepath to directory
 Array of image references*/

@interface GRWTimelapse : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSDate *modifiedDate;
@property (nonatomic, retain) NSString *directoryPath;
@property (nonatomic, retain) NSMutableArray *images;

- (id) initWithDirectoryPath:(NSString*)path;

@end
