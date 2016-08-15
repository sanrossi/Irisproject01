//
//  TWMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/6.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "TWMainFunctionViewController.h"
#import "MyContactList.h"

@interface TWMainFunctionViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *TWWebView;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSMutableArray *ContactNamerarray;
@property(nonatomic)NSInteger totalContactsNum;
@property(nonatomic)UITextField *TWLogin;
@property(nonatomic)UITextField *TWPassword;
@property(nonatomic)UITextField *TWChkNum;
@property(nonatomic)UIImageView *dyImageView;
@property(nonatomic)NSString *FromWhichCompany;


@end

@implementation TWMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PhoneElementNum=0;
    _TWWebView.delegate = self;
    flag = false;
    _TWWebView.scrollView.delegate = self;
    _FormWhichCompanyList = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
     _ContactNamerarray= [NSMutableArray array];
     WebPageNum =1;
    _FromWhichCompany=@"";
    //_TWWebView.scrollView.scrollEnabled = NO;
    //_TWWebView.hidden=YES;
    
    
    
    
    [self loadTWWebView];
    

    double delayInSeconds = 2;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSData *imageData = [self getImageFromView:_TWWebView];
        //[imageData writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"new.png"] atomically:YES];
        
        
        NSLog(@"%@",imageData);
        NSLog(@"%@",NSHomeDirectory());
        _dyImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0,125,50)];
        
        UIImage *aimage = [UIImage imageWithData: imageData];
        NSLog(@"%f",aimage.size.height);
        NSLog(@"%@",aimage);
        
        CGRect rect = CGRectMake(_TWWebView.bounds.size.width/3-30, _TWWebView.bounds.size.height/2-33, 125, 50);
        CGImageRef imageRef = CGImageCreateWithImageInRect([aimage CGImage], rect);
        UIImage *cutimage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        _dyImageView.image = cutimage;
        NSLog(@"dyImageView height ==> %f", _dyImageView.image.size.height);
        
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
         [_TWWebView addSubview:_dyImageView];
                           
                       });
        
   
    });

    
    
    UIAlertController * alert= [UIAlertController
                                alertControllerWithTitle:@"會員登入"
                                message:@"驗證碼：                  "
                                preferredStyle:UIAlertControllerStyleAlert];
    
   
//    UIImageView *viewe = [[UIImageView alloc] initWithFrame:CGRectMake(60.0, 50.0, 45.0, 45.0)];
//    viewe.image = [UIImage imageNamed:@"button.png"];
    
    
    
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
    [alert.view addSubview:_dyImageView];
    });
    
    
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   NSArray * textfields = alert.textFields;
                                                   _TWLogin = textfields[0];
                                                   _TWPassword = textfields[1];
                                                   _TWChkNum =textfields[2];
                                                   [self inputtheLoginNum];
                                                   [self expoertAddressBook];
                                                   
                                                   
                                               }];
   

    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"台灣大哥大帳號";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密碼";
        textField.secureTextEntry = YES;
    }];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"驗證碼";
        textField.secureTextEntry = YES;
    }];
    
    
   
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    

 

    
    
    // Do any additional setup after loading the view.
}







-(void)loadTWWebView{
//    if(_TWLogin!=nil && _TWPassword!=nil){
        NSURL *url = [NSURL URLWithString:@"https://www.catch.net.tw/auth/member_login_m.jsp?return_url=https%3A%2F%2Fcs.taiwanmobile.com%2Fwap-portal%2FssoLogin.action%3Fparam%3DaHR0cHM6Ly9jcy50YWl3YW5tb2JpbGUuY29tL3dhcC1wb3J0YWwvc21wUXVlcnlUd21QaG9uZU5i%0D%0Aci5hY3Rpb24%3D%0D%0A"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.TWWebView loadRequest:request];
   
//    }
}




- (NSData *)getImageFromView:(UIWebView *)view
{
    NSData *pngImg;
    CGFloat max, scale = 1.0;
    CGSize viewSize = [view bounds].size;
    
    // 获取全屏的Size，包含可见部分和不可见部分(滚动部分)
    CGSize size = [view sizeThatFits:CGSizeZero];
    
    max = (viewSize.width > viewSize.height) ? viewSize.width : viewSize.height;
    if( max > 960 )
    {
        scale = 960/max;
    }
    
    UIGraphicsBeginImageContextWithOptions(size,YES,scale);
    
    // 设置view成全部展开效果
    [view setFrame: CGRectMake(0, 0, size.width, size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    pngImg = UIImagePNGRepresentation( UIGraphicsGetImageFromCurrentImageContext() );
    
    UIGraphicsEndImageContext();
    return pngImg;
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




-(void)inputtheLoginNum{

    NSString *loginaccount = [NSString stringWithFormat:@"document.getElementById('msisdn').value='%@'",_TWLogin.text];
    
    NSString *loginpasswordtxt = [NSString stringWithFormat:@"document.getElementById('passtxt').value='%@'",_TWPassword.text];
        NSString *loginpassword = [NSString stringWithFormat:@"document.getElementById('passwd').value='%@'",_TWPassword.text];
    
    NSString *logincchknum = [NSString stringWithFormat:@"document.getElementById('chkNum').value='%@'",_TWChkNum.text];
    [_TWWebView stringByEvaluatingJavaScriptFromString:loginaccount];
    [_TWWebView stringByEvaluatingJavaScriptFromString:loginpasswordtxt];
    [_TWWebView stringByEvaluatingJavaScriptFromString:loginpassword];
    [_TWWebView stringByEvaluatingJavaScriptFromString:logincchknum];
     flag = true;
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn01')[0].childNodes[0].click()"];
     });
   
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)WebView {
    self.TWWebView.scrollView.contentOffset = CGPointMake(15,473);
    //self.TWWebView.scrollView.bounces = NO;// fix the webview
    if(WebPageNum==1){
        
        WebPageNum += 1;
    
    
    
//    NSString *script2 =[_TWWebView stringByEvaluatingJavaScriptFromString:
//                       @"function(){var img = document.getElementById('randImg');"
//                       "var canvas = document.createElement('canvas');"
//                       "var context = canvas.getContext('2d');"
//                       "canvas.width = img.width;"
//                       "canvas.height = img.height;"
//                       "context.drawImage(img,0,0,img.width,img.height);"
//                        "return canvas.toDataURL('image/png');}"
//                       ];
//    NSLog(@"image%@",script2);
    }
    else if (WebPageNum == 2){
    //[_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
   if([_FromWhichCompany  isEqual:@""]){
    
    _FromWhichCompany = [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('red')[0].innerHTML"];
    NSLog(@"台灣大哥大:%@",_FromWhichCompany);
   }else if(![_FromWhichCompany  isEqual:@""]){
      PhoneElementNum+=1;
       _FromWhichCompany=@"";
     [_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
   }
    
        
      
        
    if (PhoneElementNum>=0 && PhoneElementNum<=_totalContactsNum) {
            _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        
            // if(_PhoneNumList.length<=10 && [_PhoneNumList hasPrefix:@"09"]){
        
        
    NSString *script = [NSString stringWithFormat:@"document.getElementsByName('phoneNbr')[0].value='%@'",_PhoneNumList];
    [_TWWebView stringByEvaluatingJavaScriptFromString:script];
    if(flag){
      
          [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit()"];
        
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
