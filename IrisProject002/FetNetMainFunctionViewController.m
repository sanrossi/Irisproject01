//
//  FetNetMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/6.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "FetNetMainFunctionViewController.h"
#import "FetNetAnalysisChartViewController.h"
#import "MyContactList.h"
#import "FetNetLoginDetail.h"
#import "VMGearLoadingView.h"
@interface FetNetMainFunctionViewController ()<UIWebViewDelegate>
{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag1;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *FetNetWebView;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSMutableArray *ContactGivenNameArray;
@property(nonatomic)NSMutableArray *ContactFamilyNameArray;
@property(nonatomic)NSInteger totalContactsNum;
@property(nonatomic)UITextField *FetNetLogin;
@property(nonatomic)UITextField *FetNetPassword;
@property(nonatomic)NSString *FromWhichCompany;
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;
@property(nonatomic)NSMutableArray *innerNet;
@property(nonatomic)NSMutableArray *outerNet;
@property(nonatomic)NSMutableArray *localphone;
@property(nonatomic)NSMutableArray *otherphone;
@property(nonatomic)NSMutableArray *loginaccount;
@property(nonatomic)NSMutableArray *loginpassword;



@end

@implementation FetNetMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PhoneElementNum=0;
    _FetNetWebView.delegate = self;
    flag1 = true;
    _FormWhichCompanyList = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
    _ContactGivenNameArray= [NSMutableArray array];
    _ContactFamilyNameArray= [NSMutableArray array];
    _innerNet= [NSMutableArray array];
    _outerNet= [NSMutableArray array];
    _localphone= [NSMutableArray array];
    _otherphone= [NSMutableArray array];
    _loginaccount=[NSMutableArray array];
    _loginpassword=[NSMutableArray array];
    _fetchArray=[NSMutableArray array];
    _detail=[NSArray array];
  
    //_FetNetWebView.hidden=YES;
    [self loadFetNetWebView];
    [[MyContactList sharedContacts] exportAddressBook];
    _totalContactsNum=[[MyContactList sharedContacts]totalContactsNum];
    _theFirstPhone=[[MyContactList sharedContacts]theFirstPhone];
    _TheFirstPhoneNumberArray=[[MyContactList sharedContacts]TheFirstPhoneNumberArray];
    _ContactFamilyNameArray =[[MyContactList sharedContacts]ContactFamilyNameArray];
    _ContactGivenNameArray =[[MyContactList sharedContacts]ContactGivenNameArray];
    NSLog(@"ttttttt%@",_TheFirstPhoneNumberArray);
  

}

-(void)loadFetNetWebView{
    //    if(_TWLogin!=nil && _TWPassword!=nil){
    NSURL *url = [NSURL URLWithString:@"http://www.fetnet.net/ecare/eService/web/public/forwardController.do?forwardPage=ucs/queryNetworkType/esqnt01&amp;csType=cs"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.FetNetWebView loadRequest:request];
    
    //    }
}





- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script{
    return nil;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    
    if([_PhoneNumList isEqual:@"0999876654"]||[_PhoneNumList isEqual:@"0998736653"]){
        _FromWhichCompany = @"非行動電話號碼";
    }else{
     _FromWhichCompany = [_FetNetWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('font')[0].innerHTML"];
    
    }

   
         NSLog(@"遠傳:%@",_FromWhichCompany);
    
    if ([_FromWhichCompany rangeOfString:@"非行動電話號碼"].location != NSNotFound) {
        _FromWhichCompanyinfo=@"其他";
    }else if([_FromWhichCompany rangeOfString:@"網內"].location != NSNotFound){
        _FromWhichCompanyinfo=@"網內";
    }else if([_FromWhichCompany rangeOfString:@"網外"].location != NSNotFound){
        _FromWhichCompanyinfo=@"網外";
    }
    //change the html to 網內外 label
    NSLog(@"login%@",_FromWhichCompanyinfo);
    if(_FromWhichCompanyinfo != NULL){
        [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
        NSLog(@"wenet:%@",_FormWhichCompanyList);
        
    }
    if(PhoneElementNum == 0){
        [VMGearLoadingView showGearLoadingForView:self.view];
    }
    
    
    if(PhoneElementNum == _totalContactsNum){
        [VMGearLoadingView hideGearLoadingForView:self.view];
    }
    
    if (PhoneElementNum>=0 && PhoneElementNum<_totalContactsNum) {
        _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        //正則化
        NSString *letters = @"0123456789";
        NSCharacterSet *notLetters = [[NSCharacterSet characterSetWithCharactersInString:letters] invertedSet];
        _PhoneNumList = [[_PhoneNumList componentsSeparatedByCharactersInSet:notLetters] componentsJoinedByString:@""];
        NSLog(@"newString: %@", _PhoneNumList);
        //正則化
        PhoneElementNum+=1;
       if((_PhoneNumList.length==10 && [_PhoneNumList hasPrefix:@"09"]) || ([_PhoneNumList hasPrefix:@"8869"] && _PhoneNumList.length==12)){
           
           
           if([_PhoneNumList hasPrefix:@"8869"]){
               _PhoneNumList = [_PhoneNumList substringWithRange:NSMakeRange(3,9)];
               
               NSLog(@"去除886%@",_PhoneNumList);
               
               _PhoneNumList=[NSString stringWithFormat:@"0%@",_PhoneNumList];
               //去除八八六還沒有測試
               NSLog(@"加0%@",_PhoneNumList);
           }

           
           
            NSString *script1 = [NSString stringWithFormat:@"document.getElementById('msisdn').value='%@'",_PhoneNumList];
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                
                [_FetNetWebView stringByEvaluatingJavaScriptFromString:script1];
            if(_FetNetWebView.loading==NO){
                [_FetNetWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('queryButton').click()"];
            }

            });
        }
     
       else{
           if(flag1){
               _PhoneNumList=@"0999876654";
               flag1=false;
           }else{
               _PhoneNumList=@"0998736653";
               flag1=true;
           }
           NSString *script = [NSString stringWithFormat:@"document.getElementById('msisdn').value='%@'",_PhoneNumList];
           [_FetNetWebView stringByEvaluatingJavaScriptFromString:script];
           if(_FetNetWebView.loading==NO){
           [_FetNetWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('queryButton').click()"];
           }
           
           //改這裡
           
       }

    
    }
}


-(void)distinguishLandline{

    for (PhoneElementNum=0 ; PhoneElementNum<_totalContactsNum;PhoneElementNum++) {
        NSString *CheckPhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        //正則化
        NSString *letters = @"0123456789";
        NSCharacterSet *notLetters = [[NSCharacterSet characterSetWithCharactersInString:letters] invertedSet];
        CheckPhoneNumList= [[CheckPhoneNumList componentsSeparatedByCharactersInSet:notLetters] componentsJoinedByString:@""];
        NSLog(@"newString: %@", CheckPhoneNumList);
        //正則化
        
        NSArray *twRegionCod =[ [ NSArray alloc ] initWithObjects:@"02",@"03",@"037",@"04",@"049",@"05",@"06",@"07",@"089",@"082",@"0826",@"0836",@"8862",@"8863",@"88637",@"8864",@"88649",@"8865",@"8866",@"8867",@"88989",@"88682",@"886826",@"886836", nil];
        
        for(int twRegionCodElement=0;twRegionCodElement<twRegionCod.count;twRegionCodElement++){
            NSString * stringFromtwRegionCod = [twRegionCod objectAtIndex:twRegionCodElement];
            if ([CheckPhoneNumList hasPrefix:stringFromtwRegionCod]) {
                _FormWhichCompanyList[PhoneElementNum]=@"市話";
                
            }
            NSLog(@"市話%@",_FormWhichCompanyList);
        }
    }
    
}



- (IBAction)writeToAddressBook:(id)sender {

    [self distinguishLandline];
    //[_FormWhichCompanyList removeObject:_FormWhichCompanyList[0]];
    NSLog(@"count%ld",_FormWhichCompanyList.count);
    if(_FormWhichCompanyList.count==_TheFirstPhoneNumberArray.count){
    for(int count=0;count<_totalContactsNum;count++)
    {
        //        //_TheFirstPhoneNumberarray//剃出第一個（後進先出）
        //        //_FormWhichCompanyList//取出網內外（後進先出）
        //        //_ContactGivenNameArray//去名字（後進先出)
        //_TheFirstPhoneNumberarray[_totalContactsNumber-count-1]
        
        
        if(_TheFirstPhoneNumberArray[count]==nil){
            _TheFirstPhoneNumberArray[count]=@""; }
        
        if([_ContactGivenNameArray[count] isEqual:@""]){
            [[MyContactList sharedContacts]updateContactFromContact:_ContactFamilyNameArray[count] NetLabel:_FormWhichCompanyList[count] ContactPhone:_TheFirstPhoneNumberArray[count]];}
        
        else{
            [[MyContactList sharedContacts]updateContactFromContact:_ContactGivenNameArray[count] NetLabel:_FormWhichCompanyList[count] ContactPhone:_TheFirstPhoneNumberArray[count]];
        }
        [self calculateNumbersOfInternalNetwork];
        [self displayUIAlertAction1:@"恭喜完成寫入" message:@"趕快查看您的通訊錄唷!!"];
        
        //測試多按幾次會當掉
        //改過了
    }
    }
else{
    [self calculateNumbersOfInternalNetwork];
    [self displayUIAlertAction1:@"請檢查網路狀態" message:@"請改wifi連線!!"];
}
        
        
}


-(void)displayUIAlertAction1:(NSString *)title  message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



-(void)calculateNumbersOfInternalNetwork{
    for(int count=0;count<_FormWhichCompanyList.count;count++){
        NSString *NetNameData= _FormWhichCompanyList[count];
        
        NSData *unicodedStringData =
        [NetNameData dataUsingEncoding:NSUTF8StringEncoding];
        NSString *Netname =
        [[NSString alloc] initWithData:unicodedStringData encoding:NSUTF8StringEncoding];
        NSLog(@"netname:%@",Netname);
        
        if([Netname isEqualToString:@"網內" ]){
            [_innerNet addObject:Netname];
        }else if([Netname isEqualToString:@"網外"]){
            [_outerNet addObject:Netname];
        }else if([Netname isEqualToString:@"市話"]){
            [_localphone addObject:Netname];
        }else if([Netname isEqualToString:@"其他"]){
            [_otherphone addObject:Netname];
        }
        
        
        NSLog(@"網內%ld",_innerNet.count);
        NSLog(@"網外%ld",_outerNet.count);
        NSLog(@"市話%ld",_localphone.count);
        NSLog(@"其他%ld",_otherphone.count);
        
    }
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"FetNetPieChart"])
    {   FetNetAnalysisChartViewController *fetnetAnalysisChartViewController =segue.destinationViewController;
        NSNumber *myNum = @(_innerNet.count);
        NSNumber *myNum1 = @(_outerNet.count);
        NSNumber *myNum2 = @(_localphone.count);
        NSNumber *myNum3 = @(_otherphone.count);
        
        fetnetAnalysisChartViewController.innerNetCount=myNum;
        fetnetAnalysisChartViewController.outerNetCount=myNum1;
        fetnetAnalysisChartViewController.localPhoneCount=myNum2;
        fetnetAnalysisChartViewController.otherPhoneCount=myNum3;
        
        NSLog(@"\n _innerNet.count: %ld, \n _outerNet.count: %ld, \n _localphone.count: %ld, \n _otherphone.count: %ld", _innerNet.count, _outerNet.count, _localphone.count, _otherphone.count);
        
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
