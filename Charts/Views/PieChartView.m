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
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) NSArray* endPercentages;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) CAShapeLayer* pieLayer;
@property (nonatomic, strong) CAShapeLayer* sectionHightLight;
@property (nonatomic, strong) NSMutableDictionary* selectedItems;
@property (nonatomic, strong) NSMutableArray* descriptionLabels;

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

#pragma mark public method

- (void)strokeChart
{
    [self loadDefault];
    [self recompute];

    ChartItemModel* currentItem;
    for (int i = 0; i < _items.count; i++) {
        currentItem = [self dataItemForIndex:i];

        CGFloat startPercentage = [self startPercentageForItemAtIndex:i];
        CGFloat endPercentage = [self endPercentageForItemAtIndex:i];

        CGFloat radius = _innerCircleRadius + (_outterCircleRadius - _innerCircleRadius) / 2;
        CGFloat borderWidth = _outterCircleRadius - _innerCircleRadius;

        CAShapeLayer* currentPieLayer = [self newCircleLayerWithRadius:radius
                                                           borderWidth:borderWidth
                                                             fillColor:[UIColor clearColor]
                                                           borderColor:currentItem.color
                                                       startPercentage:startPercentage
                                                         endPercentage:endPercentage];
        [_pieLayer addSublayer:currentPieLayer];
    }

    [self maskChart];

    for (int i = 0; i < _items.count; i++) {
        UILabel* descriptionLabel = [self descriptionLabelForItemAtIndex:i];
        [_contentView addSubview:descriptionLabel];
        [_descriptionLabels addObject:descriptionLabel];
    }
    [self addAnimation];
    [_descriptionLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [obj setAlpha:1];
    }];
}

- (void)addAnimation
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = _duration;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [_pieLayer.mask addAnimation:animation forKey:@"circleAnimation"];
}

- (void)maskChart
{
    CGFloat radius = _innerCircleRadius + (_outterCircleRadius - _innerCircleRadius) / 2;
    CGFloat borderWidth = _outterCircleRadius - _innerCircleRadius;
    CAShapeLayer* maskLayer = [self newCircleLayerWithRadius:radius
                                                 borderWidth:borderWidth
                                                   fillColor:[UIColor clearColor]
                                                 borderColor:[UIColor blackColor]
                                             startPercentage:0
                                               endPercentage:1];

    _pieLayer.mask = maskLayer;
}

#pragma mark private method
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
    _selectedItems = [NSMutableDictionary dictionary];
    _outterCircleRadius = CGRectGetWidth(self.bounds) / 2;
    _innerCircleRadius = CGRectGetWidth(self.bounds) / 4;
    _descriptionTextFont = [UIFont systemFontOfSize:18];
    _descriptionTextColor = [UIColor whiteColor];
    _descriptionTextShadowColor = [UIColor blackColor];
    _descriptionTextShadowOffset = CGSizeMake(0, 1);
    _duration = 1.0;
    [self loadDefault];
}

- (void)loadDefault
{
    __block CGFloat currentTotal = 0;
    CGFloat total = [[self.items valueForKeyPath:@"@sum.value"] floatValue];
    NSMutableArray* endPercentages = [NSMutableArray new];
    [_items enumerateObjectsUsingBlock:^(ChartItemModel* item, NSUInteger idx, BOOL* stop) {
        if (total == 0){
            [endPercentages addObject:@(1.0 / _items.count * (idx + 1))];
        }else{
            currentTotal += item.value;
            [endPercentages addObject:@(currentTotal / total)];
        }
    }];
    self.endPercentages = [endPercentages copy];

    [_contentView removeFromSuperview];
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _descriptionLabels = [NSMutableArray new];

    _pieLayer = [CAShapeLayer layer];
    [_contentView.layer addSublayer:_pieLayer];
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

- (UILabel*)descriptionLabelForItemAtIndex:(NSUInteger)index
{
    ChartItemModel* currentDataItem = [self dataItemForIndex:index];
    CGFloat distance = _innerCircleRadius + (_outterCircleRadius - _innerCircleRadius) / 2;
    CGFloat centerPercentage = ([self startPercentageForItemAtIndex:index] + [self endPercentageForItemAtIndex:index]) / 2;
    CGFloat rad = centerPercentage * 2 * M_PI;

    UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    //NSString * titleText = currentDataItem.textDescription;
    NSString* titleValue;
    if (self.showAbsoluteValues) {
        titleValue = [NSString stringWithFormat:@"%.0f", currentDataItem.value];
    }
    else {
        titleValue = [NSString stringWithFormat:@"%.0f%%", [self ratioForItemAtIndex:index] * 100];
    }
    descriptionLabel.text = titleValue;

    if ([self ratioForItemAtIndex:index] < self.labelPercentageCutoff) {
        descriptionLabel.text = nil;
    }

    CGPoint center = CGPointMake(_outterCircleRadius + distance * sin(rad),
        _outterCircleRadius - distance * cos(rad));

    descriptionLabel.font = _descriptionTextFont;
    CGSize labelSize = [descriptionLabel.text sizeWithAttributes:@{ NSFontAttributeName : descriptionLabel.font }];
    descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y,
        descriptionLabel.frame.size.width, labelSize.height);
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = _descriptionTextColor;
    descriptionLabel.shadowColor = _descriptionTextShadowColor;
    descriptionLabel.shadowOffset = _descriptionTextShadowOffset;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.center = center;
    descriptionLabel.alpha = 0;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    return descriptionLabel;
}

- (void)recompute
{
}

- (void)updateChartData:(NSArray*)items
{
    self.items = items;
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

    CGFloat percentage = [self findPercentageOfAngleInCircle:circleCenter fromPoint:touchLocation];
    int index = 0;
    while (percentage > [self endPercentageForItemAtIndex:index]) {
        index ++;
    }
    if ([self.delegate respondsToSelector:@selector(userClickedOnPieIndexItem:)]) {
        [self.delegate userClickedOnPieIndexItem:index];
    }
    ChartItemModel *currentItem = [self dataItemForIndex:index];
    CGFloat startPercentage = [self startPercentageForItemAtIndex:index];
    CGFloat endPercentage   = [self endPercentageForItemAtIndex:index];
    self.sectionHightLight= [self newCircleLayerWithRadius:_outterCircleRadius
                                              borderWidth:10
                                                fillColor:[UIColor clearColor]
                                              borderColor:currentItem.color
                                          startPercentage:startPercentage
                                            endPercentage:endPercentage];
    [_contentView.layer addSublayer:self.sectionHightLight];

}

- (CGFloat)findPercentageOfAngleInCircle:(CGPoint)center fromPoint:(CGPoint)reference
{
    //Find angle of line Passing In Reference And Center
    CGFloat angleOfLine = atanf((reference.y - center.y) / (reference.x - center.x));
    CGFloat percentage = (angleOfLine + M_PI / 2) / (2 * M_PI);
    return (reference.x - center.x) > 0 ? percentage : percentage + .5;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:_contentView];
    [self didTouchAt:touchLocation];
}

@end
