//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



#import "SBServer.h"
#import "SBHome.h"
#import "SBClientController.h"
#import "SBArtist.h"
#import "SBAlbum.h"
#import "SBPlaylist.h"
#import "SBChatMessage.h"

#import "EMKeychainItem.h"


@implementation SBServer

@dynamic resources;
@synthesize clientController;
@synthesize selectedTabIndex;


+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *result = nil;
    
    if([key isEqualToString:@"playlists"]) {
        result = [NSSet setWithObjects:@"resources", nil];
    }
    
    if([key isEqualToString:@"resources"]) {
        result = [NSSet setWithObjects:@"playlists", nil];
    }
    
    if([key isEqualToString:@"hasUnread"]) {
        result = [NSSet setWithObjects:@"messages.unread", nil];
    }
    
    if([key isEqualToString:@"numberOfUnread"]) {
        result = [NSSet setWithObjects:@"messages.unread", nil];
    }
    
    if([key isEqualToString:@"licenseImage"]) {
        result = [NSSet setWithObjects:@"isValidLicense", nil];
    }
    
    return result;
}



#pragma mark -
#pragma mark LifeCycle

- (void)dealloc {
    [clientController release];
    [super dealloc];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    if(self.home == nil) {
        self.home = [SBHome insertInManagedObjectContext:self.managedObjectContext];
    }

}




#pragma mark -
#pragma mark Custom Accessors (Source List Tree Support)

- (NSSet *)resources {
    NSSet *result = nil;
    
    [self willAccessValueForKey:@"resources"];
    [self willAccessValueForKey:@"playlists"];
    
    result = [self primitiveValueForKey:@"playlists"];
    
    [self didAccessValueForKey:@"playlists"];
    [self didAccessValueForKey:@"resources"];
    
    return result;
}

- (void)setResources:(NSSet *)_resources {
    
    [self willChangeValueForKey:@"resources"];
    [self willChangeValueForKey:@"playlists"];
    
    [self setPrimitiveValue:_resources forKey:@"playlists"];
    
    [self didChangeValueForKey:@"playlists"];
    [self didChangeValueForKey:@"resources"];
}

- (NSSet *)playlists {
    NSSet *result = nil;
    
    [self willAccessValueForKey:@"resources"];
    [self willAccessValueForKey:@"playlists"];
    
    result = [self primitiveValueForKey:@"playlists"];
    
    [self didAccessValueForKey:@"playlists"];
    [self didAccessValueForKey:@"resources"];
    
    return result;
}

- (void)setPlaylists:(NSSet *)playlistsSet {
    
    [self willChangeValueForKey:@"resources"];
    [self willChangeValueForKey:@"playlists"];
    
    [self setPrimitiveValue:playlistsSet forKey:@"playlists"];
    
    [self didChangeValueForKey:@"playlists"];
    [self didChangeValueForKey:@"resources"];
}



- (BOOL)hasUnread {
    return ([self numberOfUnread] > 0 ? YES : NO);
}


- (NSInteger)numberOfUnread {
    NSInteger ret = 0;
    
    for(SBChatMessage *message in self.messages) {
        if([message.unread  boolValue])
            ret++;
    }
    return ret;
}


- (NSImage *)licenseImage {
    NSImage *result = [NSImage imageNamed:@"off"];
    
    if([self.isValidLicense boolValue])
        result = [NSImage imageNamed:@"on"];
    
    return result;
}


#pragma mark -
#pragma mark Custom Accessors (Subsonic Client)

- (SBClientController *)clientController {
    if(!clientController) {
        clientController = [[SBClientController alloc] initWithManagedObjectContext:self.managedObjectContext];
        [clientController setServer:self];
    }
    
    return clientController;
}




#pragma mark -
#pragma mark Custom Accessors (Keychain Support)

