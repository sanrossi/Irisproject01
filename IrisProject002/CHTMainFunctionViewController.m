//
//  CHTMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMainFunctionViewController.h"
#import "MyContactList.h"

@interface CHTMainFunctionViewController ()<UIWebViewDelegate>

{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag;
    BOOL flag1;
}


@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;
@property(weak,nonatomic)NSMutableArray*thefirstphone;
@property(weak,nonatomic)NSString*phnumlist;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberarray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@end

@implementation CHTMainFunctionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _FormWhichCompanyList = [NSMutableArray array];

    // Do any additional setup after loading the view.
    WebPageNum =1;
    PhoneElementNum=1;
    flag = true;
    flag1 = false;
    _TheFirstPhoneNumberarray = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:@"http://auth.emome.net/emome/membersvc/AuthServlet?serviceId=mobilebms&url=qryTelnum.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.CHTWebView loadRequest:request];
    //load CHT Web page
    
    _CHTWebView.delegate = self;
    //_CHTWebView.hidden=YES;
    //hidden the UIWebview
    
    [[MyContactList sharedContacts] fetchAllContacts];
    //fetch all contacts by calling single to method
   
    if ([[MyContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %ld",[[MyContactList sharedContacts]totalPhoneNumberArray].count);
                NSLog(@"%@", [[MyContactList sharedContacts]totalPhoneNumberArray]);
        
        
        
        for(int i=0; i<[[MyContactList sharedContacts]totalPhoneNumberArray].count;i++)
        {self.thefirstphone=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"phone"];
            
            NSLog(@"%@",_thefirstphone[0]);
            
            [_TheFirstPhoneNumberarray addObject:[NSString stringWithFormat:@"%@",_thefirstphone[0]]];
            NSLog(@"test%@",_TheFirstPhoneNumberarray);
             //check the firstphone
        }
        
        
//        for(int m=0;m<=[[MyContactList sharedContacts]totalPhoneNumberArray].count;m++){
//                            FormWhichCompanyList[m];
//        
//        }
        

    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(WebPageNum==1){
        WebPageNum+=1;
        
        [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('uid').value='0919552512'"];
        [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('pw').value='1222o3o9'"];
        [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn-login').click()"];
        //login member
    }
    else if(WebPageNum==2){
        
        if (PhoneElementNum>=1) {
           
            NSString* FormWhichCompany = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('telnum').parentNode.parentNode.parentNode.rows[1].cells[0].innerHTML"];
            //get the information about the Internal network or external network
         
            if ([FormWhichCompany rangeOfString:@"查無相關資料"].location != NSNotFound) {
            _FromWhichCompanyinfo=@"其他";
            }else if([FormWhichCompany rangeOfString:@"網內"].location != NSNotFound){
            _FromWhichCompanyinfo=@"網內";
            }else if([FormWhichCompany rangeOfString:@"網外"].location != NSNotFound){
            _FromWhichCompanyinfo=@"網外";
            }
            NSLog(@"%@",_FromWhichCompanyinfo);
            if(_FromWhichCompanyinfo != nil){
            [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
            NSLog(@"wenet:%@",_FormWhichCompanyList);
                
            }
            
            
            _phnumlist=_TheFirstPhoneNumberarray[PhoneElementNum-1];
            PhoneElementNum+=1;
            if(_phnumlist.length<=10 && [_phnumlist hasPrefix:@"09"]){
            
                NSString *script = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'", _phnumlist];
               
                [_CHTWebView stringByEvaluatingJavaScriptFromString:script];
                
                
                double delayInSeconds = 1;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn_submit').click()"];
                });
                //delay 1 sencond to click the submit
            }
            else{
                if(flag){
                _phnumlist=@"0999876654";
                    flag=false;
                }else{
                _phnumlist=@"0998736653";
                    flag=true;
                }
                NSString *script1 = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'",_phnumlist];
                [_CHTWebView stringByEvaluatingJavaScriptFromString:script1];
                double delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn_submit').click()"];
                });
                //delay 1 sencond to click the submit
            }
        }
        
    }
}



- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script{
    return nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)writeToAddressBook:(id)sender {
    
    [[MyContactList sharedContacts]updateContactFromContact:@"John"NetLabel:@"網內" ContactPhone:@"0911122233"];
    
    
}

@end
