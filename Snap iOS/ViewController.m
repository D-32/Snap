//
//  ViewController.m
//  Snap iOS
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "ViewController.h"
#import <AsyncNetworkIOS/AsyncClient.h>

@interface ViewController () <AsyncClientDelegate>

@end

@implementation ViewController {
  NSInteger _player;
  AsyncClient *_client;

  UILabel *_connectionLabel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  _connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
  _connectionLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
  _connectionLabel.font = [UIFont systemFontOfSize:16];
  _connectionLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_connectionLabel];

  [self connect];
}

- (void)connect
{
  AsyncClient *client = [AsyncClient new];
  [client start];
}

#pragma mark - AsyncClientDelegate
- (void)client:(AsyncClient *)theClient didConnect:(AsyncConnection *)connection
{
  NSLog(@"client connected");
  _connectionLabel.text = @"Connection established, registering...";
  [theClient sendCommand:1 object:nil responseBlock:^(id<NSCoding> response) {
    NSNumber *p = (id)response;
    _player = p.integerValue;
    _connectionLabel.text = [NSString stringWithFormat:@"You are Player %li", _player];

  }];
}

- (void)client:(AsyncClient *)theClient didDisconnect:(AsyncConnection *)connection
{
  NSLog(@"client disconnected");
  _connectionLabel.text = @"You're disconnected";
}

@end
