//
//  NBackPreScene.m
//  nirsit
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "NBackPreScene.h"

@implementation NBackPreScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor clearColor];
    
    SKLabelNode * hintLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    hintLabel.text = @"TAP IF SAME AS PREVIOUS";
    hintLabel.fontSize = 34;
    hintLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame)-30);
    [self addChild:hintLabel];
    if (_flag == 1) {
        hintLabel.hidden = YES;
    }
    
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"cross"];
    SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithTexture:f1];
    sprite1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    sprite1.name = @"charac";
    [self addChild:sprite1];
}

@end
