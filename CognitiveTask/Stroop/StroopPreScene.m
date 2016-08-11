//
//  StroopPreScene.m
//  nirsit
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "StroopPreScene.h"

@implementation StroopPreScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor clearColor];
    
    SKLabelNode * hintLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    hintLabel.text = @"TAP WORD COLOR";
    hintLabel.fontColor = [SKColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    hintLabel.fontSize = 34;
    hintLabel.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMaxY(self.frame)-70);
    [self addChild:hintLabel];
    
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"blackCross"];
    SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithTexture:f1];
    sprite1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    sprite1.name = @"charac";
    [self addChild:sprite1];
    if (_flag == 1) {
        hintLabel.hidden = YES;
    }
}

@end
