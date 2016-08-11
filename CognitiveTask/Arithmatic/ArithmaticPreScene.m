//
//  ArithmaticPreScene.m
//  nirsit
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "ArithmaticPreScene.h"

@implementation ArithmaticPreScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor clearColor];
    
    SKLabelNode * hintLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    hintLabel.text = @"TAP THE ANSWER";
    
    hintLabel.fontSize = 34;
    hintLabel.position = CGPointMake(CGRectGetMidX(self.frame)-100, CGRectGetMaxY(self.frame)-70);
    [self addChild:hintLabel];
    
    SKTexture *f1 = [SKTexture textureWithImageNamed:@"cross"];
    SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithTexture:f1];
    sprite1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    sprite1.name = @"charac";
    [self addChild:sprite1];
    if (_flag == 1) {
        hintLabel.hidden = YES;
    }
}


@end
