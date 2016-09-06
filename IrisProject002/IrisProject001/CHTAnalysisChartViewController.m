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

@interface CHTAnalysisChartViewController (){
    BOOL flag3;


}
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;
@property(nonatomic)NSInteger innerNum;
@property(nonatomic)NSInteger outerNum;
@property(nonatomic)NSInteger localPhoneNum;
@property(nonatomic)NSInteger otherPhoneNum;

@end

@implementation CHTAnalysisChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"NETCount"];
        NSArray *result = [context executeFetchRequest:request1 error:nil];
        if(result.count !=0){
            NETCount *login = (NETCount *)result.firstObject;
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
            NETCount *login = [NSEntityDescription insertNewObjectForEntityForName:@"NETCount" inManagedObjectContext:context];
            login.innerNetCount=_innerNetCount;
            NSLog(@"innerNetCount:%@",login.innerNetCount);
            login.outerNetCount=_outerNetCount;
            login.localPhoneCount=_localPhoneCount;
            login.otherPhoneCount=_otherPhoneCount;
            
            [context save:nil];
            login.innerNetCount=_innerNetCount;
            NSLog(@"innerNetCount:%@",login.innerNetCount);
            login.outerNetCount=_outerNetCount;
            login.localPhoneCount=_localPhoneCount;
            login.otherPhoneCount=_otherPhoneCount;
            
            _innerNum = [login.innerNetCount integerValue];
            _outerNum = [login.outerNetCount integerValue];
            _localPhoneNum = [login.localPhoneCount integerValue];
            _otherPhoneNum = [login.otherPhoneCount integerValue];
        }
        
        
    }
   
    
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:_innerNum color:[UIColor colorWithRed:67.0/255.0 green:205.0/255.0 blue:112.0/255.0 alpha:1.0] description:@"網內"],
                       [PNPieChartDataItem dataItemWithValue:_outerNum color:PNLightGreen description:@"網外"],
                       [PNPieChartDataItem dataItemWithValue:_otherPhoneNum color:[UIColor colorWithRed:124.0/255.0 green:205.0/255.0 blue:124.0/255.0 alpha:1.0]description:@"其他"],
                       [PNPieChartDataItem dataItemWithValue:_localPhoneNum color:PNDeepGreen description:@"市話"],
                       
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


-(void)shouldSavetheFile:(NSNumber*)innerNet outterNet:(NSNumber*)outterNet localphone:(NSNumber*)localphone otherphone:(NSNumber*)otherphone{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"NETCount"];
    _detail=[context executeFetchRequest:request error:nil];
    if(_detail.count != 0){

            for (CHTLoginDetail *managedObject in _detail) {
                [context deleteObject:managedObject];
                

        }
        
        flag3=true;
    }
    else{
    
        flag3 =true;
    }

    
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
