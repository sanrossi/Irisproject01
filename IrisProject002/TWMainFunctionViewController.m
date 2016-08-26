//
//  TWMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/6.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "TWMainFunctionViewController.h"
#import "CHTMainFunctionViewController.h"
#import "MyContactList.h"
#import "VMGearLoadingView.h"
@interface TWMainFunctionViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    
    
}
@property (weak, nonatomic) IBOutlet UIWebView *TWWebView;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSMutableArray *ContactGivenNameArray;
@property(nonatomic)NSMutableArray *ContactFamilyNameArray;
@property(nonatomic)NSInteger totalContactsNum;
@property(nonatomic)UITextField *TWLogin;
@property(nonatomic)UITextField *TWPassword;
@property(nonatomic)UITextField *TWChkNum;
@property(nonatomic)UIImageView *dyImageView;
@property(nonatomic)UIImageView *dyImageViewac;
@property(nonatomic)NSString *FromWhichCompany;


@end

@implementation TWMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PhoneElementNum=0;
    _TWWebView.delegate = self;
    _TWWebView.scrollView.delegate = self;
    _FormWhichCompanyList = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
     _ContactGivenNameArray= [NSMutableArray array];
     WebPageNum =1;
    _FromWhichCompany=@"";
    //_TWWebView.scrollView.scrollEnabled = NO;
    //_TWWebView.hidden=YES;

    [VMGearLoadingView showGearLoadingForView:self.view];
    [self loadTWWebView];

    [VMGearLoadingView hideGearLoadingForView:self.view];

//    double delayInSeconds = 2;
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        NSData *imageData = [self getImageFromView:_TWWebView];
//        //[imageData writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"new.png"] atomically:YES];
//        
//
//        _dyImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0,0,125,50)];
//        
//        UIImage *aimage = [UIImage imageWithData: imageData];
//        
//        CGRect rect = CGRectMake(_TWWebView.bounds.size.width/3-30, _TWWebView.bounds.size.height/2-33, 125, 50);
//        CGImageRef imageRef = CGImageCreateWithImageInRect([aimage CGImage], rect);
//        UIImage *cutimage = [UIImage imageWithCGImage:imageRef];
//        CGImageRelease(imageRef);
//        
//        _dyImageView.image = cutimage;
//        
//        
//        dispatch_async(dispatch_get_main_queue(),
//                       ^{
//         [_TWWebView addSubview:_dyImageView];
//                           
//                       });
//        
//    });
//    // 以上適用全螢幕找到識別碼的方法


    
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
}//獲取全屏的方法




- (void)getImage {
    
    NSString *javascript = @""
    "        var img = document.getElementById(\"randImg\"); "
    "        var canvas = document.createElement(\"canvas\");\n"
    "        var context = canvas.getContext(\"2d\");\n"
    "        canvas.width = img.width;\n"
    "        canvas.height = img.height;\n"
    "        context.drawImage(img, 0, 0, img.width, img.height);\n"
    "        canvas.toDataURL(\"image/png\");\n";
    
    NSString*content=[_TWWebView stringByEvaluatingJavaScriptFromString:javascript];
    NSURL *url = [NSURL URLWithString:content];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *thumbnail=[self imageCompressWithSimple:image scale:0.95];
    dispatch_async(dispatch_get_main_queue(),^{
    _dyImageViewac = [[UIImageView alloc] initWithFrame: CGRectMake(110,60,image.size.width,image.size.height)];
    _dyImageViewac.image = thumbnail;
     //   [_TWWebView addSubview:_dyImageViewac];
    });
    //check image with height and width
    NSLog(@"width %f,height %f",image.size.width,image.size.height);
    
    
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scale:(float)scale
{
    CGSize size = image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    //we can make the thumbnail for the confirm image.
}





- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script{
    return nil;
}



-(void)exportAddressBook{
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
            NSString*ContactGivenname=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"givenname"];
            if(ContactGivenname==nil){
                [_ContactGivenNameArray addObject:@""];
            }else{
                [_ContactGivenNameArray addObject:ContactGivenname];
            }
            NSLog(@"givenname%@",_ContactGivenNameArray);
            
            NSString*ContactFamilynname=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"familyName"];
            if(ContactFamilynname==nil){
                [_ContactFamilyNameArray addObject:@""];
            }
            else{
                [_ContactFamilyNameArray addObject:ContactFamilynname];
            }
            NSLog(@"familyName%@",_ContactFamilyNameArray);
        }
    }
    
    // }
    [_TheFirstPhoneNumberArray insertObject:@"0999876654" atIndex:0];
    NSLog(@"test%@",_TheFirstPhoneNumberArray);
    //check the firstphone
    
}
//如果非台灣帳號https://www.catch.net.tw/auth/loginMessage_m.jsp這個判別還沒寫

