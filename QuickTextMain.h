//
//  QuickTextMain.h
//  QuickText
//
//  Created by Spencer Alves on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Adium/AIPlugin.h>
#import <Adium/AISharedAdium.h>
#import <Adium/AIContentControllerProtocol.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIContentContext.h>
#import <Adium/AIPreferenceControllerProtocol.h>
#import <Adium/AIAdvancedPreferencePane.h>
#import "QuickTextPrefsController.h"

#define FIND_KEY @"find"
#define REPLACE_KEY @"replace"
#define CASE_SENSITIVE_KEY @"case"
#define ENTIRE_MATCH_KEY @"exact"
#define ENTRIES_PREFS_KEY @"entries"
#define ENABLED_PREFS_KEY @"enabled"
#define PREFS_GROUP @"DeAbbrevIfier"

@interface QuickTextMain : AIPlugin<AIContentFilter, AIPluginInfo> {
	QuickTextPrefsController *prefsController;
}

@end
