//
//  ProgressLine.m
//  HJ_Slider
//
//  Created by 马海江 on 2017/7/6.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "ProgressLine.h"

#define StringOffsetY 15
#define LineHeight 5
#define Margin 20 // 没有margin，进度字符串显示不全

@interface ProgressLine ()

/**
 *  屏帧定时器
 */
@property (nonatomic,strong)CADisplayLink *link;
/**
 *  定时器变量
 */
@property (nonatomic, assign) CGFloat lineValue;
/**
 *  中间变量，用于动画时候数字的变化(线的)
 */
@property (nonatomic, assign) CGFloat lineCurrentValue;
/**
 *  Layer(线)
 */
@property (nonatomic, strong) CAGradientLayer *lineLayer;

@end

@implementation ProgressLine

- (void)drawRect:(CGRect)rect{
    self.lineLayer.frame = CGRectMake(self.bounds.origin.x + Margin, self.bounds.origin.y, (self.bounds.size.width - 2 * Margin) * _lineCurrentValue / 100, LineHeight);
    [self drawText];
}

/**
 *  绘制文字
 */
-(void)drawText{
    NSMutableAttributedString* linePrecentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f%%",self.lineCurrentValue]];
    NSRange linePrecentRange = NSMakeRange(0, linePrecentStr.string.length);
    
    [linePrecentStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:15]
                           range:linePrecentRange];
    
    [linePrecentStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor orangeColor]
                           range:linePrecentRange];
    
    CGRect linePrecentRect = [linePrecentStr boundingRectWithSize:self.bounds.size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                          context:nil];
    
    CGFloat linePrecentX = (self.bounds.size.width - 2 * Margin) * _lineCurrentValue / 100 - linePrecentRect.size.width / 2 + Margin;
    CGFloat linePrecentY = StringOffsetY;
    
    [linePrecentStr drawAtPoint:CGPointMake(linePrecentX, linePrecentY)];
}

/**
 *  屏帧动画
 */
-(void)animateprecent{
    if (self.lineValue < self.linePercent) {
        self.lineValue ++;
        _lineCurrentValue = _lineValue;
        [self setNeedsDisplay];
    }else{
        self.link.paused = YES;
        self.lineValue = 0;
    }
}

- (void)setLinePercent:(CGFloat)linePercent{
    if (linePercent > 100) {
        linePercent = 100;
    }
    _linePercent = linePercent;
    
    self.link.paused = NO;
}

#pragma makr - 懒加载
/**
 *  画渐变线
 */
- (CAGradientLayer *)lineLayer{
    if (_lineLayer == nil) {
        UIColor *colorOne = [UIColor colorWithRed:(255/255.0)  green:(128/255.0)  blue:(0/255.0)  alpha:0.0];
        UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(128/255.0)  blue:(0/255.0)  alpha:1.0];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        _lineLayer = [CAGradientLayer layer];
        _lineLayer.cornerRadius = LineHeight / 2;
        _lineLayer.masksToBounds = YES;
        //设置开始和结束位置(设置渐变的方向)
        _lineLayer.startPoint = CGPointMake(0, 0);
        _lineLayer.endPoint = CGPointMake(1, 0);
        _lineLayer.colors = colors;
        _lineLayer.speed = 100.0f;// 速度越快，延迟越低
        [self.layer insertSublayer: _lineLayer atIndex:0];
    }
    return _lineLayer;
}

/**
 *  定时器
 */
-(CADisplayLink *)link{
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateprecent)];
        _link.frameInterval = 1 ;
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

-(void)dealloc{
    [self.link invalidate];
    self.link = nil;
}
@end