-(void)inputtheLoginNum{

    if((_TWLogin.text.length==0 || _TWLogin.text.length != 10)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入帳號"];
        
    }
    else if((_TWPassword.text.length  == 0)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入密碼"];
        
    }else if((_TWChkNum.text.length == 0)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入驗證碼"];
        
    }else if(_TWLogin.text.length!= 0 && _TWPassword.text.length!= 0 &&_TWChkNum.text.length!= 0){
        NSString *loginaccount = [NSString stringWithFormat:@"document.getElementById('msisdn').value='%@'",_TWLogin.text];
        
        NSString *loginpasswordtxt = [NSString stringWithFormat:@"document.getElementById('passtxt').value='%@'",_TWPassword.text];
        NSString *loginpassword = [NSString stringWithFormat:@"document.getElementById('passwd').value='%@'",_TWPassword.text];
        
        NSString *logincchknum = [NSString stringWithFormat:@"document.getElementById('chkNum').value='%@'",_TWChkNum.text];
        [_TWWebView stringByEvaluatingJavaScriptFromString:loginaccount];
        [_TWWebView stringByEvaluatingJavaScriptFromString:loginpasswordtxt];
        [_TWWebView stringByEvaluatingJavaScriptFromString:loginpassword];
        [_TWWebView stringByEvaluatingJavaScriptFromString:logincchknum];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn01')[0].childNodes[0].click()"];
        });
    }
    
}




