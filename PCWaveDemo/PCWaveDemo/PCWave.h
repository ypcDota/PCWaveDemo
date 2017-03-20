//
//  PCWave.h
//  PCWaveDemo
//
//  Created by ypc on 17/3/20.
//  Copyright © 2017年 com.ypc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define XNColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef void(^WaveBlock)(CGFloat currentY);
@interface PCWave : UIView
// 波浪弯曲度
@property (nonatomic ,assign) CGFloat waveCurvature;

// 波浪速度
@property (nonatomic ,assign) CGFloat waveSpeed;

// 浪高
@property (nonatomic ,assign) CGFloat waveHeight;

// 实体颜色
@property (nonatomic ,strong) UIColor *realWaveColor;

// 遮罩颜色
@property (nonatomic ,strong) UIColor *maskWaveColor;

//
@property (nonatomic ,strong) WaveBlock waveBlock;
- (void)startWaveAnimation;

- (void)stopWaveAnimation;

@end
