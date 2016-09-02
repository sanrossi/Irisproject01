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
@end

@implementation CHTAnalysisChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"網內外資料分析圖";
    self.leftSwitch.hidden = NO;
 //   self.rightSwitch.hidden = NO;
    self.leftLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    
   NETCount *login1 = [NSEntityDescription insertNewObjectForEntityForName:@"NETCount" inManagedObjectContext:context];
    CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"CHTLoginDetail" inManagedObjectContext:context];
    
//-----
//    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"CHTLoginDetail"];
//    
//    NSArray *result = [context executeFetchRequest:request1 error:nil];
//    CHTLoginDetail *login = (CHTLoginDetail *)result.firstObject;
//    //-----
    

    login1.innerNetCount=_innerNetCount;
    NSLog(@"innerNetCount:%@",login1.innerNetCount);
    login1.outerNetCount=_outerNetCount;
    login1.localPhoneCount=_localPhoneCount;
    login1.otherPhoneCount=_otherPhoneCount;
    if(flag3){
        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
        CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"NETCount" inManagedObjectContext:context];
        

    [login addChtLogintonetCountObject:login1];
    [context save:nil];
    }

    NSInteger innerNum = [login1.innerNetCount integerValue];
    NSInteger outerNum = [login1.outerNetCount integerValue];
    NSInteger localPhoneNum = [login1.localPhoneCount integerValue];
    NSInteger otherPhoneNum = [login1.otherPhoneCount integerValue];


    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:innerNum color:PNLightGreen description:@"網內"],
                       [PNPieChartDataItem dataItemWithValue:outerNum color:PNFreshGreen description:@"網外"],
                       [PNPieChartDataItem dataItemWithValue:localPhoneNum color:PNDeepGreen description:@"市話"],
                       [PNPieChartDataItem dataItemWithValue:otherPhoneNum color:PNLightGreen description:@"其他"]
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


-(void)shouldSavetheFile:(NSInteger*)innerNet outterNet:(NSInteger*)outterNet localphone:(NSInteger*)localphone otherphone:(NSInteger*)otherphone{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"NETCount"];
    _detail=[context executeFetchRequest:request error:nil];
    NSPredicate *myPrdicate=[NSPredicate predicateWithFormat:@"innerNetCount == %@ && localPhoneCount == %@ &&otherPhoneCount == %@ &&otherNetCount == %@",innerNet,outterNet,localphone,otherphone];
    [request setPredicate:myPrdicate];
    NSArray *fetchArray=[context executeFetchRequest:request error:nil];
    // 執行fetch request  return 你的搜尋結果在fetcharray中
    
    if(fetchArray.count==0){
        if(_detail.count != 0){
            for (CHTLoginDetail *managedObject in _detail) {
                [context deleteObject:managedObject];
                
            }
        }
        
        flag3=true;
    }else{
        
        flag3=false;
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
