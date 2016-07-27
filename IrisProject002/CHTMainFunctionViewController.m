//
//  CHTMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMainFunctionViewController.h"

@interface CHTMainFunctionViewController ()<UIWebViewDelegate>

{
    NSInteger pagenumber;
    NSInteger i;
    BOOL flag1 ;
}

@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;

@end

@implementation CHTMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pagenumber =1;
    flag1=true;
    i=1;
    NSURL *url = [NSURL URLWithString:@"http://auth.emome.net/emome/membersvc/AuthServlet?serviceId=mobilebms&url=qryTelnum.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.CHTWebView loadRequest:request];
    _CHTWebView.delegate = self;
    //_webView.hidden=YES;隱藏web view視窗
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    if(pagenumber==1){
        pagenumber+=1;
        
        [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('uid').value='0919552512'"];
        [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('pw').value='1222o3o9'"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.CHTWebView.scrollView.contentOffset = CGPointMake(50, 100);
        });
    }
    else if(pagenumber==2){
        
        if (i>=1) {
            NSString *formwhichcpy = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('telnum').parentNode.parentNode.parentNode.rows[1].cells[0].innerHTML"];
            NSLog(@"%@",formwhichcpy);
            
            NSArray *phonenumeber=@[@"0919552512",@"0912912192",@"0932642551",@"0913145161"];
            
            
            NSString*phnumlist=phonenumeber[i-1];
            i+=1;
            NSString *script1 = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'", phnumlist];
            [_CHTWebView stringByEvaluatingJavaScriptFromString:script1];
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
