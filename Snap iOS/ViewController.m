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
  UIButton *_reloadButton;

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
  _connectionLabel.text = @"Connecting...";
  [self.view addSubview:_connectionLabel];

  _reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [_reloadButton setTitle:@"Connect" forState:UIControlStateNormal];
  _reloadButton.frame = CGRectMake(self.view.frame.size.width / 2 - 80, 40, 160, 40);
  [_reloadButton addTarget:self action:@selector(actionConnect:) forControlEvents:UIControlEventTouchUpInside];
  _reloadButton.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
  _reloadButton.layer.borderWidth = 1;
  _reloadButton.layer.cornerRadius = 4;
  _reloadButton.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
  [self.view addSubview:_reloadButton];

  UIButton *snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  snapButton.frame = CGRectMake(24, self.view.frame.size.height - 160 - 24, self.view.frame.size.width - 48, 160);
  snapButton.layer.cornerRadius = 6;
  [snapButton addTarget:self action:@selector(actionSnap:) forControlEvents:UIControlEventTouchUpInside];
  [snapButton setBackgroundImage:[ViewController imageFromColor:[UIColor colorWithRed:0.04 green:0.52 blue:0.89 alpha:1.00]] forState:UIControlStateNormal];
  [snapButton setBackgroundImage:[ViewController imageFromColor:[UIColor colorWithRed:0.02 green:0.38 blue:0.65 alpha:1.00]] forState:UIControlStateHighlighted];
  snapButton.clipsToBounds = YES;
  [self.view addSubview:snapButton];
  UILabel *snapLabel = [[UILabel alloc] initWithFrame:snapButton.bounds];
  snapLabel.text = @"Snap";
  snapLabel.textColor = [UIColor whiteColor];
  snapLabel.font = [UIFont systemFontOfSize:18];
  snapLabel.textAlignment = NSTextAlignmentCenter;
  [snapButton addSubview:snapLabel];

  [self connect];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
  CGRect rect = CGRectMake(0, 0, 1, 1);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

- (void)actionConnect:(id)sender
{
  [_client stop];
  _client = nil;
  [self connect];
}

- (void)actionSnap:(id)sender
{
  [_client sendCommand:2 object:nil responseBlock:nil];
}

- (void)connect
{
  _client = [[AsyncClient alloc] init];
  _client.delegate = self;
  _client.serviceType = @"_ClientServer._tcp";
  _client.autoConnect = YES;
  [_client start];
}

#pragma mark - AsyncClientDelegate
- (void)client:(AsyncClient *)theClient didConnect:(AsyncConnection *)connection
{
  _reloadButton.enabled = NO;
  _connectionLabel.text = @"Connection established, registering...";
  [theClient sendCommand:1 object:nil responseBlock:^(id<NSCoding> response) {
    NSNumber *p = (id)response;
    _player = p.integerValue;
    _connectionLabel.text = [NSString stringWithFormat:@"You are Player %li", _player];
  }];
}

- (void)client:(AsyncClient *)theClient didDisconnect:(AsyncConnection *)connection
{
  _reloadButton.enabled = YES;
  NSLog(@"client disconnected");
  _connectionLabel.text = @"You're disconnected";
}

- (void)client:(AsyncClient *)theClient didFailWithError:(NSError *)error
{

}

- (BOOL)client:(AsyncClient *)theClient didFindService:(NSNetService *)service moreComing:(BOOL)moreComing
{
  return YES;
}

@end
