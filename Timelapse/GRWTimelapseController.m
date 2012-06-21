//
//  GRWTimelapseController.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define TIMELAPSE_COUNT_KEY @"timelapse_count"

#import "GRWTimelapseController.h"
#import "GRWTimelapse.h"


@implementation GRWTimelapseController
@synthesize timelapses;

- (id) init 
{
    if (self = [super init]) 
    {
        NSString *documentsDirectory = [self documentsDirectory];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *folderNames = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error) {
            NSLog(@"Error reading documents directory: %@%@", [error localizedDescription], [error userInfo]);
            error = nil;
        }
        self.timelapses = [NSMutableArray arrayWithCapacity:[folderNames count]];
        for (NSString *folderName in folderNames) {
            NSLog(@"Loading Timelapse: %@", folderName);
            NSString *timelapsePath = [documentsDirectory stringByAppendingPathComponent:folderName];
            GRWTimelapse *timelapse = [[GRWTimelapse alloc] initWithDirectoryPath:timelapsePath];
            [timelapses addObject:timelapse];
        }
        
    }
    return self;
}

- (NSString*) documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (GRWTimelapse*) newTimelapse {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int timelapseCount = [[defaults objectForKey:TIMELAPSE_COUNT_KEY] intValue];
    NSString *documentsDirectory = [self documentsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", timelapseCount]];
    
    [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:&error];
    if (error) {
        NSLog(@"Error creating directory: %@%@", [error localizedDescription], [error userInfo]);
    }
    timelapseCount++;
    [defaults setObject:[NSNumber numberWithInt:timelapseCount] forKey:TIMELAPSE_COUNT_KEY];
    [defaults synchronize];
    
    GRWTimelapse *timelapse = [[GRWTimelapse alloc] initWithDirectoryPath:directoryPath];
    [timelapse saveMetadata];
    [timelapses addObject:timelapse];
    return timelapse;
}

@end
