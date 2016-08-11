//
//  ArithmeticGameScene.m
//  nirsit
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 cqupt. All rights reserved.
//

#import "ArithmeticGameScene.h"
#import "ArithmaticItem.h"

@interface ArithmeticGameScene(){
    
    NSMutableArray * resultArr;
    int leftDigit,rightDigit,correctAns;
    SKLabelNode * leftLabel,*rightLabel;
    NSTimer * timer;
    int process;
    int currentProcess;
    
    SKTexture * unselectTex;
    SKTexture * selectTex;
}
@end

@implementation ArithmeticGameScene



-(void)didMoveToView:(SKView *)view{
    
    self.backgroundColor = [SKColor clearColor];
    process = 0;
    resultArr = [[NSMutableArray alloc] init];
    
    leftLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    leftLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    leftLabel.fontSize = 225;
    leftLabel.position = CGPointMake(CGRectGetMidX(self.frame)-90, CGRectGetMidY(self.frame)-30);
    [self addChild:leftLabel];
    SKLabelNode * hintLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    hintLabel.text = @"X";
    hintLabel.fontSize = 145;
    hintLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:hintLabel];
    rightLabel = [SKLabelNode labelNodeWithFontNamed:@"NotoSansCJKkr-Medium"];
    rightLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    rightLabel.fontSize = 225;
    rightLabel.position = CGPointMake(CGRectGetMidX(self.frame)+90, CGRectGetMidY(self.frame)-30);
    [self addChild:rightLabel];
    
    unselectTex = [SKTexture textureWithImageNamed:@"unselectBtn"];
    selectTex = [SKTexture textureWithImageNamed:@"selectBtn"];
    
    [self setButtonNodeWithName:@"firstNode" andPosition:CGPointMake(95, 40)];
    [self setButtonNodeWithName:@"SecondNode" andPosition:CGPointMake(190+27+95, 40)];
    [self setButtonNodeWithName:@"ThirdNode" andPosition:CGPointMake(380+54+95, 40)];
    [self setLabelNodeWithName:@"figure1" andPosition:CGPointMake(95, 23)];
    [self setLabelNodeWithName:@"figure2" andPosition:CGPointMake(190+27+95, 23)];
    [self setLabelNodeWithName:@"figure3" andPosition:CGPointMake(380+54+95, 23)];
    
    [self showDigitAndBtn];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(activeTime) userInfo:nil repeats:YES];
}

