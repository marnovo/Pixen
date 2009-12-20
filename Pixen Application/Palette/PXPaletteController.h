//
//  PXPaletteController.h
//  Pixen
//
//  Created by Joe Osborn on 2007.12.12.
//  Copyright 2007 Open Sword Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXCanvas.h"
@class PXCanvas, PXPalettePanelPaletteView;
@interface PXPaletteController : NSObject
{
	PXCanvas *canvas;
	PXPalette *frequencyPalette, *recentPalette, *listPalette;
	IBOutlet PXPalettePanelPaletteView *paletteView;
	IBOutlet NSView *view;
}

- view;
- (BOOL)isPaletteIndexKey:(NSEvent *)event;
- (void)keyDown:(NSEvent *)event;

- (IBAction)useMostRecentColors:sender;
- (IBAction)useMostFrequentColors:sender;
- (IBAction)useColorListColors:sender;

- (void)refreshPalette:(NSNotification *)note;
- (void)updatePalette:(NSNotification *)note;

@end
