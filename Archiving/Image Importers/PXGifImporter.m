//
//  PXGifImporter.m
//  Pixen
//
//  Copyright 2004-2012 Pixen Project. All rights reserved.
//

#import "PXGifImporter.h"

@implementation PXGifImporter

+ (BOOL)fileAtURLIsAnimated:(NSURL *)url
{
    NSImage *tempImage = [[NSImage alloc] initWithContentsOfURL:url];
    NSBitmapImageRep* gifRep = tempImage.representations.count ? tempImage.representations[0] : nil;
    int frameCount = [[gifRep valueForProperty: NSImageFrameCount] intValue];
    return (frameCount > 1);
}

@end
