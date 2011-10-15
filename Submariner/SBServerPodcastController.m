//
//  SBServerPodcastController.m
//  Submariner
//
//  Created by Rafaël Warnault on 23/08/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBServerPodcastController.h"
#import "SBServer.h"
#import "SBTrack.h"
#import "SBPodcast.h"
#import "SBEpisode.h"
#import "SBPlayer.h"

#import "NSManagedObjectContext+Fetch.h"


#pragma mark -
#pragma mark Private Interface

@interface SBServerPodcastController (Private)

@end


@implementation SBServerPodcastController

+ (NSString *)nibName {
    return @"ServerPodcasts";
}



@synthesize podcastsSortDescriptors;
@synthesize episodesSortDescriptors;

#pragma mark -
#pragma mark NSView overwritten methods


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        NSSortDescriptor *descr1 = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        podcastsSortDescriptors = [[NSArray alloc] initWithObjects:descr1, nil];
        
        NSSortDescriptor *descr2 = [NSSortDescriptor sortDescriptorWithKey:@"publishDate" ascending:NO];
        episodesSortDescriptors = [[NSArray alloc] initWithObjects:descr2, nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // observe album covers
    [self addObserver:self 
           forKeyPath:@"server" 
              options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
              context:nil];
    
    // tracks double click
    [podcastsTableView setTarget:self];
    [podcastsTableView setDoubleAction:@selector(trackDoubleClick:)];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"server"];
    
    [podcastsSortDescriptors release];
    [episodesSortDescriptors release];
    [super dealloc];
}


#pragma mark -
#pragma mark Observers

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"server"]) {
        [podcastsController setContent:nil];
        [self.server getServerPodcasts];
    }
}



#pragma mark - 
#pragma mark IBActions

- (IBAction)trackDoubleClick:(id)sender {
    NSInteger selectedRow = [episodesTableView selectedRow];
    if(selectedRow != -1) {
        SBEpisode *clickedTrack = [[episodesController arrangedObjects] objectAtIndex:selectedRow];
        if(clickedTrack) {
            
            if([clickedTrack.episodeStatus isEqualToString:@"completed"]) {
                // add track to player
                if([[NSUserDefaults standardUserDefaults] integerForKey:@"playerBehavior"] == 1) {
                    [[SBPlayer sharedInstance] addTrackArray:[episodesController arrangedObjects] replace:YES];
                    // play track
                    [[SBPlayer sharedInstance] playTrack:clickedTrack];
                } else {
                    [[SBPlayer sharedInstance] addTrackArray:[episodesController arrangedObjects] replace:NO];
                    [[SBPlayer sharedInstance] playTrack:clickedTrack];
                }
            } else {
                NSAlert *alert = [NSAlert alertWithMessageText:@"Unavailable Podcast" 
                                                 defaultButton:@"OK" 
                                               alternateButton:nil 
                                                   otherButton:nil 
                                     informativeTextWithFormat:@"This podcast episode does not appear online. Please, check availability status."];
                
                [alert runModal];
            }
        }
    }
}



@end