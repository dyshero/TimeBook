//
//  NSObject+Initializtion.h
//
//  Created by 翊sky
//  Copyright © 翊sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Initializtion)

/**
 *  initialize a class file
 *
 *  @return a object from class
 */
+ (id)classInitializtion;
/**
 *  initializtion a nib file
 *
 *  @return a object from class
 */
+ (id)nibInitializtion;

+ (id)nibCtrInitialiation;

@end
