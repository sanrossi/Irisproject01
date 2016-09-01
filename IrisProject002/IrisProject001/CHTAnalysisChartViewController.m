//
//  CHTAnalysisChartViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/30.
//  Copyright © 2016年 iris shen. All rights reserved.
//
//#import "CHTLoginDetail+CoreDataProperties.h"
#import "CHTAnalysisChartViewController.h"
#import "CHTMainFunctionViewController.h"
#import "CHTLoginDetail.h"
#import "CoreDataHelper.h"
#import "NETCount.h"

@interface CHTAnalysisChartViewController ()

@end

@implementation CHTAnalysisChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"Pie Chart";
    self.leftSwitch.hidden = NO;
 //   self.rightSwitch.hidden = NO;
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    
    NETCount *login1 = [NSEntityDescription insertNewObjectForEntityForName:@"NETCount" inManagedObjectContext:context];
    CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"CHTLoginDetail" inManagedObjectContext:context];
    NSNumber *myNum = [NSNumber numberWithInteger:_innerNetCount];
    NSNumber *myNum1 = [NSNumber numberWithInteger:_outerNetCount];
    NSNumber *myNum2 = [NSNumber numberWithInteger:_localPhoneCount];
    NSNumber *myNum3 = [NSNumber numberWithInteger:_otherPhoneCount];
    login1.innerNetCount=myNum;
    NSLog(@"innerNetCount:%@",login1.innerNetCount);
    login1.outerNetCount=myNum1;
    login1.localPhoneCount=myNum2;
    login1.otherPhoneCount=myNum3;
    [login addChtLogintonetCountObject:login1];
    [context save:nil];
    
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"NETCount"];
    NSArray *detail=[context executeFetchRequest:request error:nil];
    NSLog(@"%@",detail);
    
   // for(int i=0;i<detail.count;i++){
    NETCount *loginDetail = [detail objectAtIndex:0];
    NSInteger innerNum = [loginDetail.innerNetCount integerValue];
    NSInteger outerNum = [loginDetail.outerNetCount integerValue];
    NSInteger localPhoneNum = [loginDetail.localPhoneCount integerValue];
    NSInteger otherPhoneNum = [loginDetail.otherPhoneCount integerValue];
//        if(loginDetail=nil;
//
//    NSManagedObject *board = boardList[0];
//    [board setValue:newBoardName forKey:@"name"];
//    
//    然後使用 [context save:nil] 即可存進資料庫
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:innerNum color:PNLightGreen description:@"網內"],
                       [PNPieChartDataItem dataItemWithValue:outerNum color:PNFreshGreen description:@"網外"],
                       [PNPieChartDataItem dataItemWithValue:localPhoneNum color:PNDeepGreen description:@"市話"],
                       [PNPieChartDataItem dataItemWithValue:otherPhoneNum color:PNCleanGrey description:@"其他"]
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:self.pieChart];
//    self.changeValueButton.hidden = YES;
    }



- (IBAction)rightSwitchChanged:(id)sender {

    if ([self.titleLabel.text isEqualToString:@"Pie Chart"]){
        UISwitch *showLabels = (UISwitch*) sender;
        if (showLabels.on) {
            self.pieChart.showOnlyValues = NO;
        }else{
            self.pieChart.showOnlyValues = YES;
        }
        [self.pieChart strokeChart];
    }




}
- (IBAction)leftSwitchChanged:(id)sender {


  
        UISwitch *showRelative = (UISwitch*) sender;
        if (showRelative.on) {
            self.pieChart.showAbsoluteValues = NO;
        }else{
            self.pieChart.showAbsoluteValues = YES;
        }
        [self.pieChart strokeChart];
    

}







- (void)didReceiveMemoryWarning {
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
