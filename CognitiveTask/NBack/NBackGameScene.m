//
//  NBackGameScene.m
//  nirsit
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "NBackGameScene.h"
#import "NBackItem.h"
#import "Constants.h"

@interface NBackGameScene() {
    int whichTime;
    NSString * fileName;
    NSTimer * timer;
}

@end

@implementation NBackGameScene


-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor clearColor];
    
    whichTime = 0;
    fileName = [@"char" stringByAppendingFormat:@"%d",((NBackItem *)[_presentChar objectAtIndex:whichTime]).letter - 64];
    SKTexture *f1 = [SKTexture textureWithImageNamed:fileName];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:f1];
    sprite.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    sprite.name = @"charac";
    [self addChild:sprite];
    
    NSLog(@"%c,%lf",((NBackItem *)[_presentChar objectAtIndex:whichTime]).letter,[[NSDate date] timeIntervalSince1970]);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePic) userInfo:nil repeats:YES];
    
}

-(void)changePic{
    
    if (!self.view) {
        [timer invalidate];
    }
    
    whichTime ++;
    
    SKNode * charNode = [self childNodeWithName:@"charac"];
    
    fileName = [@"char" stringByAppendingFormat:@"%d",((NBackItem *)[_presentChar objectAtIndex:whichTime]).letter - 64];
    SKAction *action1 = [SKAction fadeOutWithDuration:0.1];
    SKAction *action2 = [SKAction setTexture:[SKTexture textureWithImageNamed:fileName]];
    SKAction *action3 = [SKAction fadeInWithDuration:0.1];
    SKAction * seque = [SKAction sequence:@[action1,action2,action3]];
    [charNode runAction:seque];
    
    NSLog(@"%c,%lf",((NBackItem *)[_presentChar objectAtIndex:whichTime]).letter,[[NSDate date] timeIntervalSince1970]);
    
    if (whichTime >= PICNUM-1) {
        [timer invalidate];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    ((NBackItem *)[_presentChar objectAtIndex:whichTime]).tapCount ++;
    NSLog(@"%c,%d",((NBackItem *)[_presentChar objectAtIndex:whichTime]).letter,((NBackItem *)[_presentChar objectAtIndex:whichTime]).tapCount);
    
    SKNode * charNode = [self childNodeWithName:@"charac"];
    SKAction *action = [SKAction setTexture:[SKTexture textureWithImageNamed:[fileName stringByAppendingString:@"_selected"]]];
    [charNode runAction:action];
}

@end
