//
//  ServerHelper.h
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncNetworkTvOS/AsyncServer.h>

@protocol ServerHelperDelegate

- (void)snapFromPlayer:(NSInteger)player;

@end

@interface ServerHelper : NSObject

+ (ServerHelper *)sharedHelper;

@property (nonatomic, readonly) NSMutableArray<AsyncConnection *> *connectedClients;
@property (nonatomic, weak) id<ServerHelperDelegate> delegate;

@end
