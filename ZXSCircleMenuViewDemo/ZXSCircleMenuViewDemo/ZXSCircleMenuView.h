//
//  ZXSCircleMenuView.h
//  CBCL
//
//  Created by CoderZXS on 2018/7/19.
//  Copyright © 2018年 Cammus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXSCircleMenuModel;
@interface ZXSCircleMenuView : UIView

@property (nonatomic, strong) NSMutableArray<UIButton *> *arcButtons;//圆弧按钮
@property (nonatomic, strong) NSMutableArray *sectorShapeLayers;//扇形数组
@property (nonatomic, weak) UIButton *centerButton;//中心按钮
@property (nonatomic, weak) UILabel *titleLabel;//标题Label
@property (nonatomic, copy) void(^tapArcButtonCompletion)(UIButton *);

- (instancetype)initWithCircleMenuModels:(NSArray<ZXSCircleMenuModel *> *)circleMenuModels startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle centerButtonRadius:(CGFloat)centerButtonRadius arcButtonsRadius:(CGFloat)arcButtonsRadius distance:(CGFloat)distance duration:(CGFloat)duration showDelay:(CGFloat)showDelay screenWidthFitScale:(CGFloat)screenWidthFitScale;

@end
