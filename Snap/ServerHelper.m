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

@implementation ServerHelper {
  AsyncServer *_server;
}

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
    _server = [AsyncServer new];
    _server.serviceName = @"Snap";
    _server.delegate = self;
    _server.serviceType = @"_ClientServer._tcp";
    [_server start];
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
    block(@(self.connectedClients.count + 1));
  } else if (command == 2) {
    NSInteger player = [self.connectedClients indexOfObject:connection] + 1;
    [self.delegate snapFromPlayer:player];
  }
  block(nil);
}

@end
