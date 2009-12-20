//
//  PXPaletteController.m
//  Pixen
//
//  Created by Joe Osborn on 2007.12.12.
//  Copyright 2007 Open Sword Group. All rights reserved.
//

#import "PXPaletteController.h"

#import "PXPalettePanelPaletteView.h"
#import "PXToolSwitcher.h"
#import "PXToolPaletteController.h"
#import "PXCanvas.h"
#import "PXCanvas_Layers.h"
#import "PXPalette.h"
#import "PXDocument.h"

@implementation PXPaletteController

- init
{
	[super init];
	[NSBundle loadNibNamed:@"PXPaletteController" owner:self];
  frequencyPalette = PXPalette_initWithoutBackgroundColor(PXPalette_alloc());
	return self;
}

- (void)dealloc
{
	PXPalette_release(frequencyPalette);
	[super dealloc];
}

- view
{
	return view;
}

- (void)setDocument:(PXDocument *)doc
{
	[paletteView setDocument:doc];
  if(canvas)
  {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PXCanvasFrequencyPaletteRefresh" object:canvas];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PXCanvasPaletteUpdate" object:canvas];
  }
	canvas = [doc canvas];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPalette:) name:@"PXCanvasFrequencyPaletteRefresh" object:canvas];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePalette:) name:@"PXCanvasPaletteUpdate" object:canvas];
  [self refreshPalette:nil];
}

- (void)refreshPalette:(NSNotification *)note
{
  PXPalette *oldPal = frequencyPalette;
  frequencyPalette = [canvas createFrequencyPalette];
  PXPalette_release(oldPal);
  [paletteView setPalette:frequencyPalette];
}

- (void)updatePalette:(NSNotification *)note
{
  NSDictionary *changes = [note userInfo];
  NSColor *oldC = [changes objectForKey:@"PXCanvasPaletteUpdateRemoved"];
  NSColor *newC = [changes objectForKey:@"PXCanvasPaletteUpdateAdded"];
  PXPalette_decrementColorCount(frequencyPalette, oldC);
  PXPalette_incrementColorCount(frequencyPalette, newC);
  [paletteView retile];
}

- (void)useColorAtIndex:(unsigned)index event:(NSEvent *)e;
{
	PXToolSwitcher *switcher = [[PXToolPaletteController sharedToolPaletteController] leftSwitcher];
	if([e buttonNumber] == 1 || ([e modifierFlags] & NSControlKeyMask))
	{
		switcher = [[PXToolPaletteController sharedToolPaletteController] rightSwitcher];
	}
	[switcher setColor:PXPalette_colorAtIndex(frequencyPalette, index)];	
}

- (void)modifyColorAtIndex:(unsigned)index;
{
//FIXME: put palette adds here
}

- (void)paletteViewSizeChangedTo:(NSControlSize)size
{
	[[NSUserDefaults standardUserDefaults] setInteger:size forKey:PXColorPickerPaletteViewSizeKey];
}

- (BOOL)isPaletteIndexKey:(NSEvent *)event
{
	NSString *chars = [event characters];
    //not sure why numpad is unacceptable, but whatever
	BOOL numpad = [event modifierFlags] & NSNumericPadKeyMask;
	return (([chars intValue] != 0) || ([chars characterAtIndex:0] == '0')) && !numpad;
}

- (void)keyDown:(NSEvent *)event
{
	NSString *chars = [event characters];
  unsigned index = [chars intValue];
  [self useColorAtIndex:index event:event];
}

- (IBAction)useMostRecentColors:sender;
{
}

- (IBAction)useMostFrequentColors:sender;
{
}

- (IBAction)useColorListColors:sender;
{
}

@end

