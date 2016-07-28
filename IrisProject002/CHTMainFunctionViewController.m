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
    BOOL flage;
}


@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;
@property(weak,nonatomic)NSMutableArray*thefirstphone;
@property(weak,nonatomic)NSString*phnumlist;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberarray;
@end

@implementation CHTMainFunctionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WebPageNum =1;
    PhoneElementNum=1;
    flage = true;
    _TheFirstPhoneNumberarray = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:@"http://auth.emome.net/emome/membersvc/AuthServlet?serviceId=mobilebms&url=qryTelnum.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.CHTWebView loadRequest:request];
    //load CHT Web page
    
    _CHTWebView.delegate = self;
    _CHTWebView.hidden=YES;
    //hidden the UIWebview
    
    [[ContactList sharedContacts] fetchAllContacts];
    //fetch all contacts by calling single to method
    
    if ([[ContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %ld",[[ContactList sharedContacts]totalPhoneNumberArray].count);
        //        NSLog(@"%@", [[ContactList sharedContacts]totalPhoneNumberArray]);
        
        
        
        for(int i=0; i<[[ContactList sharedContacts]totalPhoneNumberArray].count;i++)
        {self.thefirstphone=[[[ContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"phone"];
            
            NSLog(@"%@",_thefirstphone[0]);
            
            [_TheFirstPhoneNumberarray insertObject:[NSString stringWithFormat:@"%@",_thefirstphone[0]] atIndex:0];
            NSLog(@"test%@",_TheFirstPhoneNumberarray);
            
            //check the firstphone
        }
        
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
            NSString *FormWhichCompany = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('telnum').parentNode.parentNode.parentNode.rows[1].cells[0].innerHTML"];
            NSLog(@"%@",FormWhichCompany);
            //get the information about the Internal network or external network
            

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
                if(flage){
                _phnumlist=@"0999876654";
                    flage=false;
                }else{
                _phnumlist=@"0998736653";
                    flage=true;
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

@end
