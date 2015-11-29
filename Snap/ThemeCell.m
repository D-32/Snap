//
//  ThemeCell.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell {
  UIView *_topBg;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor purpleColor];

    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];

    self.tickView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [self addSubview:self.tickView];

    _topBg = [[UIView alloc] init];
    _topBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self addSubview:_topBg];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:24];
    [_topBg addSubview:self.nameLabel];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.imageView.frame = self.bounds;
  self.tickView.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 60, 60, 60);
  _topBg.frame = CGRectMake(0, 0, self.frame.size.width, 60);
  self.nameLabel.frame = CGRectMake(0, 0, _topBg.frame.size.width, _topBg.frame.size.height);
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
  [coordinator addCoordinatedAnimations:^{
    if (self.focused) {
      self.layer.shadowOffset = CGSizeMake(0, 28);
      self.layer.shadowColor = [UIColor blackColor].CGColor;
      self.layer.shadowRadius = 20.0;
      self.layer.shadowOpacity = 0.30;
      self.layer.shadowPath = CGPathCreateWithRect(self.layer.bounds, nil);
      self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
      self.layer.shadowOpacity = 0.0;
    }
  } completion:nil];
}

@end
