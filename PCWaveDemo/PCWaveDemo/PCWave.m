//
//  PCWave.m
//  PCWaveDemo
//
//  Created by ypc on 17/3/20.
//  Copyright © 2017年 com.ypc. All rights reserved.
//

#import "PCWave.h"

@interface PCWave ()
// 刷屏器
@property (nonatomic ,strong) CADisplayLink *timer;

//真是浪
@property (nonatomic ,strong) CAShapeLayer *realWaveLayer;

// 遮罩浪
@property (nonatomic ,strong) CAShapeLayer *maskWaveLayer;

@property (nonatomic ,assign) CGFloat offset;
@end

@implementation PCWave
#pragma mark - 懒加载
- (CAShapeLayer *)realWaveLayer
{
    if (!_realWaveLayer){
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}

- (CAShapeLayer *)maskWaveLayer
{
    if (!_maskWaveLayer){
        _maskWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = self.bounds.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer.frame = frame;
        _maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
    
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.waveSpeed = 0.5;
    self.waveCurvature = 1.5;
    self.waveHeight = 4;
    self.realWaveColor = [UIColor whiteColor];
    self.maskWaveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer];
}

- (void)setWaveHeight:(CGFloat)waveHeight
{
    _waveHeight = waveHeight;
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height - self.waveHeight;
    frame.size.height = self.waveHeight;
    _realWaveLayer.frame = frame;
    
    CGRect frame1 = self.bounds;
    frame1.origin.y = frame1.size.height - self.waveHeight;
    frame1.size.height = self.waveHeight;

    _maskWaveLayer.frame = frame1;
}


- (void)startWaveAnimation
{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)wave{
    
    self.offset += self.waveSpeed;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.waveHeight;
    
    // 真是浪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    
    // 遮罩浪
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathMoveToPoint(maskPath, NULL, 0, height);
    CGFloat maskY = 0.f;
    for (CGFloat x = 0.f;x <= width;x++){
        y = height * sinf(0.01*self.waveCurvature*x + self.offset*0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
        maskY = -y;
        CGPathAddLineToPoint(maskPath, NULL, x, maskY);
    }
    
    // 变化的中间的 Y 值
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = height * sinf(0.01*self.waveCurvature * centerX + self.offset*0.045);
    if (self.waveBlock){
        self.waveBlock(centerY);
    }
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.realWaveLayer.path = path;
    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskPath, NULL, width, height);
    CGPathAddLineToPoint(maskPath, NULL, 0, height);
    CGPathCloseSubpath(maskPath);
    self.maskWaveLayer.path = maskPath;
    self.maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskPath);
}
- (void)stopWaveAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}
@end
/* The shape layer draws a cubic Bezier spline in its coordinate space.
 * shaplayer 在他的坐标空间 绘制一个贝塞尔曲线
 * The spline is described using a CGPath object and may have both fill
 曲线通过 CGPath 对象路径绘制出来,分为填充 和 stroke (在这种情况下 stroke 被混合于 填充之上)
 * and stroke components (in which case the stroke is composited over
 * the fill). The shape as a whole is composited between the layer's
 总的来说,形状在图层的内容 和 他的第一个子layer之间混合
 * contents and its first sublayer.
 *
 * The path object may be animated using any of the concrete(具体的) subclasses
 路径将会被动画 通过任何一个具体的 CAPropertyAnimation 子类
 * of CAPropertyAnimation. Paths will interpolate(插补,增进) as a linear(线性的) blend(混合) of
 * the "on-line" points; "off-line" points may be interpolated
 * non-linearly(非线性的) (e.g. to preserve continuity of the curve's
 * derivative). If the two paths have a different number of control
 * points or segments(分段,段数) the results are undefined(未定义).
 *
 * The shape will be drawn antialiased(属性,抗锯齿像素), and whenever possible it will
 * be mapped(映入,映射) into screen space before being rasterized(栅格化) to preserve(维持,保持)
 * resolution independence. (However, certain kinds of image processing(图像处理)
 * operations, e.g. CoreImage filters(过滤器), applied to the layer or its
 * ancestors(祖先,上代,父类) may force rasterization in a local coordinate space.)
 *
 * Note: rasterization may favor(优选速度) speed over accuracy(精确度), e.g. pixels with
 * multiple intersecting path segments(片段,段数) may not give exact results. */
