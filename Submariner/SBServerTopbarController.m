//
//  SBServerTopbarController.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBServerTopbarController.h"
#import "SBDatabaseController.h"
#import "SBServerLibraryController.h"
#import "SBServerHomeController.h"
#import "SBServerPodcastController.h"
#import "SBServerUserViewController.h"
#import "SBServerSearchController.h"
#import "SBClientController.h"
#import "SBAnimatedView.h"
#import "SBServer.h"



// private interface (Subsonic notifications)
@interface SBServerTopbarController (Subsonic)
- (void)subsonicConnectionFailed:(NSNotification *)notification;
- (void)subsonicConnectionSucceeded:(NSNotification *)notification;
- (void)subsonicIndexesUpdated:(NSNotification *)notification;
- (void)subsonicAlbumsUpdated:(NSNotification *)notification;
- (void)subsonicPlaylistsUpdated:(NSNotification *)notification;
- (void)subsonicPlaylistUpdated:(NSNotification *)notification;
- (void)subsonicChatMessageAdded:(NSNotification *)notification;
- (void)subsonicNowPlayingUpdated:(NSNotification *)notification;
- (void)subsonicUserInfoUpdated:(NSNotification *)notification;
@end






@implementation SBServerTopbarController



// class inherited method
+ (NSString *)nibName {
    return @"ServerTopbar";
}


// property accessors
@synthesize databaseController;



- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        serverLibraryController = [[SBServerLibraryController alloc] initWithManagedObjectContext:self.managedObjectContext];
        serverHomeController = [[SBServerHomeController alloc] initWithManagedObjectContext:self.managedObjectContext];
        serverPodcastController = [[SBServerPodcastController alloc] initWithManagedObjectContext:self.managedObjectContext];
        serverUserController = [[SBServerUserViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
        serverSearchController = [[SBServerSearchController alloc] initWithManagedObjectContext:self.managedObjectContext];
        
        [self.server setSelectedTabIndex:0];
    }
    return self;
}


- (void)dealloc
{
    // remove Subsonic observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SBSubsonicConnectionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SBSubsonicConnectionFailedNotification object:nil];
    
    [serverLibraryController release];
    [serverHomeController release];
    [serverPodcastController release];
    [serverUserController release];
    [serverSearchController release];
    [databaseController release];
    
    [super dealloc];
}


- (void)loadView {
    
    [super loadView];
    
    // observe Subsonic connection
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(subsonicConnectionSucceeded:) 
                                                 name:SBSubsonicConnectionSucceededNotification 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(subsonicConnectionFailed:) 
                                                 name:SBSubsonicConnectionFailedNotification
                                               object:nil];
    
    
    [viewSegmentedControl setTarget:self];
    [viewSegmentedControl setAction:@selector(viewControllerChange:)];
    
}


- (void)setViewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            // indexes
            [serverLibraryController setDatabaseController:databaseController];
            [serverLibraryController setServer:self.server];
            [databaseController setCurrentView:(SBAnimatedView *)[serverLibraryController view]];
        } break;
 
        case 1: {
            // home
            [serverHomeController setDatabaseController:databaseController];
            [serverHomeController setServer:self.server];
            [databaseController setCurrentView:(SBAnimatedView *)[serverHomeController view]];
        } break;
            
        case 2: {
            // podcasts
            [serverPodcastController setServer:self.server];
            [databaseController setCurrentView:(SBAnimatedView *)[serverPodcastController view]];
        } break;
            
        case 3: {
            // search
            [serverSearchController setServer:self.server];
            [databaseController setCurrentView:(SBAnimatedView *)[serverSearchController view]];
        } break;
            
        case 4: {
            // user view
            [serverUserController setServer:self.server];
            [serverUserController viewDidLoad];
            [databaseController setCurrentView:(SBAnimatedView *)[serverUserController view]];
        } break;
            
        default: {
            // default (0 : indexes)
            [databaseController setCurrentView:(SBAnimatedView *)[serverLibraryController view]];
        } break;
    }
    [viewSegmentedControl setSelectedSegment:index];
    [self.server setSelectedTabIndex:index];
}




#pragma mark -
#pragma mark IBAction

- (IBAction)viewControllerChange:(id)sender {
    [self setViewControllerAtIndex:[sender selectedSegment]];
}

- (IBAction)search:(id)sender {

    NSString *query = [sender stringValue];
    
    if(query && [query length] > 0) {
        NSLog(@"search:");
        [self setViewControllerAtIndex:3];
        [server searchWithQuery:query];
    }
}



#pragma mark -
#pragma mark Subsonic Notification

- (void)subsonicConnectionFailed:(NSNotification *)notification {
    if([[notification object] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *attr = [notification object];
        NSInteger code = [[attr valueForKey:@"code"] intValue];
        
        NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Subsonic Error (code %ld)", code]
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:[attr valueForKey:@"message"]];
        
        [alert runModal];
    }
}

- (void)subsonicConnectionSucceeded:(NSNotification *)notification {
    // loading of server content, major !!!
    [server getServerLicense];
    [server getServerIndexes]; 
    [server getServerPlaylists];
}


@end