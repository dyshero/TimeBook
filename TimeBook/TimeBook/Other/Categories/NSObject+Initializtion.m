//
//  NSObject+Initializtion.m
//
//  Created by qianfeng
//  Copyright © 翊sky. All rights reserved.
//

#import "NSObject+Initializtion.h"

@implementation NSObject (Initializtion)

+ (id)classInitializtion{
    return [[self alloc] init];
}

+ (id)nibInitializtion{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class])
                                         owner:nil
                                       options:nil]
            firstObject];
}

+ (id)nibCtrInitialiation {
    
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
}

@end
