//
//  UPreferences.h
//  Submariner
//
//  Created by Rafaël Warnault on 20/03/11.
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

#import <Foundation/Foundation.h>
#import "SBWindowController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface SBPreferencesController : SBWindowController <NSToolbarDelegate> {

	IBOutlet NSToolbar  *bar;
	IBOutlet NSView *generalPreferenceView;
	IBOutlet NSView *serversPreferenceView;
    IBOutlet NSView *playerPreferenceView;
    IBOutlet NSView *appearancePreferenceView;
	IBOutlet NSView *updatesPreferenceView;
	IBOutlet NSView *subsonicPreferenceView;
    IBOutlet NSMatrix *playerBehaviorMatrix;
    IBOutlet NSPopUpButton *downloadLocationPopUp;
    IBOutlet SRRecorderControl *hotKeyControl;
    
	NSInteger currentViewTag;
}

- (IBAction)switchView:(id)sender;
- (IBAction)chooseDownloadLocation:(id)sender;
- (IBAction)setPlayerBehavior:(id)sender;
- (NSView *)viewForTag:(NSInteger)tag;
- (NSRect)newFrameForNewContentView:(NSView *)view;

@end
