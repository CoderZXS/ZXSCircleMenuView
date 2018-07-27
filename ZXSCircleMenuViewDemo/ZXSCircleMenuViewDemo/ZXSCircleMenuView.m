//
//  ZXSCircleMenuView.m
//  CBCL
//
//  Created by CoderZXS on 2018/7/19.
//  Copyright © 2018年 Cammus. All rights reserved.
//

#import "ZXSCircleMenuView.h"
#import "ZXSCircleMenuModel.h"
#import "Masonry.h"

@interface ZXSCircleMenuView ()

@property (nonatomic, strong) UIImage *centerButtonImage;//中心按钮图片
@property (nonatomic, assign) CGFloat centerButtoRadius;//中心按钮半径
@property (nonatomic, strong) NSArray<ZXSCircleMenuModel *> *circleMenuModels;//菜单模型数组
@property (nonatomic, assign) CGFloat step;//圆弧按钮之间分隔度数
@property (nonatomic, assign) CGFloat arcButtonsRadius;//圆弧按钮半径
@property (nonatomic, assign) CGFloat startAngle;//圆圈开始角度
@property (nonatomic, assign) CGFloat endAngle;//圆圈结束角度
@property (nonatomic, assign) CGFloat distance;//中心按钮和圆弧按钮之间的距离
@property (nonatomic, assign) CGFloat duration;//画圆弧动画时间
@property (nonatomic, assign) CGFloat showDelay;//显示按钮之间的延迟
@property (nonatomic, assign) CGFloat screenWidthFitScale;
@property (nonatomic, strong) NSMutableArray *containerViews;//containerViews数组
@property (nonatomic, weak) UIView *circleLoader;//添加转圈底盘
@property (nonatomic, weak) CAShapeLayer *circleShapeLayer;//圆弧


@end

@implementation ZXSCircleMenuView

#pragma mark - 系统
- (instancetype)initWithCircleMenuModels:(NSArray<ZXSCircleMenuModel *> *)circleMenuModels startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle centerButtonRadius:(CGFloat)centerButtonRadius arcButtonsRadius:(CGFloat)arcButtonsRadius distance:(CGFloat)distance duration:(CGFloat)duration showDelay:(CGFloat)showDelay screenWidthFitScale:(CGFloat)screenWidthFitScale {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.circleMenuModels = circleMenuModels;
        self.step = 360.0 / circleMenuModels.count;
        self.startAngle = startAngle;
        self.endAngle = endAngle;
        self.arcButtonsRadius = arcButtonsRadius;
        self.centerButtoRadius = centerButtonRadius;
        self.distance = distance;
        self.duration = duration;
        self.showDelay = showDelay;
        self.screenWidthFitScale = screenWidthFitScale;
        [self setupChildUI];
    }
    
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) zxs_weakSelf = self;
    for (UIView *containerView in self.containerViews) {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(zxs_weakSelf.mas_centerX).with.offset(0);
            make.centerY.equalTo(zxs_weakSelf.mas_centerY).with.offset(0);
            make.width.mas_equalTo((zxs_weakSelf.arcButtonsRadius * 2));
            make.height.mas_equalTo(zxs_weakSelf.distance);
        }];
    }
    
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zxs_weakSelf.mas_centerX).with.offset(0);
        make.centerY.equalTo(zxs_weakSelf.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo((zxs_weakSelf.centerButtoRadius * 2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zxs_weakSelf.mas_centerX).with.offset(0);
        make.centerY.equalTo(zxs_weakSelf.mas_centerY).with.offset((50 * zxs_weakSelf.screenWidthFitScale));
    }];
    
    [self.circleLoader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zxs_weakSelf.mas_centerX).with.offset(0);
        make.centerY.equalTo(zxs_weakSelf.mas_centerY).with.offset(0);
        make.width.height.mas_equalTo((zxs_weakSelf.distance * 2));
    }];
}



