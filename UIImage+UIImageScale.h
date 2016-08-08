//
//  UIImage.h
//  nirsit
//
//  Created by admin on 15/7/28.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage(UIImageScale)

-(UIImage*)getSubImage:(CGRect)rect;
- (UIImage *)fixOrientation:(UIImage *)aImage;

-(UIImage *)getImageFromView:(UIView *)view;
-(UIImage *)blurImage:(UIImage *)img;
@end
