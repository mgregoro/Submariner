//
//  NSOperationQueue+Shared.h
//  Submariner
//
//  Created by Rafaël Warnault on 09/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSOperationQueue (Shared)

+ (NSOperationQueue*) sharedServerQueue;
+ (NSOperationQueue*) sharedDownloadQueue;

@end