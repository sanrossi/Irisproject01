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
    NSInteger ArrayNum;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;

@end

@implementation CHTMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WebPageNum =1;
    ArrayNum=1;
    NSURL *url = [NSURL URLWithString:@"http://auth.emome.net/emome/membersvc/AuthServlet?serviceId=mobilebms&url=qryTelnum.jsp"];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     [self.CHTWebView loadRequest:request];
     _CHTWebView.delegate = self;
     _CHTWebView.hidden=YES;
    
    [[ContactList sharedContacts] fetchAllContacts]; //fetch all contacts by calling single to method
    
    if ([[ContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %ld",[[ContactList sharedContacts]totalPhoneNumberArray].count);
        NSLog(@"姓名：%@ ", [[ContactList sharedContacts]totalPhoneNumberArray]);
        //        for(int i=0; i<[[ContactList sharedContacts]totalPhoneNumberArray].count;i++)
        //        {NSLog(@"電話：%@ ",[[[ContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"phone"]);
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
    }
    else if(WebPageNum==2){
        
        if (ArrayNum>=1) {
            NSString *formwhichcpy = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('telnum').parentNode.parentNode.parentNode.rows[1].cells[0].innerHTML"];
            NSLog(@"%@",formwhichcpy);
            NSArray *phonenumeber=@[@"0",@"0919552512",@"0912912192",@"0932642551",@"0913145161"];
            
            NSString*phnumlist=phonenumeber[ArrayNum-1];
            NSString *script = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'", phnumlist];
            ArrayNum+=1;
            [_CHTWebView stringByEvaluatingJavaScriptFromString:script];
            [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn_submit').click()"];
            
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