#pragma mark - 初始化方法
- (void)setupChildUI {
    
    //添加圆弧按钮
    self.containerViews = [NSMutableArray array];
    self.arcButtons = [NSMutableArray array];
    self.sectorShapeLayers = [NSMutableArray array];
    NSInteger buttonCount = self.circleMenuModels.count;
    for (NSInteger i = 0; i < buttonCount; i++) {
        
        //containerView
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.arcButtonsRadius * 2), self.distance)];
        [self addSubview:containerView];
        [self.containerViews addObject:containerView];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        containerView.layer.anchorPoint = CGPointMake(0.5, 1);
        containerView.layer.transform = CATransform3DMakeRotation(((self.startAngle + i * self.step) * M_PI / 180.0), 0.0, 0.0, 1.0);
        
        //扇形
        UIBezierPath *sectorBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.arcButtonsRadius,self.distance) radius:(self.distance - self.arcButtonsRadius * 1.53) startAngle:(-(89 + self.step * 0.5) * M_PI / 180.0) endAngle:((self.step * 0.5 - 91) * M_PI / 180.0) clockwise:YES];
        [sectorBezierPath addLineToPoint:CGPointMake(self.arcButtonsRadius,self.distance)];
        [sectorBezierPath closePath];
        CAShapeLayer *sectorshapeLayer = [CAShapeLayer layer];
        [containerView.layer addSublayer:sectorshapeLayer];
        [self.sectorShapeLayers addObject:sectorshapeLayer];
        sectorshapeLayer.lineWidth = 1;
        sectorshapeLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
        sectorshapeLayer.path = sectorBezierPath.CGPath;
        sectorshapeLayer.hidden = YES;
        
        //圆弧按钮
        UIButton *arcButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.arcButtonsRadius * 2), (self.arcButtonsRadius * 2))];
        [containerView addSubview:arcButton];
        [self.arcButtons addObject:arcButton];
        arcButton.tag = i;
        arcButton.exclusiveTouch = YES;//防止同时点击
        arcButton.userInteractionEnabled = YES;
        arcButton.backgroundColor = [UIColor clearColor];
        ZXSCircleMenuModel *circleMenuModel = self.circleMenuModels[i];
        [arcButton setImage:[UIImage imageNamed:circleMenuModel.normalImageName] forState:UIControlStateNormal];
        [arcButton setImage:[UIImage imageNamed:circleMenuModel.selectImageName] forState:UIControlStateSelected];
        arcButton.imageView.contentMode =  UIViewContentModeScaleAspectFit;
        [arcButton addTarget:self action:@selector(tapArcButton:) forControlEvents:UIControlEventTouchUpInside];
        arcButton.layer.transform = CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0);
        arcButton.layer.cornerRadius = self.arcButtonsRadius;
    }
    
    //添加中心按钮
    UIButton *centerButton = [[UIButton alloc] init];
    [self addSubview:centerButton];
    self.centerButton = centerButton;
    centerButton.backgroundColor = [UIColor blackColor];
    centerButton.layer.cornerRadius = self.centerButtoRadius;
    centerButton.enabled = NO;
    
    //添加模式标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = @"标题";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加转圈底盘
    UIView *circleLoader = [[UIView alloc] init];
    [self addSubview:circleLoader];
    self.circleLoader = circleLoader;
    circleLoader.alpha = 0.0;
    circleLoader.backgroundColor = [UIColor clearColor];
    circleLoader.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加圆弧
    CAShapeLayer *circleShapeLayer = [CAShapeLayer layer];
    [circleLoader.layer addSublayer:circleShapeLayer];
    self.circleShapeLayer = circleShapeLayer;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.distance, self.distance) radius:(self.distance - self.arcButtonsRadius * 1.3) startAngle:0.0 endAngle:(M_PI * 2) clockwise:YES];
    circleShapeLayer.path = [circlePath CGPath];
    circleShapeLayer.lineWidth = self.arcButtonsRadius;
    circleShapeLayer.fillColor = UIColor.clearColor.CGColor;
    circleShapeLayer.strokeColor = [UIColor colorWithRed:(133 / 255.0) green:(133 / 255.0) blue:(133 / 255.0) alpha:0.3].CGColor;
}



#pragma mark - 事件方法
/**
 点击圆弧按钮出发方法
 */
- (void)tapArcButton:(UIButton *)button {
    
    //点击按钮处理block
    if (self.tapArcButtonCompletion) {
        self.tapArcButtonCompletion(button);
    }
    
    //旋转containerView
    [self zxs_rotationAnimationWithAngle:((atan2(button.superview.transform.b, button.superview.transform.a) * (180 / M_PI)) + 360) button:button];

    [self zxs_fillAnimationWithDuration:self.duration startAngle:(-90 + self.startAngle + self.step * (button.tag - 0.5)) completion:nil];
    
    [self zxs_hideAnimationWithDuration:0.5 delay:self.duration completion:nil];
}



#pragma mark - 动画
/**
 container旋转动画
 */
- (void)zxs_rotationAnimationWithAngle:(CGFloat)angle button:(UIButton *)button {
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = self.duration;
    rotation.toValue = @(angle * M_PI / 180.0);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [button.superview.layer addAnimation:rotation forKey:@"rotation"];
}


/**
 圆弧填充动画
 */
- (void)zxs_fillAnimationWithDuration:(CGFloat)duration startAngle:(CGFloat)startAngle completion:(void(^)(void))completion {
    
    self.circleLoader.alpha = 1.0;
    CATransform3D rotateTransform = CATransform3DMakeRotation((startAngle * M_PI / 180.0), 0.0, 0.0, 1.0);
    self.circleLoader.layer.transform = rotateTransform;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circleShapeLayer addAnimation:animation forKey:nil];
    [CATransaction commit];
}


/**
 圆弧隐藏动画
 */
- (void)zxs_hideAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void(^)(void))completion {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @1.2;
    scaleAnimation.duration = duration;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.beginTime = CACurrentMediaTime() + delay;
    [self.circleLoader.layer addAnimation:scaleAnimation forKey:nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.circleLoader.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion != nil) {
            completion();
        }
    }];
}

@end
