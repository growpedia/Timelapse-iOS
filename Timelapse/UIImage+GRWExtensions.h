//
//  UIImage+UIImage_GRWExtensions.h
//  Timelapse
//
//  Created by Chris Ballinger on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more

#import <UIKit/UIKit.h>

@interface UIImage (GRWExtensions)

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
