//
//  BaseCollecionViewCell.m
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "BaseCollecionViewCell.h"

@implementation BaseCollecionViewCell
+ (NSString*)cellIdentifer{
    return NSStringFromClass([self class]);
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end
