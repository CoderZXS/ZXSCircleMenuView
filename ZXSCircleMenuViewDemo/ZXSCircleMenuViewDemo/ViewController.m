//
//  ViewController.m
//  ZXSCircleMenuViewDemo
//
//  Created by bi xu on 2018/7/27.
//  Copyright © 2018年 CoderZXS. All rights reserved.
//

#import "ViewController.h"
#import "ZXSCircleMenuView.h"
#import "ZXSCircleMenuModel.h"
#import "MJExtension.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, weak) ZXSCircleMenuView *circleMenuView;
@property (nonatomic, strong) NSMutableArray<ZXSCircleMenuModel *> *circleMenuModels;
@property (nonatomic, assign) NSUInteger preArcButtonIndex;
@property (nonatomic, weak) UIButton *currentSelectedArcButton;

@end

@implementation ViewController

#pragma mark - 懒加载
- (NSMutableArray<ZXSCircleMenuModel *> *)circleMenuModels {
    if (nil == _circleMenuModels) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"modeItem" ofType:@"plist"];
        NSArray *buttonDictArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        self.circleMenuModels = [ZXSCircleMenuModel mj_objectArrayWithKeyValuesArray:buttonDictArray];
    }
    
    return _circleMenuModels;
}



#pragma mark - 系统方法
- (void)dealloc {
    [self.circleMenuModels removeAllObjects];
    self.circleMenuModels = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preArcButtonIndex = NSUIntegerMax;
    
    //circleMenuView
    ZXSCircleMenuView *circleMenuView = [[ZXSCircleMenuView alloc] initWithCircleMenuModels:self.circleMenuModels startAngle:-20 endAngle:340 centerButtonRadius:30 arcButtonsRadius:45 distance:150 duration:0.6 showDelay:0 screenWidthFitScale:1.0];
    [self.view addSubview:circleMenuView];
    self.circleMenuView = circleMenuView;
    [circleMenuView.centerButton setImage:[UIImage imageNamed:@"ic_center_mode"] forState:UIControlStateNormal];
    [circleMenuView.centerButton addTarget:self action:@selector(tapCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    circleMenuView.titleLabel.text = @"选择模式";
    circleMenuView.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    circleMenuView.tapArcButtonCompletion = ^(UIButton *arcButton) {
        
        //设置当前按钮不能再进行交互作用
        arcButton.userInteractionEnabled = YES;
        self.currentSelectedArcButton = arcButton;
    };
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    __weak typeof(self) zxs_weakSelf = self;
    [self.circleMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zxs_weakSelf.view.mas_centerX).with.offset(0);
        make.centerY.equalTo(zxs_weakSelf.view.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo(300);
    }];
}


- (void)tapCenterButton:(UIButton *)button {
    
    CAShapeLayer *sectorShapeLayer = self.circleMenuView.sectorShapeLayers[self.preArcButtonIndex];
    sectorShapeLayer.hidden = NO;
}


@end
