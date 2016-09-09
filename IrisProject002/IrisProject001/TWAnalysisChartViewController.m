//
//  TWAnalysisChartViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/30.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "TWAnalysisChartViewController.h"
#import "TWMainFunctionViewController.h"
#import "TWLoginDetail.h"
#import "CoreDataHelper.h"
#import "TWNETCount.h"
@interface TWAnalysisChartViewController (){
    BOOL flag1;
    BOOL flag3;
   
    
    
}
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;
@property(nonatomic)NSInteger innerNum;
@property(nonatomic)NSInteger outerNum;
@property(nonatomic)NSInteger localPhoneNum;
@property(nonatomic)NSInteger otherPhoneNum;


@end

@implementation TWAnalysisChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    _fetchArray=[NSMutableArray array];

    self.titleLabel.text = @"網內外資料分析圖";
    self.leftSwitch.hidden = NO;
    //   self.rightSwitch.hidden = NO;
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    flag3=false;
    _detail=[NSArray array];

    NSInteger innerNum1 = [_innerNetCount integerValue];
    NSInteger outerNum1 = [_localPhoneCount  integerValue];
    NSInteger localPhoneNum1 = [_outerNetCount integerValue];
    NSInteger otherPhoneNum1 = [_otherPhoneCount integerValue];
    
    if(innerNum1==0&&outerNum1==0 &&localPhoneNum1==0&&otherPhoneNum1==0){
    
        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
        NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"TWNETCount"];
        NSArray *result = [context executeFetchRequest:request1 error:nil];
         if(result.count !=0){
        TWNETCount *login = (TWNETCount *)result.firstObject;
        _innerNum = [login.innerNetCount integerValue];
        _outerNum = [login.outerNetCount integerValue];
        _localPhoneNum = [login.localPhoneCount integerValue];
        _otherPhoneNum = [login.otherPhoneCount integerValue];
        }
        else{
        _innerNum = 0;
        _outerNum = 0;
        _localPhoneNum = 0;
        _otherPhoneNum = 0;
        }
    
    }else{
         [self shouldSavetheFile:_innerNetCount outterNet:_outerNetCount localphone:_localPhoneCount otherphone:_otherPhoneCount];
        
        if(flag3){
        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
        TWNETCount *login = [NSEntityDescription insertNewObjectForEntityForName:@"TWNETCount" inManagedObjectContext:context];
        login.innerNetCount=_innerNetCount;
        //NSLog(@"innerNetCount:%@",login.innerNetCount);
        login.outerNetCount=_outerNetCount;
        login.localPhoneCount=_localPhoneCount;
        login.otherPhoneCount=_otherPhoneCount;
        
        [context save:nil];
        login.innerNetCount=_innerNetCount;
        //NSLog(@"innerNetCount:%@",login.innerNetCount);
        login.outerNetCount=_outerNetCount;
        login.localPhoneCount=_localPhoneCount;
        login.otherPhoneCount=_otherPhoneCount;
    
        _innerNum = [login.innerNetCount integerValue];
        _outerNum = [login.outerNetCount integerValue];
        _localPhoneNum = [login.localPhoneCount integerValue];
        _otherPhoneNum = [login.otherPhoneCount integerValue];
        }
    
    
    }
    
    
    
    
    
    
    
    
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:_innerNum color:[UIColor colorWithRed:255.0/255.0 green:181.0/255.0 blue:197.0/255.0 alpha:1.0] description:@"網內"],
                       [PNPieChartDataItem dataItemWithValue:_outerNum color:[UIColor colorWithRed:238.0/255.0 green:169.0/255.0 blue:184.0/255.0 alpha:1.0] description:@"網外"],
                       [PNPieChartDataItem dataItemWithValue:_localPhoneNum color:[UIColor colorWithRed:205.0/255.0 green:145.0/255.0 blue:158.0/255.0 alpha:1.0]description:@"市話"],
                       [PNPieChartDataItem dataItemWithValue:_otherPhoneNum color:[UIColor colorWithRed:238.0/255.0 green:162.0/255.0 blue:173.0/255.0 alpha:1.0] description:@"其他"]
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 200, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(130, 480, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:self.pieChart];
    //    self.changeValueButton.hidden = YES;
}








-(void)shouldSavetheFile:(NSNumber*)innerNet outterNet:(NSNumber*)outterNet localphone:(NSNumber*)localphone otherphone:(NSNumber*)otherphone{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"TWNETCount"];
    _detail=[context executeFetchRequest:request error:nil];
    if(_detail.count != 0){
        
        for (TWNETCount *managedObject in _detail) {
            [context deleteObject:managedObject];

        }
        
        flag3=true;
    }else{
        flag3=true;
    
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

- (IBAction)rightSwitchChanged:(id)sender {
    if ([self.titleLabel.text isEqualToString:@"網內外資料分析圖"]){
        UISwitch *showLabels = (UISwitch*) sender;
        if (showLabels.on) {
            self.pieChart.showOnlyValues = NO;
        }else{
            self.pieChart.showOnlyValues = YES;
        }
        [self.pieChart strokeChart];
    }





}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
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
