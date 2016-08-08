//
//  CALayer+Addition.m
//  speedmeter
//
//  Created by admin admin on 15/12/30.
//
//

#import "CALayer+Addition.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Addition)

- (void)setBorderColorFromUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}

@end
