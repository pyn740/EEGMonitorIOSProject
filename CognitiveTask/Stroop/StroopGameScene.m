//
//  StroopGameScene.m
//  nirsit
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "StroopGameScene.h"
#import "StroopItem.h"

@interface StroopGameScene(){
    SKLabelNode * labelNode;
    SKTexture * unselectTex;
    SKTexture * selectTex;
    NSTimer * timer;
    NSArray * charaArr,* skcolorArr;
    int process;
    NSMutableArray * resultArr;
}
@end

@implementation StroopGameScene

-(void)didMoveToView:(SKView *)view{
    
    self.backgroundColor = [SKColor clearColor];
    process = -1;
    resultArr = [[NSMutableArray alloc] init];
    
    charaArr = [NSArray arrayWithObjects:@"GREEN",@"PINK",@"RED",@"YELLOW",@"BLUE",@"BLACK",@"PURPLE",nil];
    skcolorArr = [NSArray arrayWithObjects:[SKColor greenColor],[SKColor colorWithRed:255.0/255 green:181.0/255 blue:197.0/255 alpha:1.0],[SKColor redColor],[SKColor yellowColor],[SKColor blueColor],[SKColor blackColor],[SKColor purpleColor],nil];
    //Times New Roman
    labelNode = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    labelNode.text = @"GREEN";
    labelNode.fontColor = [SKColor redColor];
    labelNode.fontSize = 155;
    labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:labelNode];
    
    unselectTex = [SKTexture textureWithImageNamed:@"unselect.png"];
    selectTex = [SKTexture textureWithImageNamed:@"select.png"];
    
    [self setButtonNodeWithName:@"firstNode" andPosition:CGPointMake(187, 55)];
    [self setButtonNodeWithName:@"SecondNode" andPosition:CGPointMake(481, 55)];
    
    [self setLabelNodeWithName:@"figure1" andPosition:CGPointMake(187, 40)];
    [self setLabelNodeWithName:@"figure2" andPosition:CGPointMake(481, 40)];
    
    [self showCharAndBtn];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.25 target:self selector:@selector(showCharAndBtn) userInfo:nil repeats:YES];
}



-(void)showCharAndBtn{
    
    if (!self.view) {
        [timer invalidate];
        for (StroopItem * item in resultArr) {
            NSLog(@"%d",item.isCorrect);
        }
    }
    
    process ++;
    int whichChar = arc4random() % 7;
    
    int whichColor = arc4random() % 7;
    while (whichChar == whichColor) {
        whichColor = arc4random() % 7;
    }
    labelNode.text = [charaArr objectAtIndex:whichChar];
    labelNode.fontColor = [skcolorArr objectAtIndex:whichColor];
    StroopItem * resultItem = [[StroopItem alloc] init];
    resultItem.colorStr = [charaArr objectAtIndex:whichChar];;
    resultItem.currentColor = [charaArr objectAtIndex:whichColor];
    resultItem.isCorrect = NO;
    [resultArr addObject:resultItem];
    
    SKNode * firstBtnNode = [self childNodeWithName:@"firstNode"];
    SKNode * secondBtnNode = [self childNodeWithName:@"SecondNode"];
    SKNode * figure1Node = [self childNodeWithName:@"figure1"];
    SKNode * figure2Node = [self childNodeWithName:@"figure2"];
    SKAction *unselAction = [SKAction setTexture:unselectTex];
    [firstBtnNode runAction:unselAction];
    [secondBtnNode runAction:unselAction];
    ((SKLabelNode *)figure1Node).fontColor = [SKColor grayColor];
    ((SKLabelNode *)figure2Node).fontColor = [SKColor grayColor];
    int flag = arc4random() % 2;
    switch (flag) {
        case 0:
        {
            ((SKLabelNode *)figure1Node).text =[charaArr objectAtIndex:whichChar];
            ((SKLabelNode *)figure2Node).text = [charaArr objectAtIndex:whichColor];
            break;
        }
        case 1:
        {
            ((SKLabelNode *)figure1Node).text =[charaArr objectAtIndex:whichColor];
            ((SKLabelNode *)figure2Node).text = [charaArr objectAtIndex:whichChar];
            break;
        }
        default:
            break;
    }
    
    if (process == 19) {
        [timer invalidate];
        for (StroopItem * item in resultArr) {
            NSLog(@"%d",item.isCorrect);
        }
    }
}

-(void)setButtonNodeWithName:(NSString *)btnName andPosition:(CGPoint)pos{
    
    SKSpriteNode * node = [SKSpriteNode spriteNodeWithTexture:unselectTex];
    node.position = pos;
    node.name = btnName;
    node.zPosition = 1.0;
    [self addChild:node];
}

-(void)setLabelNodeWithName:(NSString *)labelName andPosition:(CGPoint)pos{
    SKLabelNode * node = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Bold"];
    node.fontSize = 45;
    node.fontColor = [UIColor grayColor];
    node.position = pos;
    node.name = labelName;
    node.zPosition = 2.0;
    [self addChild:node];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKNode * firstBtnNode = [self childNodeWithName:@"firstNode"];
    SKNode * secondBtnNode = [self childNodeWithName:@"SecondNode"];
    SKNode * figure1Node = [self childNodeWithName:@"figure1"];
    SKNode * figure2Node = [self childNodeWithName:@"figure2"];
    
    SKAction *unselAction = [SKAction setTexture:unselectTex];
    SKAction *selAction = [SKAction setTexture:selectTex];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode * node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"firstNode"] || [node.name isEqualToString:@"figure1"]) {
        ((SKLabelNode *)figure1Node).fontColor = [SKColor whiteColor];
        ((SKLabelNode *)figure2Node).fontColor = [SKColor grayColor];
        [firstBtnNode runAction:selAction];
        [secondBtnNode runAction:unselAction];
        if ([((StroopItem *)[resultArr objectAtIndex:process]).currentColor isEqual:((SKLabelNode *)figure1Node).text]) {
            ((StroopItem *)[resultArr objectAtIndex:process]).isCorrect = YES;
        }else{
            ((StroopItem *)[resultArr objectAtIndex:process]).isCorrect = NO;
        }
        
    }else if ([node.name isEqualToString:@"SecondNode"] || [node.name isEqualToString:@"figure2"]) {
        ((SKLabelNode *)figure1Node).fontColor = [SKColor grayColor];
        ((SKLabelNode *)figure2Node).fontColor = [SKColor whiteColor];
        [firstBtnNode runAction:unselAction];
        [secondBtnNode runAction:selAction];
        if ([((StroopItem *)[resultArr objectAtIndex:process]).currentColor isEqual:((SKLabelNode *)figure2Node).text]) {
            ((StroopItem *)[resultArr objectAtIndex:process]).isCorrect = YES;
        }else{
            ((StroopItem *)[resultArr objectAtIndex:process]).isCorrect = NO;
        }
    }
    
}


@end
