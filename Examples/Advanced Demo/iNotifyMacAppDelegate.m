//
//  iNotifyMacAppDelegate.m
//  iNotifyAdvanced
//
//  Created by Nick Lockwood on 06/02/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "iNotifyMacAppDelegate.h"


@implementation iNotifyMacAppDelegate

@synthesize window;
@synthesize progressIndicator;
@synthesize textView;

+ (void)initialize
{
	//configure iNotify
	[iNotify sharedInstance].notificationsPlistURL = @"http://charcoaldesign.co.uk/iNotify/notifications.plist";
	[iNotify sharedInstance].checkAtLaunch = NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	//set app delegate as iVersion delegate
    //this is technically no longer needed
    //as the iNotify delegate defaults to the
    //app delegate unless otherwise specified
	[iNotify sharedInstance].delegate = self;
}

- (IBAction)checkForNotifications:(id)sender;
{
	//perform manual check
	[[iNotify sharedInstance] checkForNotifications];
	[progressIndicator startAnimation:self];
}

#pragma mark -
#pragma mark iNotifyDelegate methods

- (void)iNotifyNotificationsCheckDidFailWithError:(NSError *)error
{
	[textView setString:[NSString stringWithFormat:@"Error: %@", error]];
	[progressIndicator stopAnimation:self];
}

- (void)iNotifyDidNotDetectNotifications
{
	[textView setString:@"No new version detected"];
	[progressIndicator stopAnimation:self];
}

- (void)iNotifyDidDetectNotifications:(NSDictionary *)notifications;
{
	NSMutableString *details = [NSMutableString string];
	for (NSString *key in [notifications allKeys])
	{
		NSDictionary *notification = [notifications objectForKey:key];
		
		[details appendString:key];
		[details appendString:@"\n\n"];	
		[details appendString:[notification objectForKey:iNotifyTitleKey]];
		[details appendString:@"\n\n"];		 
		[details appendString:[notification objectForKey:iNotifyMessageKey]];
		
		NSString *actionURL = [notification objectForKey:iNotifyActionURLKey];
		if (actionURL)
		{
			[details appendString:@"\n\n"];		 
			[details appendString:actionURL];
		}
		
		[details appendString:@"\n\n------------------------------------\n\n"];		 
	}
	[textView setString:details];
	[progressIndicator stopAnimation:self];
}

- (BOOL)iNotifyShouldDisplayNotificationWithKey:(NSString *)key details:(NSDictionary *)details
{
	//don't show alert
	return NO;
}

@end
