//
//  CHTAnalysisChartViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/30.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface CHTAnalysisChartViewController : UIViewController<PNChartDelegate>
@property (nonatomic) PNPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (nonatomic) PNRadarChart *radarChart;




@end
