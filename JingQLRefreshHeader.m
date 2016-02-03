//
//  JingQLRefershHeader.m
//  JingQL
//
//  Created by JingQL on 15/12/5.
//  Copyright © 2015年 JingQL. All rights reserved.
//

#import "JingQLRefreshHeader.h"
#import "Masonry.h"

@interface JingQLRefreshHeader()

@property (nonatomic) UIImageView *logoImageView;
@property (nonatomic) UILabel *refreshLabel;
@property (nonatomic) UILabel *refreshStatusLabel;
@property (nonatomic) UIImageView *arrowImageView;
@property (nonatomic) UIImageView *loadingImageView;

@end

@implementation JingQLRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    JingQLRefreshHeader *header = (JingQLRefreshHeader *)[super headerWithRefreshingBlock:refreshingBlock];
    return header;
}

- (void)prepare {
    [super prepare];
    
    
    self.logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    [self addSubview:self.logoImageView];
    self.refreshLabel = [[UILabel alloc] init];
    
    self.refreshLabel.font = [UIFont systemFontOfSize:10];
    self.refreshLabel.textColor = [UIColor blackColor];
    self.refreshLabel.text = @"JingQL";
    [self addSubview:self.refreshLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    [self addSubview:self.arrowImageView];
    
    self.loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refreshing"]];
    [self addSubview:self.loadingImageView];
    
    self.refreshStatusLabel = [[UILabel alloc] init];
    self.refreshStatusLabel.textColor = self.refreshLabel.textColor;
    self.refreshStatusLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.refreshStatusLabel];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.top.equalTo(@14);
        make.centerX.equalTo(self).offset(-45);
    }];
    
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView);
        make.leading.equalTo(self.mas_centerX).offset(-16);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.leading.equalTo(self.refreshLabel).offset(3);
        make.bottom.equalTo(self.logoImageView);
    }];
    
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.arrowImageView);
    }];
    
    [self.refreshStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.loadingImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.loadingImageView);
    }];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    if (state == MJRefreshStateIdle) {
        self.arrowImageView.hidden = NO;
        self.loadingImageView.hidden = YES;
        [self.loadingImageView.layer removeAllAnimations];
        self.refreshStatusLabel.text = @"下拉可以刷新";
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) {
        self.arrowImageView.hidden = NO;
        self.loadingImageView.hidden = YES;
        [self.loadingImageView.layer removeAllAnimations];
        self.refreshStatusLabel.text = @"释放刷新......";
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.refreshStatusLabel.text = @"刷新中......";
        self.arrowImageView.hidden = YES;
        self.loadingImageView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }];
        
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
        rotationAnimation.duration = 2;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 30;
        [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}
@end
