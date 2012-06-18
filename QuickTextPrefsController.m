//
//  QuickTextPrefsController.m
//  QuickText
//
//  Created by Spencer Alves on 8/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuickTextPrefsController.h"
#import "QuickTextMain.h"

@implementation QuickTextPrefsController

@synthesize mainController, entries;

- (IBAction)addEntry:(NSButton *)sender {
	id keys[] = {FIND_KEY, REPLACE_KEY, CASE_SENSITIVE_KEY,			   ENTIRE_MATCH_KEY};
	id vals[] = {@"",	   @"",		    [NSNumber numberWithBool:NO],  [NSNumber numberWithBool:YES]};
	[entries addObject:[NSMutableDictionary dictionaryWithObjects:vals forKeys:keys count:4]];
	[prefs setPreference:entries forKey:ENTRIES_PREFS_KEY group:PREFS_GROUP];
	[tableView reloadData];
	[removeButton setEnabled:TRUE];
}

- (IBAction)removeEntry:(NSButton *)sender {
	NSInteger idx = [tableView selectedRow];
	if (idx == -1)
		return;
    [entries removeObjectAtIndex:idx];
	[prefs setPreference:entries forKey:ENTRIES_PREFS_KEY group:PREFS_GROUP];
	[tableView reloadData];
	if ([entries count] == 0)
		[removeButton setEnabled:FALSE];
}

- (IBAction)setEnabled:(NSButton *)sender {
	if ([sender state] == NSOffState) {
		[[adium contentController] unregisterContentFilter:mainController];
		[prefs setPreference:[NSNumber numberWithBool:FALSE] forKey:ENABLED_PREFS_KEY group:PREFS_GROUP];
	}
	else {
		[[adium contentController] registerContentFilter:mainController
												  ofType:AIFilterContent
											   direction:AIFilterOutgoing];
		[prefs setPreference:[NSNumber numberWithBool:TRUE] forKey:ENABLED_PREFS_KEY group:PREFS_GROUP];
	}
}

- (void)viewDidLoad {
	prefs = [adium preferenceController];
	entries = [prefs preferenceForKey:ENTRIES_PREFS_KEY group:PREFS_GROUP];
	if (entries == nil) {
		entries = [[NSMutableArray alloc] init];
		// The checkbox and filter are on by default, so we don't need to make it so.
		// (but, if I add anything else, the defaults should go here)
	}
	else {
		[tableView reloadData];
		if (![[prefs preferenceForKey:ENABLED_PREFS_KEY group:PREFS_GROUP] boolValue]) {
			[[adium contentController] unregisterContentFilter:mainController];
			[enableBox setState:NSOffState];
		}
	}
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [entries count];
}

- (id)			tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
					  row:(NSInteger)rowIndex {
	return [[entries objectAtIndex:rowIndex] valueForKey:[aTableColumn identifier]];
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(NSInteger)rowIndex {
	[[entries objectAtIndex:rowIndex] setObject:anObject forKey:[aTableColumn identifier]];
}

-		 (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSArray *)oldDescriptors {
	NSInteger selectedRow = [aTableView selectedRow];
	id selection;
	if (selectedRow != -1)
		selection = [entries objectAtIndex:selectedRow];
	[entries sortUsingDescriptors:[aTableView sortDescriptors]];
	[tableView reloadData];
	if (selectedRow != -1)
		[tableView selectRow:[entries indexOfObject:selection] byExtendingSelection:NO];
}

- (NSString *)label {
	return PREFS_GROUP;
}

- (NSString *)nibName {
	return @"QuickTextPrefs";
}

- (NSImage *)image {
	return [[[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"Icon" ofType:@"icns"]] autorelease];
}

- (BOOL)resizable {
	return YES;
}

- (BOOL)resizableHorizontally {
	return YES;
}

@end
