//
//  GRWTimelapse.m
//  Timelapse
//
//  Created by Chris Ballinger on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRWTimelapse.h"
#import "JSONKit.h"
#import "UIImage+Resize.h"

#define FILENAME @"metadata.json"
#define METADATA_NAME @"name"
#define METADATA_DESCRIPTION @"description"
#define METADATA_CREATION @"creation_date"
#define METADATA_MODIFIED @"modified_date"
#define METADATA_IMAGECOUNT @"image_count"
#define ISO_8601 @"yyyy-MM-dd HH:mm:ss.SSS'Z'"

@interface GRWTimelapse(Private)
- (void) loadMetadata;
- (void) loadDefaults;
- (void) loadImages;
- (NSString*) lastImagePath;
@end

@implementation GRWTimelapse
@synthesize name, description, creationDate, modifiedDate, directoryPath, images, thumbnail, lastImage, imageCount;

- (void) dealloc {
    self.name = nil;
    self.description = nil;
    self.creationDate = nil;
    self.modifiedDate = nil;
    self.directoryPath = nil;
    self.images = nil;
    self.thumbnail = nil;
    self.lastImage = nil;
}


- (id) initWithDirectoryPath:(NSString*)path {
    if (self = [super init]) {
        self.directoryPath = path;
        [self loadMetadata];
        if (imageCount > 0) {
            [self loadImages];
        }
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
    self.imageCount = [[metadataDictionary objectForKey:METADATA_IMAGECOUNT] integerValue]; 
}

- (NSDateFormatter*) dateFormatter 
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = ISO_8601;
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return dateFormatter;
}

- (void) loadDefaults {
    NSString *directoryName = [directoryPath lastPathComponent];
    int directoryIndex = [directoryName intValue];
    self.name = [NSString stringWithFormat:@"Timelapse %d", directoryIndex+1];
    self.description = @"";
    self.creationDate = [NSDate date];
    self.modifiedDate = [NSDate date];
    self.imageCount = 0;
}

- (void) loadImages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.images = [NSMutableArray arrayWithCapacity:imageCount];
        NSLog(@"Loading last image: %@", [self lastImagePath]);
        UIImage *rawLastImage = [[UIImage alloc] initWithContentsOfFile:[self lastImagePath]];
        self.lastImage = [rawLastImage resizedImage:CGSizeMake(1024, 1024) interpolationQuality:kCGInterpolationHigh];
        self.thumbnail = [rawLastImage thumbnailImage:80 transparentBorder:5 cornerRadius:10 interpolationQuality:kCGInterpolationHigh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGRWTimelapseImagesLoadedNotification object:self];
        });
        for (int i = 0; i < (imageCount-1); i++) {
            NSString *imagePath = [self pathForImage:i];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            if (image) {
                NSLog(@"Loading image: %@", imagePath);
                UIImage *scaledImage = [image resizedImage:CGSizeMake(1024, 1024) interpolationQuality:kCGInterpolationHigh];
                [self.images addObject:scaledImage];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGRWTimelapseImagesLoadedNotification object:self];
                });
            }
        }
        [self.images addObject:lastImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGRWTimelapseImagesLoadedNotification object:self];
        });
    });
}

- (void) saveMetadata {
    NSMutableDictionary *metadataDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSString *creationString = [dateFormatter stringFromDate:self.creationDate];
    self.modifiedDate = [NSDate date];
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
    [metadataDictionary setObject:[NSNumber numberWithUnsignedInteger:imageCount] forKey:METADATA_IMAGECOUNT];
    
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
                                  
- (NSString*) lastImagePath {
    return [self pathForImage:imageCount-1];
}

- (NSString*) pathForImage:(NSUInteger)imageNumber {
    return [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpeg",imageNumber]];
}

- (void) addImage:(UIImage*)newImage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        imageCount++;
        NSData *jpegData = UIImageJPEGRepresentation(newImage, 1.0);
        NSString *jpegFilePath = [self lastImagePath];
        NSError *error = nil;
        [jpegData writeToFile:jpegFilePath options:NSDataWritingAtomic error:&error];
        if (error) {
            NSLog(@"Error writing JPEG: %@%@", [error localizedDescription], [error userInfo]);
        }
        UIImage *scaledImage = [newImage resizedImage:CGSizeMake(1024, 1024) interpolationQuality:kCGInterpolationHigh];
        self.lastImage = scaledImage;
        self.thumbnail = [newImage thumbnailImage:80 transparentBorder:5 cornerRadius:10 interpolationQuality:kCGInterpolationHigh];
        [self.images addObject:scaledImage];
        [self saveMetadata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGRWTimelapseImagesLoadedNotification object:self];
        });
    });
}

@end
