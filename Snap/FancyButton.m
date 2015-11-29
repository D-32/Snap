//
//  FancyButton.m
//  Snap
//
//  Created by Dylan Marriott on 28/11/15.
//  Copyright © 2015 Dylan Marriott. All rights reserved.
//

#import "FancyButton.h"

@implementation FancyButton

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [self setBackgroundImage:[FancyButton imageFromColor:backgroundColor] forState:UIControlStateNormal];
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

@end
