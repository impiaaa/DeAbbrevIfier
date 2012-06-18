//
//  QuickTextPrefsController.h
//  QuickText
//
//  Created by Spencer Alves on 8/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Adium/AIAdvancedPreferencePane.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIPreferenceControllerProtocol.h>

@class QuickTextMain;

@interface QuickTextPrefsController : AIAdvancedPreferencePane {
    IBOutlet NSTableView *tableView;
    IBOutlet NSButton *enableBox;
	IBOutlet NSButton *removeButton;
	NSMutableArray *entries;
	QuickTextMain *mainController;
	NSObject<AIPreferenceController> *prefs;
}

@property (nonatomic, readonly) NSMutableArray *entries;
@property (nonatomic, retain) QuickTextMain *mainController;

- (IBAction)addEntry:(NSButton *)sender;
- (IBAction)removeEntry:(NSButton *)sender;
- (IBAction)setEnabled:(NSButton *)sender;

@end
