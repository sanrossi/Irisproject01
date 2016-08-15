//
//  FetNetMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/6.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "FetNetMainFunctionViewController.h"
#import "MyContactList.h"
@interface FetNetMainFunctionViewController ()<UIWebViewDelegate>
{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *FetNetWebView;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSMutableArray *ContactNamerarray;
@property(nonatomic)NSInteger totalContactsNum;
@property(nonatomic)UITextField *FetNetLogin;
@property(nonatomic)UITextField *FetNetPassword;
@end

@implementation FetNetMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PhoneElementNum=0;
    _FetNetWebView.delegate = self;
    flag = true;
    _FormWhichCompanyList = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
    _ContactNamerarray= [NSMutableArray array];
    //_FetNetWebView.hidden=YES;
    [self loadFetNetWebView];
    [self expoertAddressBook];

}

-(void)loadFetNetWebView{
    //    if(_TWLogin!=nil && _TWPassword!=nil){
    NSURL *url = [NSURL URLWithString:@"http://www.fetnet.net/ecare/eService/web/public/forwardController.do?forwardPage=ucs/queryNetworkType/esqnt01&amp;csType=cs"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.FetNetWebView loadRequest:request];
    
    //    }
}


-(void)expoertAddressBook{
    [[MyContactList sharedContacts] fetchAllContacts];
    //fetch all contacts by calling single to method
    
    if ([[MyContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %ld",[[MyContactList sharedContacts]totalPhoneNumberArray].count);
        _totalContactsNum=[[MyContactList sharedContacts]totalPhoneNumberArray].count;
        NSLog(@"%@", [[MyContactList sharedContacts]totalPhoneNumberArray]);
        
        
        
        
        for(int i=0; i<_totalContactsNum;i++)
            
            
        {self.theFirstPhone=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"phone"];
            
            if(_theFirstPhone[0] == nil ){
                [_TheFirstPhoneNumberArray addObject:@""];
                NSLog(@"test%@",_TheFirstPhoneNumberArray);
            }else{
                
                [_TheFirstPhoneNumberArray addObject:_theFirstPhone[0]];
                NSLog(@"test%@",_TheFirstPhoneNumberArray);
                //check the firstphone
            }
        }
        for(int i=0; i<[[MyContactList sharedContacts]totalPhoneNumberArray].count;i++)
        {
            NSString*Contactname=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"name"];
            
            [_ContactNamerarray addObject:Contactname];
            NSLog(@"testname%@",_ContactNamerarray);
        }
    }
    // }
    [_TheFirstPhoneNumberArray insertObject:@"0999876654" atIndex:0];
    NSLog(@"test%@",_TheFirstPhoneNumberArray);
    //check the firstphone
    
    
}


- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script{
    return nil;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
  

    NSString* FromWhichCompany = [_FetNetWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('font')[0].innerHTML"];
    NSLog(@"遠傳:%@",FromWhichCompany);
    
    
    
    if (PhoneElementNum>=0 && PhoneElementNum<=_totalContactsNum) {
        _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        PhoneElementNum+=1;
       // if(_PhoneNumList.length<=10 && [_PhoneNumList hasPrefix:@"09"]){
            
            
            NSString *script1 = [NSString stringWithFormat:@"document.getElementById('msisdn').value='%@'",_PhoneNumList];
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                
                [_FetNetWebView stringByEvaluatingJavaScriptFromString:script1];
                
                [_FetNetWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('queryButton').click()"];
                
            });
        //}
    
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
