//
//  ServerHelper.h
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerHelper : NSObject

+ (ServerHelper *)sharedHelper;

@property (nonatomic) NSInteger connectedClients;

@end
