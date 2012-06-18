//
//  QuickTextMain.m
//  QuickText
//
//  Created by Spencer Alves on 8/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "QuickTextMain.h"

@implementation QuickTextMain

- (void)installPlugin {
    [[adium contentController] registerContentFilter:self
											  ofType:AIFilterContent
										   direction:AIFilterOutgoing];
}

- init {
	if ((self = [super init])) {
		prefsController = [[QuickTextPrefsController alloc] initForPlugin:self];
		prefsController.mainController = self;
		[self installPlugin];
	}
	return self;
}

- (void)uninstallPlugin {
    [[adium contentController] unregisterContentFilter:self];
	[prefsController release];
}

BOOL isPunctuation(unichar c) {
	// I wish there was a better way to do this.
	return (c == '\t' ||
			c == '\n' ||
			c == 0x0B ||
			c == 0x0C ||
			c == '\r' ||
			c == ' ' ||
			c == '!' ||
			c == '"' ||
			c == '#' ||
			c == '$' ||
			c == '%' ||
			c == '&' ||
			c == '\'' ||
			c == '(' ||
			c == ')' ||
			c == '*' ||
			c == '+' ||
			c == ',' ||
			c == '-' ||
			c == '.' ||
			c == '/' ||
			c == ':' ||
			c == ';' ||
			c == '<' ||
			c == '=' ||
			c == '>' ||
			c == '?' ||
			c == '@' ||
			c == '[' ||
			c == '\\' ||
			c == ']' ||
			c == '^' ||
			c == '_' ||
			c == '`' ||
			c == '{' ||
			c == '|' ||
			c == '}' ||
			c == '~');
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)attributedString
									   context:(id)context {
	if (![context isKindOfClass:[AIContentMessage class]]) {
		return attributedString;
	}
	NSMutableString *string = [[NSMutableString alloc] initWithString:[attributedString string]];
	NSRange range;
	for (NSDictionary *entry in prefsController.entries) {
		// LiteralSearch if the user wants case-sensitivity, CaseInsensitive otherwise
		// Do I have to use LiteralSearch? What if I used 0?
		NSStringCompareOptions opts = [[entry valueForKey:CASE_SENSITIVE_KEY] boolValue] ? NSLiteralSearch : NSCaseInsensitiveSearch;
		NSString *find = [entry valueForKey:FIND_KEY];
		NSString *replace = [entry valueForKey:REPLACE_KEY];
		NSUInteger findLength = [find length];
		if ([[entry valueForKey:ENTIRE_MATCH_KEY] boolValue]) {
			if ([string compare:find options:opts] == NSOrderedSame) {
				[string setString:replace];
			}
		}
		else if (findLength <= [string length]) {
			NSUInteger i = 0;
			// We need to keep calculating the length of the mutable string, as it's length could change
			while (i <= [string length]-findLength) {
				// If the previous character is whitespace or the beginning
				// and the character at the end of the search range is whitespace or the end of the string
				if ((i == 0 || isPunctuation([string characterAtIndex:i-1])) &&
					(i == ([string length]-findLength) || isPunctuation([string characterAtIndex:i+findLength]))) {
					range = NSMakeRange(i, findLength);
					if ([string compare:find options:opts range:range] == NSOrderedSame) {
						[string replaceCharactersInRange:range withString:replace];
					}
				}
				i++;
			}
		}
	}
	range = NSMakeRange(0, [attributedString length]);
	return [[NSAttributedString alloc] initWithString:string
										   attributes:[attributedString attributesAtIndex:0
																		   effectiveRange:(NSRangePointer)&range]];
}

- (CGFloat)filterPriority {
	return DEFAULT_FILTER_PRIORITY;
}

- (NSString *)pluginAuthor {
	return @"Spencer Alves";
}

- (NSString *)pluginVersion {
	return @"1.0";
}

- (NSString *)pluginDescription {
	return @"Quick and easy text replacements.";
}

- (NSString *)pluginURL {
	return @"http://www.adiumxtras.com/index.php?a=xtras&xtra_id=6978";
}

@end