-(void)displayUIAlertAction:(NSString *)title  message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self loadTWWebView];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];


}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)WebView {
    self.TWWebView.scrollView.contentOffset = CGPointMake(15,473);
    //self.TWWebView.scrollView.bounces = NO;// fix the webview
    

    
    if([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://www.catch.net.tw/auth/member_login_m.jsp?return_url=https%3A%2F%2Fcs.taiwanmobile.com%2Fwap-portal%2FssoLogin.action%3Fparam%3DaHR0cHM6Ly9jcy50YWl3YW5tb2JpbGUuY29tL3dhcC1wb3J0YWwvc21wUXVlcnlUd21QaG9uZU5i%0D%0Aci5hY3Rpb24%3D%0D%0A"] || [[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://www.catch.net.tw/auth/member_login_m.jsp"])
        //if url is not the url of the iframe then transfer to iframe's url
    {
        if([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://www.catch.net.tw/auth/member_login_m.jsp"]){
            [self loadTWWebView];
        }
        double delayInSeconds = 1;
        //delay one second for getting the image
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            [self getImage];
            
            UIAlertController * alert= [UIAlertController
                                        alertControllerWithTitle:@"會員登入\n"
                                        message:@"驗證碼:   ＿＿＿＿＿＿＿＿"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [alert.view addSubview:_dyImageViewac];
                           });
            
            
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSArray * textfields = alert.textFields;
                                                           _TWLogin = textfields[0];
                                                           _TWPassword = textfields[1];
                                                           _TWChkNum =textfields[2];
                                                           [self inputtheLoginNum];
                                                           [self exportAddressBook];
                                                           
                                                           
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
            
        });
        
        
        
    }
    
    else if ([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://cs.taiwanmobile.com/wap-portal/smpQueryTwmPhoneNbr.action"]){
        switchLabel:
        _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        //正則化
        NSString *letters = @"0123456789";
        NSCharacterSet *notLetters = [[NSCharacterSet characterSetWithCharactersInString:letters] invertedSet];
        _PhoneNumList = [[_PhoneNumList componentsSeparatedByCharactersInSet:notLetters] componentsJoinedByString:@""];
        NSLog(@"newString: %@", _PhoneNumList);
        //正則化

        if (PhoneElementNum>=0 && PhoneElementNum<=_totalContactsNum) {

            if((_PhoneNumList.length==10 && [_PhoneNumList hasPrefix:@"09"]) || ([_PhoneNumList hasPrefix:@"8869"] && _PhoneNumList.length==12)){
                if([_PhoneNumList hasPrefix:@"8869"]){
                    _PhoneNumList = [_PhoneNumList substringWithRange:NSMakeRange(3,9)];
                    
                    NSLog(@"去除886%@",_PhoneNumList);
                    
                    _PhoneNumList=[NSString stringWithFormat:@"0%@",_PhoneNumList];
                    //去除八八六還沒有測試
                    NSLog(@"加0%@",_PhoneNumList);
                }
            if(_TWWebView.loading==NO){
                NSString *script = [NSString stringWithFormat:@"document.getElementsByName('phoneNbr')[0].value='%@'",_PhoneNumList];
                [_TWWebView stringByEvaluatingJavaScriptFromString:script];
                
                [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit()"];
              }
            }
        }
        else if(_PhoneNumList ==nil){
            
        //改這裡
        }
    }
    else if ([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://cs.taiwanmobile.com/wap-portal/smpCheckTwmPhoneNbr.action"]){
        if([_FromWhichCompany  isEqual:@""]){
            if(_TWWebView.loading==NO){
                _FromWhichCompany = [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('red')[0].innerHTML"];
                
                if([_FromWhichCompany  isEqual:@""]){
                    _FromWhichCompany = [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('font')[0].innerHTML"];
                }
                
                NSLog(@"didFinish: %@; stillLoading: %@", [[_TWWebView request]URL],
                      (_TWWebView.loading?@"YES":@"NO"));
                NSLog(@"台灣大哥大:%@",_FromWhichCompany);
                
                
                //get the information about the Internal network or external network
                
                if ([_FromWhichCompany isEqualToString:@"請輸入正確的手機號碼"]) {
                    _FromWhichCompanyinfo=@"其他";
                }else if([_FromWhichCompany isEqualToString:@"台灣大哥大門號"]){
                    _FromWhichCompanyinfo=@"網內";
                }else if([_FromWhichCompany isEqualToString:@"非台灣大哥大門號"]){
                    _FromWhichCompanyinfo=@"網外";
                }
                //change the html to 網內外 label
                NSLog(@"login%@",_FromWhichCompanyinfo);
                if(_FromWhichCompanyinfo != NULL){
                [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
                NSLog(@"wenet:%@",_FormWhichCompanyList);
                    
                }


                
                [_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
            }
        }else if(![_FromWhichCompany  isEqual:@""]){
            PhoneElementNum+=1;
            _FromWhichCompany=@"";
            [_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
        }
  
        
    }
    

}

- (IBAction)writeToAddressBook:(id)sender {
    NSLog(@"count%ld",_FormWhichCompanyList.count);

    [_TheFirstPhoneNumberArray removeObject:_TheFirstPhoneNumberArray[0]];
    NSLog(@"REMOVE:%@",_TheFirstPhoneNumberArray);
    for(int count=1;count<=_totalContactsNum;count++)
    {
        //        //_TheFirstPhoneNumberarray//剃出第一個（後進先出）
        //        //_FormWhichCompanyList//取出網內外（後進先出）
        //        //_ContactNamerarray//去名字（後進先出)
        //_TheFirstPhoneNumberarray[_totalContactsNumber-count-1]
        [[MyContactList sharedContacts]updateContactFromContact:_ContactGivenNameArray[_totalContactsNum-count] NetLabel:_ContactGivenNameArray[_totalContactsNum-count] ContactPhone:_TheFirstPhoneNumberArray[_totalContactsNum-count]];
        //測試多按幾次會當掉
        
    }
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
