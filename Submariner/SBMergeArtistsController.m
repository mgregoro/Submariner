//
//  SBMergeArtistController.m
//  Submariner
//
//  Created by Rafaël Warnault on 24/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
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

#import "SBMergeArtistsController.h"
#import "SBArtist.h"
#import "SBAlbum.h"


@implementation SBMergeArtistsController

@synthesize artists;


- (void)openSheet:(id)sender {
    
    if(artists != nil && [artists  count] > 0) {
        for (SBArtist *artist in artists) {
            NSMenuItem *newItem = [[[NSMenuItem alloc] init] autorelease];
            [newItem setTitle:artist.itemName];
            [newItem setRepresentedObject:artist];
            
            [[artistPopUpButton menu] addItem:newItem];
        }
    }
    [super openSheet:sender];
}

- (void)closeSheet:(id)sender {
    
    if(artists != nil && [artists  count] > 0) {
        NSMenuItem *selectedIem = [artistPopUpButton selectedItem];
        if(selectedIem != nil) {
            SBArtist *targetArtist = [selectedIem representedObject];
            NSMutableArray *albums = [NSMutableArray array];
            
            for(SBArtist *otherArtist in artists) {
                if(![otherArtist isEqualTo:targetArtist]) {
                    [albums addObjectsFromArray:[otherArtist.albums allObjects]];
                }
            }
            
            for(SBAlbum *album in albums) {
                [targetArtist addAlbumsObject:album];
            }
            
            for(SBArtist *otherArtist in artists) {
                if(![otherArtist isEqualTo:targetArtist]) {
                    [targetArtist.managedObjectContext deleteObject:otherArtist];
                }
            }
            
            [targetArtist.managedObjectContext save:nil];
        }
    }
    
    [super closeSheet:sender];
}

@end
