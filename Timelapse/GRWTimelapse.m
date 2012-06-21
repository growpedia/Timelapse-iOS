//
//  GRWTimelapse.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWTimelapse.h"
#import "JSONKit.h"

#define FILENAME @"metadata.json"
#define METADATA_NAME @"name"
#define METADATA_DESCRIPTION @"description"
#define METADATA_CREATION @"creation_date"
#define METADATA_MODIFIED @"modified_date"
#define ISO_8601 @"yyyy-MM-dd HH:mm:ss.SSS'Z'"

@interface GRWTimelapse(Private)
- (void) loadMetadata;
- (void) loadDefaults;
- (void) loadImages;
@end

@implementation GRWTimelapse
@synthesize name, description, creationDate, modifiedDate, directoryPath, images;

- (void) dealloc {
    self.name = nil;
    self.description = nil;
    self.creationDate = nil;
    self.modifiedDate = nil;
    self.directoryPath = nil;
    self.images = nil;
}


- (id) initWithDirectoryPath:(NSString*)path {
    if (self = [super init]) {
        self.directoryPath = path;
        [self loadMetadata];
        [self loadImages];
    }
    return self;
}

- (void) loadMetadata {
    NSString *metadataPath = [directoryPath stringByAppendingPathComponent:FILENAME];
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:metadataPath options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"Error loading metadata file: %@%@", [error localizedDescription], [error userInfo]);
        [self loadDefaults];
        return;
    }
    JSONDecoder *decoder = [JSONDecoder decoder];
    NSDictionary *metadataDictionary = [decoder objectWithData:jsonData error:&error];
    if (error) {
        NSLog(@"Error parsing metadata json: %@%@", [error localizedDescription], [error userInfo]);
        [self loadDefaults];
        return;
    }
    self.name = [metadataDictionary objectForKey:METADATA_NAME];
    self.description = [metadataDictionary objectForKey:METADATA_DESCRIPTION];
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    
    NSString *creationString = [metadataDictionary objectForKey:METADATA_CREATION];
    NSString *modifiedString = [metadataDictionary objectForKey:METADATA_MODIFIED];
    
    self.creationDate = [dateFormatter dateFromString:creationString];
    if (!creationDate) {
        self.creationDate = [NSDate date];
    }
    self.modifiedDate = [dateFormatter dateFromString:modifiedString];
    if (!modifiedDate) {
        self.modifiedDate = [NSDate date];
    }
}

- (NSDateFormatter*) dateFormatter 
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = ISO_8601;
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return dateFormatter;
}

- (void) loadDefaults {
    self.name = @"Timelapse";
    self.description = @"";
    self.creationDate = [NSDate date];
    self.modifiedDate = [NSDate date];
}

- (void) loadImages {
    
}

- (void) saveMetadata {
    NSMutableDictionary *metadataDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSString *creationString = [dateFormatter stringFromDate:self.creationDate];
    NSString *modifiedString = [dateFormatter stringFromDate:self.modifiedDate];
    
    if (!name) {
        self.name = @"";
    }
    if (!description) {
        self.description = @"";
    }
    
    [metadataDictionary setObject:name forKey:METADATA_NAME];
    [metadataDictionary setObject:description forKey:METADATA_DESCRIPTION];
    [metadataDictionary setObject:creationString forKey:METADATA_CREATION];
    [metadataDictionary setObject:modifiedString forKey:METADATA_MODIFIED];
    
    NSError *error = nil;
    NSData *jsonData = [metadataDictionary JSONDataWithOptions:JKSerializeOptionPretty error:&error];
    if (error) {
        NSLog(@"Error creating metadata JSON: %@%@",[error localizedDescription], [error userInfo]);
        return;
    }
    NSString *metadataPath = [directoryPath stringByAppendingPathComponent:FILENAME];
    [jsonData writeToFile:metadataPath options:NSDataWritingAtomic error:&error];
    if (error) {
        NSLog(@"Error writing metadata JSON: %@%@", [error localizedDescription], [error userInfo]);
        return;
    }
}

@end
