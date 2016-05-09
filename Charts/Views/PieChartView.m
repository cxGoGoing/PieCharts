//
//  PieChartView.m
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "PieChartView.h"
#import "ChartItemModel.h"
@interface PieChartView ()
@property (nonatomic, copy) NSArray* items;
@property (nonatomic, copy) NSArray* endPercentages;
@property (nonatomic, weak) UIView* contentView;
@property (nonatomic, weak) CAShapeLayer* pieLayer;
@property (nonatomic, weak) CAShapeLayer* sectionHightLight;
@property (nonatomic, strong) NSMutableDictionary* selectedItems;

- (UILabel*)descriptionLabelForItemAtIndex:(NSUInteger)index;
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index;
- (CGFloat)ratioForItemAtIndex:(NSUInteger)index;
- (ChartItemModel*)dataItemForIndex:(NSUInteger)index;
- (CAShapeLayer*)newCircleLayerWithRadius:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                                fillColor:(UIColor*)fillColor
                              borderColor:(UIColor*)borderColor
                          startPercentage:(CGFloat)startPercentage
                            endPercentage:(CGFloat)endPercentage;
@end
@implementation PieChartView

- (id)initWithFrame:(CGRect)frame items:(NSArray*)items
{
    self = [self initWithFrame:frame];
    if (self) {
        _items = [NSArray arrayWithArray:items];
        [self baseInit];
    }

    return self;
}

- (void)awakeFromNib
{
    [self baseInit];
}

- (void)baseInit
{
    
}

#pragma mark getter and setter
- (CGFloat)startPercentageForItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return 0;
    }

    return [_endPercentages[index - 1] floatValue];
}

- (CGFloat)endPercentageForItemAtIndex:(NSUInteger)index
{
    return [_endPercentages[index] floatValue];
}

- (ChartItemModel*)dataItemForIndex:(NSUInteger)index
{
    return self.items[index];
}

- (CGFloat)ratioForItemAtIndex:(NSUInteger)index
{
    return [self endPercentageForItemAtIndex:index] - [self startPercentageForItemAtIndex:index];
}

- (CAShapeLayer*)newCircleLayerWithRadius:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                                fillColor:(UIColor*)fillColor
                              borderColor:(UIColor*)borderColor
                          startPercentage:(CGFloat)startPercentage
                            endPercentage:(CGFloat)endPercentage
{
    CAShapeLayer* circle = [CAShapeLayer layer];

    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];

    circle.fillColor = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd = endPercentage;
    circle.lineWidth = borderWidth;
    circle.path = path.CGPath;

    return circle;
}

#pragma mark actions

- (void)didTouchAt:(CGPoint)touchLocation
{
    CGPoint circleCenter = CGPointMake(_contentView.bounds.size.width / 2, _contentView.bounds.size.height / 2);
    CGFloat distanceFromCenter = sqrtf(powf((touchLocation.y - circleCenter.y), 2) + powf((touchLocation.x - circleCenter.x), 2));
    if (distanceFromCenter < _innerCircleRadius) {
        if ([self.delegate respondsToSelector:@selector(didUnselectPieItem)]) {
            [self.delegate didUnselectPieItem];
        }
        [self.sectionHightLight removeFromSuperlayer];
        return;
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:_contentView];
    [self didTouchAt:touchLocation];
}

@end
