//
//  ServerHelper.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "ServerHelper.h"

@interface ServerHelper () <AsyncServerDelegate>
@end

@implementation ServerHelper

+ (ServerHelper *)sharedHelper {
  static ServerHelper *sharedHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedHelper = [[self alloc] init];
  });
  return sharedHelper;
}

- (id)init {
  if (self = [super init]) {
    AsyncServer *server = [AsyncServer new];
    server.serviceName = @"Snap";
    server.delegate = self;
    [server start];
  }
  return self;
}

#pragma mark - AsyncServerDelegate
- (void)server:(AsyncServer *)theServer didConnect:(AsyncConnection *)connection
{
  [self.connectedClients addObject:connection];
}

- (void)server:(AsyncServer *)theServer didDisconnect:(AsyncConnection *)connection
{
  [self.connectedClients removeObject:connection];
}

- (void)server:(AsyncServer *)theServer didReceiveCommand:(AsyncCommand)command object:(id)object connection:(AsyncConnection *)connection responseBlock:(AsyncNetworkResponseBlock)block
{
  if (command == 1) {
    block(@(self.connectedClients + 1));
  }
  block(nil);
}

@end
