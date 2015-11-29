//
//  GameViewController.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "GameViewController.h"
#import "ServerHelper.h"
#import "FancyButton.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameViewController
{
  NSString *_theme;

  NSInteger _timeLeft;
  UILabel *_timeLeftLabel;
  UILabel *_scoresLabel;
  NSMutableArray<NSNumber *> *_scores;

  NSMutableArray<UIImageView *> *_frontViews;
  NSMutableArray<UIImageView *> *_backViews;
  NSArray<UIView *> *_cardsViews;
  NSMutableArray<NSNumber *> *_states;
  NSMutableArray<UIImage *> *_images;

  BOOL _snapped;

  AVAudioPlayer *_cardSound;
  AVAudioPlayer *_failSound;
  AVAudioPlayer *_winSound;
}

- (instancetype)initWithTheme:(NSString *)theme
{
  if (self = [super init]) {
    _theme = theme;

    _images = [[NSMutableArray<UIImage *> alloc] init];
    if ([_theme isEqualToString:@"emoji"]) {
      [_images addObject:[UIImage imageNamed:@"emoji_1"]];
      [_images addObject:[UIImage imageNamed:@"emoji_2"]];
      [_images addObject:[UIImage imageNamed:@"emoji_3"]];
      [_images addObject:[UIImage imageNamed:@"emoji_4"]];
      [_images addObject:[UIImage imageNamed:@"emoji_5"]];
      [_images addObject:[UIImage imageNamed:@"emoji_6"]];
      [_images addObject:[UIImage imageNamed:@"emoji_7"]];
      [_images addObject:[UIImage imageNamed:@"emoji_8"]];
    } else if ([_theme isEqualToString:@"numbers"]) {
      [_images addObject:[UIImage imageNamed:@"numbers_1"]];
      [_images addObject:[UIImage imageNamed:@"numbers_2"]];
      [_images addObject:[UIImage imageNamed:@"numbers_3"]];
      [_images addObject:[UIImage imageNamed:@"numbers_4"]];
      [_images addObject:[UIImage imageNamed:@"numbers_5"]];
      [_images addObject:[UIImage imageNamed:@"numbers_6"]];
      [_images addObject:[UIImage imageNamed:@"numbers_7"]];
    } else if ([_theme isEqualToString:@"people"]) {
    }

    while (_images.count != 3) {
      [_images removeObjectAtIndex:[self randomNumberBetween:0 to:_images.count - 1]];
    }

    _cardSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"card" ofType:@"wav"]] error:nil];
    _winSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"win" ofType:@"mp3"]] error:nil];
    _failSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fail" ofType:@"mp3"]] error:nil];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  _timeLeft = 60;

  _scores = [NSMutableArray<NSNumber *> arrayWithObject:@(0)];
  for (int i = 0; i < [ServerHelper sharedHelper].connectedClients.count; i++) {
    [_scores addObject:@(0)];
  }

  _timeLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height - 100, 400, 40)];
  _timeLeftLabel.font = [UIFont monospacedDigitSystemFontOfSize:36 weight:UIFontWeightMedium];
  _timeLeftLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  [self.view addSubview:_timeLeftLabel];

  _scoresLabel = [[UILabel alloc] initWithFrame:CGRectMake(500, self.view.frame.size.height - 100, self.view.frame.size.width - 560, 40)];
  _scoresLabel.font = [UIFont monospacedDigitSystemFontOfSize:36 weight:UIFontWeightMedium];
  _scoresLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
  _scoresLabel.textAlignment = NSTextAlignmentRight;
  [self.view addSubview:_scoresLabel];


  UIButton *snapButton = [FancyButton buttonWithType:UIButtonTypeSystem];
  snapButton.frame = CGRectMake(self.view.frame.size.width / 2 - 160, self.view.frame.size.height - 240, 320, 120);
  snapButton.backgroundColor = [UIColor colorWithRed:0.04 green:0.52 blue:0.89 alpha:1.00];
  [snapButton addTarget:self action:@selector(snap:) forControlEvents:UIControlEventPrimaryActionTriggered];
  [self.view addSubview:snapButton];

  UILabel *snapLabel = [[UILabel alloc] initWithFrame:snapButton.bounds];
  snapLabel.text = @"Snap";
  snapLabel.textColor = [UIColor whiteColor];
  snapLabel.font = [UIFont boldSystemFontOfSize:36];
  snapLabel.textAlignment = NSTextAlignmentCenter;
  [snapButton addSubview:snapLabel];


  CGFloat center = self.view.frame.size.width / 2;

  UIView *card1 = [[UIView alloc] initWithFrame:CGRectMake(center - 200 - 460, 110, 400, 400*1.4)];
  card1.layer.cornerRadius = 16;
  card1.clipsToBounds = YES;
  UIImageView *c1 = [[UIImageView alloc] initWithFrame:card1.bounds];
  c1.backgroundColor = [UIColor whiteColor];
  c1.image = [self randomImage];
  UIImageView *b1 = [[UIImageView alloc] initWithFrame:card1.bounds];
  b1.backgroundColor = [UIColor darkGrayColor];
  b1.hidden = YES;
  [card1 addSubview:b1];
  [card1 addSubview:c1];
  [self.view addSubview:card1];

  UIView *card2 = [[UIView alloc] initWithFrame:CGRectMake(center - 200, 110, 400, 400*1.4)];
  card2.layer.cornerRadius = 16;
  card2.clipsToBounds = YES;
  UIImageView *c2 = [[UIImageView alloc] initWithFrame:card2.bounds];
  c2.backgroundColor = [UIColor whiteColor];
  c2.image = [self randomImage];
  UIImageView *b2 = [[UIImageView alloc] initWithFrame:card2.bounds];
  b2.backgroundColor = [UIColor darkGrayColor];
  [card2 addSubview:b2];
  [card2 addSubview:c2];
  [self.view addSubview:card2];

  UIView *card3 = [[UIView alloc] initWithFrame:CGRectMake(center + 260, 110, 400, 400*1.4)];
  card3.layer.cornerRadius = 16;
  card3.clipsToBounds = YES;
  UIImageView *c3 = [[UIImageView alloc] initWithFrame:card3.bounds];
  c3.backgroundColor = [UIColor whiteColor];
  c3.image = [self randomImage];
  UIImageView *b3 = [[UIImageView alloc] initWithFrame:card3.bounds];
  b3.backgroundColor = [UIColor darkGrayColor];
  [card3 addSubview:b3];
  [card3 addSubview:c3];
  [self.view addSubview:card3];

  _frontViews = [NSMutableArray<UIImageView *> arrayWithObjects:c1, c2, c3, nil];
  _backViews = [NSMutableArray<UIImageView *> arrayWithObjects:b1, b2, b3, nil];
  _cardsViews = @[card1, card2, card3];
  _states = [NSMutableArray arrayWithArray:@[@(NO), @(NO), @(NO)]];

  [self updateScores];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self countDown];
}

