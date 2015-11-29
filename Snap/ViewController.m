//
//  ViewController.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "ViewController.h"
#import "FancyButton.h"
#import "ThemeCell.h"
#import "KTCenterFlowLayout.h"
#import "ServerHelper.h"
#import "GameViewController.h"

static const NSInteger initialSelection = 0;

@interface ViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController
{
  NSArray *_themes;
  UICollectionView *_themesView;
  FancyButton *_startButton;
  UILabel *_playersLabel;
  NSNumber *_selectedTheme;
  ThemeCell *_prevCell;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [[ServerHelper sharedHelper] addObserver:self forKeyPath:@"connectedClients" options:NSKeyValueObservingOptionInitial context:nil];
  }
  return self;
}

- (void)dealloc
{
  [[ServerHelper sharedHelper] removeObserver:self forKeyPath:@"connectedClients" context:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //self.view.backgroundColor = [UIColor whiteColor];

  _themes = @[
              @{
                @"id": @"emoji",
                @"image": @"theme_emoji",
                @"name": @"Emoji",
                },
              @{
                @"id": @"numbers",
                @"image": @"theme_numbers",
                @"name": @"Numbers",
                },
              @{
                @"id": @"people",
                @"image": @"theme_people",
                @"name": @"People",
                },
              ];

  KTCenterFlowLayout *layout = [[KTCenterFlowLayout alloc] init];
  layout.itemSize = CGSizeMake(300, 300);
  layout.minimumInteritemSpacing = 40;
  layout.minimumLineSpacing = 40;
  _themesView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300) collectionViewLayout:layout];
  _themesView.dataSource = self;
  _themesView.delegate = self;
  _themesView.clipsToBounds = NO;
  [_themesView registerClass:[ThemeCell class] forCellWithReuseIdentifier:@"theme"];
  [self.view addSubview:_themesView];

  _startButton = [FancyButton buttonWithType:UIButtonTypeSystem];
  _startButton.frame = CGRectMake(self.view.frame.size.width / 2 - 200, self.view.frame.size.height - 240, 400, 120);
  _startButton.backgroundColor = [UIColor colorWithRed:0.04 green:0.52 blue:0.89 alpha:1.00];;
  [_startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventPrimaryActionTriggered];
  [self.view addSubview:_startButton];

  UILabel *startLabel = [[UILabel alloc] initWithFrame:_startButton.bounds];
  startLabel.text = @"Start Game";
  startLabel.textColor = [UIColor whiteColor];
  startLabel.font = [UIFont boldSystemFontOfSize:36];
  startLabel.textAlignment = NSTextAlignmentCenter;
  [_startButton addSubview:startLabel];

  _playersLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150, _startButton.frame.origin.y + 140, 300, 40)];
  _playersLabel.font = [UIFont systemFontOfSize:28];
  _playersLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
  _playersLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_playersLabel];

  [self updatePlayersLabel];
}

- (void)start:(id)sender {
  NSDictionary *dict = _themes[_selectedTheme.integerValue];
  GameViewController *vc = [[GameViewController alloc] initWithTheme:dict[@"id"]];
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"connectedClients"] && object == [ServerHelper sharedHelper]) {
    [self updatePlayersLabel];
  }
}

- (void)updatePlayersLabel
{
  NSString *text = @"Just you playing";
  if ([ServerHelper sharedHelper].connectedClients.count > 0) {
    text = [NSString stringWithFormat:@"%li players connected", [ServerHelper sharedHelper].connectedClients.count];
  }
  _playersLabel.text = text;
}

- (UIView *)preferredFocusedView
{
//  return _selectedTheme ? _startButton : _themesView;
  return _themesView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return _themes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  ThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"theme" forIndexPath:indexPath];
  NSDictionary *dict = _themes[indexPath.row];
  cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
  cell.nameLabel.text = dict[@"name"];
  cell.tickView.hidden = !((!_selectedTheme && indexPath.row == initialSelection) || _selectedTheme.integerValue == indexPath.row);
  if (!cell.tickView.hidden && cell != _prevCell) {
    _prevCell.tickView.hidden = YES;
  } else {
    _prevCell = cell;
  }
  if (!_prevCell) {
    _prevCell = cell;
  }
  return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  _selectedTheme = @(indexPath.row);
    [collectionView reloadData];
//  [self setNeedsFocusUpdate];
//  [self updateFocusIfNeeded];
}

- (NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView
{
  return [NSIndexPath indexPathForItem:_selectedTheme.integerValue inSection:0];
}

@end