//- (NSString *)password {
//    
//    NSString *string = nil;
//    [self willAccessValueForKey: @"password"];
//    
//    // decompose URL
//    if(self.url && self.username) {
//
//        NSURL *anUrl = [NSURL URLWithString:self.url];
//        // protocol scheme
//        uint protocol = kSecProtocolTypeHTTP;
//        if([[anUrl scheme] rangeOfString:@"s"].location != NSNotFound) {
//            protocol = kSecProtocolTypeHTTPS;
//        }
//        // url port
//        NSNumber *port = [NSNumber numberWithInteger:80];
//        if([anUrl port] != nil) {
//            port = [anUrl port];
//        }
//        
//        // get internet keycahin
//        EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:[anUrl host] 
//                                                                                        withUsername:self.username 
//                                                                                                path:@"/"
//                                                                                                port:[port integerValue] 
//                                                                                            protocol:protocol];
//        string = keychainItem.password;
//    }
//    [self didAccessValueForKey: @"password"];
//    return string;
//}

//- (void)setPassword:(NSString *) x {
//    [self willChangeValueForKey: @"password"];
//    
//    // decompose URL
//    if(self.url && self.username) {
//        NSURL *anUrl = [NSURL URLWithString:self.url];
//        // protocol scheme
//        uint protocol = kSecProtocolTypeHTTP;
//        if([[anUrl scheme] rangeOfString:@"s"].location != NSNotFound) {
//            protocol = kSecProtocolTypeHTTPS;
//        }
//        // url port
//        NSNumber *port = [NSNumber numberWithInteger:80];
//        if([anUrl port] != nil) {
//            port = [anUrl port];
//        }
//        
//        // add internet keychain
//        NSLog(@"add internet keychain");
//        [EMInternetKeychainItem addInternetKeychainItemForServer:[anUrl host] 
//                                                    withUsername:self.username
//                                                        password:x
//                                                            path:@"/"
//                                                            port:[port integerValue] 
//                                                        protocol:protocol];
//    }
//    [self didChangeValueForKey: @"password"];
//}





#pragma mark -
#pragma mark Subsonic Client (Login)

- (void)connect {
    [[self clientController] connectToServer:self];
}

- (void)getServerLicense {
    [[self clientController] getLicense];
}




#pragma mark -
#pragma mark Subsonic Client (Server Data)

- (void)getServerIndexes {
    if(self.lastIndexesDate != nil) {
        [[self clientController] getIndexesSince:self.lastIndexesDate];
    } else {
        [[self clientController] getIndexes];
    }
}

- (void)getAlbumsForArtist:(SBArtist *)artist {
    [[self clientController] getAlbumsForArtist:artist];
}

- (void)getTracksForAlbumID:(NSString *)albumID {
    [[self clientController] getTracksForAlbumID:albumID];
}

- (void)getAlbumListForType:(SBSubsonicRequestType)type {
    [[self clientController] getAlbumListForType:type];
}




#pragma mark -
#pragma mark Subsonic Client (Playlists)

- (void)getServerPlaylists {
    [[self clientController] getPlaylists];
}

- (void)createPlaylistWithName:(NSString *)playlistName tracks:(NSArray *)tracks {
    [[self clientController] createPlaylistWithName:playlistName tracks:tracks];
}

- (void)updatePlaylistWithID:(NSString *)playlistID tracks:(NSArray *)tracks {
    [[self clientController] updatePlaylistWithID:playlistID tracks:tracks];
}

- (void)deletePlaylistWithID:(NSString *)playlistID {
    [[self clientController] deletePlaylistWithID:playlistID];
}

- (void)getPlaylistTracks:(SBPlaylist *)playlist {
    [[self clientController] getPlaylist:playlist];
}




#pragma mark -
#pragma mark Subsonic Client (Podcasts)

- (void)getServerPodcasts {
   [[self clientController] getPodcasts]; 
}



#pragma mark -
#pragma mark Subsonic Client (Chat)

- (void)addChatMessage:(NSString *)message {
    [[self clientController] addChatMessage:message]; 
}

- (void)getChatMessagesSince:(NSDate *)date {
    [[self clientController] getChatMessagesSince:date];
}




#pragma mark -
#pragma mark Subsonic Client (Now Playing)

- (void)getNowPlaying {
    [[self clientController] getNowPlaying];
}




#pragma mark -
#pragma mark Subsonic Client (Search)

- (void)searchWithQuery:(NSString *)query {
    [[self clientController] search:query];
}




#pragma mark -
#pragma mark Subsonic Client (Rating)

- (void)setRating:(NSInteger)rating forID:(NSString *)anID {
    [[self clientController] setRating:rating forID:anID];
}



@end
