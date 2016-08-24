//
//  HYSegmentedControl.m
//  CustomSegControlView
//
//  Created by sxzw on 14-6-12.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#import "HYSegmentedControl.h"

#define HYSegmentedControl_Height 43.0
#define HYSegmentedControl_Width (946)
#define Min_Width_4_Button 88.0

#define Define_Tag_add 1000

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HYSegmentedControl()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;

@end

@implementation HYSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    CGRect rect4View = CGRectMake(78.0f, y, HYSegmentedControl_Width, HYSegmentedControl_Height);
    if (self = [super initWithFrame:rect4View]) {
        
        //self.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        //
        //  set button
        //
        CGFloat width4btn = rect4View.size.width/[titles count];
        if (width4btn < Min_Width_4_Button) {
            width4btn = Min_Width_4_Button;
        }
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //_scrollView.backgroundColor = self.backgroundColor;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, HYSegmentedControl_Height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i<[titles count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*Min_Width_4_Button, .0f, Min_Width_4_Button, HYSegmentedControl_Height);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //btn.titleLabel.font = [UIFont systemFontOfSize:18];
            btn.titleLabel.font = [UIFont fontWithName:@"NotoSansCJKkr-Medium" size:16];
            btn.enabled = NO;
            //[btn setTitleColor:UIColorFromRGBValue(0x454545) forState:UIControlStateSelected];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
            }
        }
        
        //
        //  bottom lineView
        //
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, HYSegmentedControl_Height-2.5f, Min_Width_4_Button-10.0f, 2.5f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:0.0 green:174.0/255 blue:239.0/255 alpha:1.0];
        [_scrollView addSubview:_bottomLineView];
        
        [self addSubview:_scrollView];
    }
    return self;
}

//
//  btn clicked
//
- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    btn.hidden = NO;
    for (UIButton *subBtn in self.array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
            subBtn.hidden = YES;
        }
    }
    
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = (Min_Width_4_Button*(btn.tag - Define_Tag_add))+5;
    
    CGPoint pt = CGPointZero;
    BOOL canScrolle = YES;
    
    if (canScrolle) {
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentOffset = pt;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.bottomLineView.frame = rect4boottomLine;
                
            }];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomLineView.frame = rect4boottomLine;
        }];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }
}

-(void)changeBtnFrame{
    for (int i = 0;i < 10 ;i++) {
        UIButton *btn = [_array4Btn objectAtIndex:i];
        if (btn.tag - Define_Tag_add != 0) {
            btn.frame = CGRectMake(btn.frame.origin.x-60, btn.frame.origin.y, btn.frame.size.width+120, btn.frame.size.height);
        }
    }
}

-(void)changeBtnTitle:(NSString *)title withIndex:(NSInteger)index{
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [btn setTitle:title forState:UIControlStateNormal];
}


// delegete method
- (void)changeSegmentedControlWithIndex:(NSInteger)index
{
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self segmentedControlChange:btn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