-(void)activeTime{
    if (!self.view) {
        [timer invalidate];
    }
    process ++;
    if (process == 20) {
        [timer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getResult" object:self userInfo:[NSDictionary dictionaryWithObject:resultArr forKey:@"result"]];
    }
    if (!(process%3)) {
        [self showDigitAndBtn];
    }
    
}

-(void)showDigitAndBtn{
    
    if (_level == 1) {
        leftDigit = arc4random() % 9 + 1;
        rightDigit = arc4random() % 9 + 1;
    }else if (_level == 2) {
        if ((leftDigit = arc4random() % 99 + 1) < 10) {
            rightDigit = arc4random() % 90 + 10;
        }else{
            rightDigit = arc4random() % 9 + 1;
        }
    }else if(_level == 3){
        leftDigit = arc4random() % 90 + 10;
        rightDigit = arc4random() % 90 + 10;
    }
    correctAns = leftDigit * rightDigit;
    
    leftLabel.text = [NSString stringWithFormat:@"%d",leftDigit];
    rightLabel.text = [NSString stringWithFormat:@"%d",rightDigit];
    ArithmaticItem * resultItem = [[ArithmaticItem alloc] init];
    resultItem.leftDigit = leftDigit;
    resultItem.rightDigit = rightDigit;
    resultItem.correctAns = correctAns;
    resultItem.isCorrect = NO;
    [resultArr addObject:resultItem];
    
    
    int flag = arc4random() % 3 + 1;
    int digit1,digit2,digit3;
    NSMutableArray * flagDigitArr = [[NSMutableArray alloc] init];
    switch (flag) {
        case 1:
        {
            [flagDigitArr removeAllObjects];
            [flagDigitArr addObjectsFromArray:@[@"-2",@"-1",@"0"]];
            flag = arc4random() % 3;
            digit1 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            flag = arc4random() % 2;
            digit2 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            digit3 = correctAns + 10*[[flagDigitArr objectAtIndex:0] intValue];
            digit1 = [self avoidNegativeDigit:digit1];
            digit2 = [self avoidNegativeDigit:digit2];
            digit3 = [self avoidNegativeDigit:digit3];
            
            break;
        }
        case 2:
        {
            [flagDigitArr removeAllObjects];
            [flagDigitArr addObjectsFromArray:@[@"-1",@"0",@"1"]];
            flag = arc4random() % 3;
            digit1 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            flag = arc4random() % 2;
            digit2 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            digit3 = correctAns + 10*[[flagDigitArr objectAtIndex:0] intValue];
            
            digit1 = [self avoidNegativeDigit:digit1];
            digit2 = [self avoidNegativeDigit:digit2];
            digit3 = [self avoidNegativeDigit:digit3];
            
            break;
        }
        case 3:
        {
            [flagDigitArr removeAllObjects];
            [flagDigitArr addObjectsFromArray:@[@"0",@"1",@"2"]];
            flag = arc4random() % 3;
            digit1 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            flag = arc4random() % 2;
            digit2 = correctAns + 10*[[flagDigitArr objectAtIndex:flag] intValue];
            [flagDigitArr removeObjectAtIndex:flag];
            digit3 = correctAns + 10*[[flagDigitArr objectAtIndex:0] intValue];
            break;
        }
        default:
            break;
    }
    
    SKNode * figure1Node = [self childNodeWithName:@"figure1"];
    SKNode * figure2Node = [self childNodeWithName:@"figure2"];
    SKNode * figure3Node = [self childNodeWithName:@"figure3"];
    ((SKLabelNode *)figure1Node).text = [NSString stringWithFormat:@"%d",digit1];
    ((SKLabelNode *)figure2Node).text = [NSString stringWithFormat:@"%d",digit2];
    ((SKLabelNode *)figure3Node).text = [NSString stringWithFormat:@"%d",digit3];
    SKNode * firstBtnNode = [self childNodeWithName:@"firstNode"];
    SKNode * secondBtnNode = [self childNodeWithName:@"SecondNode"];
    SKNode * thirdBtnNode = [self childNodeWithName:@"ThirdNode"];
    SKAction *unselAction = [SKAction setTexture:unselectTex];
    [firstBtnNode runAction:unselAction];
    [secondBtnNode runAction:unselAction];
    [thirdBtnNode runAction:unselAction];
    
}

-(int)avoidNegativeDigit:(int)digit{
    if(digit < 0) {
        do {
            digit = arc4random() % 8 + 1;
        } while (digit == correctAns);
    }
    return digit;
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
    node.position = pos;
    node.name = labelName;
    node.zPosition = 2.0;
    [self addChild:node];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    SKNode * firstBtnNode = [self childNodeWithName:@"firstNode"];
    SKNode * secondBtnNode = [self childNodeWithName:@"SecondNode"];
    SKNode * thirdBtnNode = [self childNodeWithName:@"ThirdNode"];
    SKNode * figure1Node = [self childNodeWithName:@"figure1"];
    SKNode * figure2Node = [self childNodeWithName:@"figure2"];
    SKNode * figure3Node = [self childNodeWithName:@"figure3"];
    
    SKAction *unselAction = [SKAction setTexture:unselectTex];
    SKAction *selAction = [SKAction setTexture:selectTex];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode * node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"firstNode"] || [node.name isEqualToString:@"figure1"]) {
        
        [firstBtnNode runAction:selAction];
        [secondBtnNode runAction:unselAction];
        [thirdBtnNode runAction:unselAction];
        
        if (((ArithmaticItem *)[resultArr objectAtIndex:process/3]).correctAns == [((SKLabelNode *)figure1Node).text intValue]) {
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = YES;
        }else{
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = NO;
        }
    }else if ([node.name isEqualToString:@"SecondNode"] || [node.name isEqualToString:@"figure2"]) {
        
        [firstBtnNode runAction:unselAction];
        [secondBtnNode runAction:selAction];
        [thirdBtnNode runAction:unselAction];
        
        if (((ArithmaticItem *)[resultArr objectAtIndex:process/3]).correctAns == [((SKLabelNode *)figure2Node).text intValue]) {
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = YES;
        }
        else{
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = NO;
        }
        
    }else if ([node.name isEqualToString:@"ThirdNode"] || [node.name isEqualToString:@"figure3"]) {
        
        [firstBtnNode runAction:unselAction];
        [secondBtnNode runAction:unselAction];
        [thirdBtnNode runAction:selAction];
        
        if (((ArithmaticItem *)[resultArr objectAtIndex:process/3]).correctAns == [((SKLabelNode *)figure3Node).text intValue]) {
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = YES;
        }else{
            ((ArithmaticItem *)[resultArr objectAtIndex:process/3]).isCorrect = NO;
        }
        
    }
}


@end
