//
//  ViewController.m
//  HJ_Slider
//
//  Created by 马海江 on 2017/7/4.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "ViewController.h"
#import "ProgressLine.h"

#define Margin 20

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *score;

/**
 *  进度条（线）
 */
@property (nonatomic, weak) ProgressLine *line;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    ProgressLine *line = [[ProgressLine alloc] init];
    self.line = line;
    line.frame = CGRectMake(Margin, 100, [UIScreen mainScreen].bounds.size.width - 2 * Margin, 40);
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
    UIView *dark = [[UIView alloc] initWithFrame:CGRectMake(line.bounds.origin.x + Margin, line.bounds.origin.y, line.bounds.size.width - 2 * Margin, 5)];
    dark.backgroundColor = [UIColor lightGrayColor];
    dark.layer.cornerRadius = 5;
    dark.layer.masksToBounds = YES;
    dark.alpha = 0.1;
    [line addSubview:dark];
    
}

- (IBAction)Show:(UIButton *)sender {
    self.line.linePercent = [self.score.text floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