- (void)flipCard:(NSInteger)card
{
  [UIView transitionWithView:_cardsViews[card] duration:1.0
                     options:UIViewAnimationOptionTransitionFlipFromRight
                  animations:^{
                    _frontViews[card].hidden = !_states[card].boolValue;
                    _backViews[card].hidden = _states[card].boolValue;
                    UIImage *randomImage = [self randomImage];
                    if (_states[card].boolValue) {
                      _frontViews[card].image = randomImage;
                    } else {
                      _backViews[card].image = randomImage;
                    }
                  } completion:^(BOOL finished) {
                  }];
  [self performSelector:@selector(reset:) withObject:@(card) afterDelay:0.5];
  [_cardSound play];
}

- (void)reset:(NSNumber *)c
{
  NSInteger card = c.integerValue;
  _snapped = NO;
  _states[card] = @(!(_states[card].boolValue));
}

- (void)countDown
{
  _timeLeft--;
  _timeLeftLabel.text = [NSString stringWithFormat:@"%li seconds left", _timeLeft];

  if (_timeLeft % 2 == 0) {
    [self flipCard:[self randomNumberBetween:0 to:2]];
  }

  if (_timeLeft > 0) {
    [self performSelector:@selector(countDown) withObject:nil afterDelay:1.0];
  }
}

- (void)updateScores
{
  NSMutableString *string = [NSMutableString string];
  NSInteger i = 0;
  for (NSNumber *count in _scores) {
    if (i != 0) {
      [string appendString:@", "];
    }
    [string appendString:[NSString stringWithFormat:@"Player %li: %li", i+1, count.integerValue]];
    i++;
  }
  _scoresLabel.text = string;
}

- (int)randomNumberBetween:(int)from to:(int)to
{
  return (int)from + arc4random() % (to-from+1);
}

- (UIImage *)randomImage
{
  return _images[[self randomNumberBetween:0 to:_images.count-1]];
}

- (BOOL)isSnap
{
  UIImage *i0 = (_states[0].boolValue) ? _backViews[0].image : _frontViews[0].image;
  UIImage *i1 = (_states[1].boolValue) ? _backViews[1].image : _frontViews[1].image;
  UIImage *i2 = (_states[2].boolValue) ? _backViews[2].image : _frontViews[2].image;
  return i0 == i1 && i1 == i2;
}

- (void)snap:(id)sender
{
  [self playerDidSnap:0];
}

- (void)playerDidSnap:(NSInteger)player
{
  if (_snapped) {
    return;
  }
  if ([self isSnap]) {
    _scores[player] = @(_scores[player].integerValue + 10);
    _snapped = YES;
    [_winSound play];
  } else {
    _scores[player] = @(_scores[player].integerValue - 30);
    [_failSound play];
  }

  [self updateScores];
}

@end
