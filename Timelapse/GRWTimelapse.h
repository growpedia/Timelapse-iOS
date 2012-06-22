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

#define kGRWTimelapseImagesLoadedNotification @"kGRWTimelapseImagesLoadedNotification"

@interface GRWTimelapse : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSDate *modifiedDate;
@property (nonatomic, retain) NSString *directoryPath;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) UIImage *lastImage;
@property (nonatomic) NSUInteger imageCount;

- (id) initWithDirectoryPath:(NSString*)path;

- (void) saveMetadata;
- (void) addImage:(UIImage*)newImage;

@end
