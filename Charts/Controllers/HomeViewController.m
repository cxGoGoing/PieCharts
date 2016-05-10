//
//  HomeViewController.m
//  Charts
//
//  Created by chengxun on 16/5/5.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "HomeViewController.h"
#import "PieChartView.h"
#import "ColorUtil.h"
#import "ChartItemModel.h"
#import <PureLayout.h>
#import <BlocksKit+UIKit.h>
@interface HomeViewController () <ChartViewDelegate>
@property (nonatomic, strong) PieChartView* pieChart;
@property (nonatomic, strong) UIButton* reloadBtn;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogInfo(@"!!!!!!!!!!!!!!");
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray* items = @[
        [ChartItemModel dataItemWithValue:10 color:[ColorUtil pieBlueColor]],
        [ChartItemModel dataItemWithValue:10 color:[ColorUtil pieRedColor]],
        [ChartItemModel dataItemWithValue:10 color:[ColorUtil pieYellowColor]],
        [ChartItemModel dataItemWithValue:10 color:[ColorUtil pieGreenColor]],
        [ChartItemModel dataItemWithValue:10
                                    color:[ColorUtil pieDeepBlueColor]]
    ];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    PieChartView* pieChart = [[PieChartView alloc] initWithFrame:CGRectMake(width / 2.0 - 100, 100, 200.0, 280.0) items:items];
    //pieChart.labelPercentageCutoff = 5.f;
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.delegate = self;
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    self.pieChart = pieChart;

    [self.reloadBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
    [self.reloadBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];

    // Do any additional setup after loading the view.
}

- (UIButton*)reloadBtn
{
    if (!_reloadBtn) {
        _reloadBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_reloadBtn bk_addEventHandler:^(id sender) {
            NSArray* items = @[
                               [ChartItemModel dataItemWithValue:10 color:[ColorUtil pieBlueColor]],
                               [ChartItemModel dataItemWithValue:20 color:[ColorUtil pieRedColor]],
                               [ChartItemModel dataItemWithValue:30 color:[ColorUtil pieYellowColor]],
                               [ChartItemModel dataItemWithValue:25 color:[ColorUtil pieGreenColor]],
                               [ChartItemModel dataItemWithValue:5
                                                           color:[ColorUtil pieDeepBlueColor]],
                               [ChartItemModel dataItemWithValue:10
                                                           color:[ColorUtil pieCyanColor]]
                               ];
            [self.pieChart updateChartData:items];
            [self.pieChart strokeChart];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_reloadBtn];
    }
    return _reloadBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
