//
//  CHTMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMainFunctionViewController.h"
#import "MyContactList.h"
#import <QuartzCore/QuartzCore.h>
#import "VMGearLoadingView.h"
@interface CHTMainFunctionViewController ()<UIWebViewDelegate>

{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag1;
   
}


@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSMutableArray *ContactNamerarray;
@property(nonatomic)NSInteger totalContactsNum;
@property(nonatomic)UITextField *CHTLogin;
@property(nonatomic)UITextField *CHTPassword;
@property(nonatomic)UITextField *CHTConfirmcode;
@property(nonatomic)UIImageView *dyImageViewac;

@end

@implementation CHTMainFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_CHTWebView.hidden=NO;
    _CHTWebView.delegate = self;
    WebPageNum =1;
    PhoneElementNum=0;
    flag1 = true;
    
    _FormWhichCompanyList = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
    _ContactNamerarray= [NSMutableArray array];
   
    
    
    UIAlertController * alert= [UIAlertController
                                alertControllerWithTitle:@"會員登入\n"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];
    
  
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   _CHTLogin = alert.textFields.firstObject;
                                                   _CHTPassword = alert.textFields.lastObject;
                                                   [self loadCHTWebView];
                                                   [self expoertAddressBook];
                                                   
                                                   
                                               }];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"emome帳號";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密碼";
        textField.secureTextEntry = YES;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
     [self loadCHTWebView];
   

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



-(void)loadCHTWebView{
    if(_CHTLogin!=nil && _CHTPassword!=nil){
        NSURL *url = [NSURL URLWithString:@"http://auth.emome.net/emome/membersvc/AuthServlet?serviceId=mobilebms&url=qryTelnum.jsp"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.CHTWebView loadRequest:request];
        //load CHT Web page
    }
}



-(void)inputtheLoginNum{
    if((_CHTLogin.text.length==0 || _CHTLogin.text.length != 10)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入帳號"];
        
    }
    else if((_CHTPassword.text.length  == 0)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入密碼"];
        
    }else if(_CHTLogin.text.length!= 0 && _CHTPassword.text.length!= 0){
    WebPageNum+=1;
    NSString *loginaccount = [NSString stringWithFormat:@"document.getElementById('uid').value='%@'",_CHTLogin.text];
    NSString *loginpassword = [NSString stringWithFormat:@"document.getElementById('pw').value='%@'",_CHTPassword.text];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:loginaccount];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:loginpassword];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn-login').click()"];
    //login member
    }
    
}
-(void)inputtheLoginNumWrong{
    if((_CHTLogin.text.length==0 || _CHTLogin.text.length != 10)){
        [self displayUIAlertActionWhenWrongtype:@"提醒" message:@"請輸入帳號"];
    }
    else if((_CHTPassword.text.length  == 0)){
        [self displayUIAlertActionWhenWrongtype:@"提醒" message:@"請輸入密碼"];
        
    }else if((_CHTConfirmcode.text.length  == 0)){
        [self displayUIAlertActionWhenWrongtype:@"提醒" message:@"請輸入密碼"];
        
    }else if(_CHTLogin.text.length  != 0 && _CHTPassword.text.length  != 0 && _CHTConfirmcode.text.length  != 0){
    NSString *loginaccount = [NSString stringWithFormat:@"document.getElementById('uid').value='%@'",_CHTLogin.text];
    NSString *loginpassword = [NSString stringWithFormat:@"document.getElementById('pw').value='%@'",_CHTPassword.text];
    NSString *confirmcode = [NSString stringWithFormat:@"document.getElementById('confirmcode').value='%@'",_CHTConfirmcode.text];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:loginaccount];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:loginpassword];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:confirmcode];
    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn-login').click()"];
    }

}

-(void)displayUIAlertAction:(NSString *)title  message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self viewDidLoad];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)displayUIAlertActionWhenWrongtype:(NSString *)title  message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self CHTWebView];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}












- (void)getImage {
    
    NSString *javascript = @""
    "        var img = document.getElementById(\"img_captcha\"); "
    "        var canvas = document.createElement(\"canvas\");\n"
    "        var context = canvas.getContext(\"2d\");\n"
    "        canvas.width = img.width;\n"
    "        canvas.height = img.height;\n"
    "        context.drawImage(img, 0, 0, img.width, img.height);\n"
    "        canvas.toDataURL(\"image/png\");\n";
    
    NSString*content=[_CHTWebView stringByEvaluatingJavaScriptFromString:javascript];
    NSURL *url = [NSURL URLWithString:content];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage*thumbnail=[self imageCompressWithSimple:image scale:0.7];
    dispatch_async(dispatch_get_main_queue(),^{
        _dyImageViewac = [[UIImageView alloc] initWithFrame: CGRectMake(100,70,image.size.width,image.size.height)];
        _dyImageViewac.image = thumbnail;
           [_CHTWebView addSubview:_dyImageViewac];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    NSString* isdialog = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('loginMsg').innerHTML"];
    if(WebPageNum==1){
        [self inputtheLoginNum];
    }
    else if(isdialog.length>0){
        [self getImage];
        UIAlertController * alert= [UIAlertController
                                    alertControllerWithTitle:@"會員登入\n\n"
                                    message:@"驗證碼:      _________________"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [alert.view addSubview:_dyImageViewac];
                       });
        
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       NSArray * textfields = alert.textFields;
                                                       _CHTLogin = textfields[0];
                                                       _CHTPassword = textfields[1];
                                                       _CHTConfirmcode =textfields[2];
                                                       [self inputtheLoginNumWrong];
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"emome帳號";
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

        
    }
    else if(WebPageNum==2){
        NSString* FromWhichCompany = [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('telnum').parentNode.parentNode.parentNode.rows[1].cells[0].innerHTML"];
        //get the information about the Internal network or external network
        
        if ([FromWhichCompany rangeOfString:@"查無相關資料"].location != NSNotFound) {
            _FromWhichCompanyinfo=@"其他";
        }else if([FromWhichCompany rangeOfString:@"網內"].location != NSNotFound){
            _FromWhichCompanyinfo=@"網內";
        }else if([FromWhichCompany rangeOfString:@"網外"].location != NSNotFound){
            _FromWhichCompanyinfo=@"網外";
        }
        //change the html to 網內外 label
        NSLog(@"login%@",_FromWhichCompanyinfo);
        if(_FromWhichCompanyinfo != NULL){
            [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
            NSLog(@"wenet:%@",_FormWhichCompanyList);
            
        }
        
        if (PhoneElementNum>=0 && PhoneElementNum<=_totalContactsNum) {
            _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
            
            
            
            
            PhoneElementNum+=1;
            if(_PhoneNumList.length<=10 && [_PhoneNumList hasPrefix:@"09"] &&[_PhoneNumList hasPrefix:@"8869"]){
                if([_PhoneNumList hasPrefix:@"8869"]){
                    [_PhoneNumList substringFromIndex:3];
                    _PhoneNumList=[@"0" stringByAppendingString:_PhoneNumList];
                  //去除八八六還沒有測試
                }
        
                
                NSString *script = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'", _PhoneNumList];
                
                [_CHTWebView stringByEvaluatingJavaScriptFromString:script];
                
                
                double delayInSeconds = 1;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn_submit').click()"];
                });
                //delay 1 sencond to click the submit
            }
        
            else{
                if(flag1){
                    _PhoneNumList=@"0999876654";
                    flag1=false;
                }else{
                    _PhoneNumList=@"0998736653";
                    flag1=true;
                }
                NSString *script1 = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'",_PhoneNumList];
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



-(void)distinguishLandline{
    
    [_TheFirstPhoneNumberArray removeObject:_TheFirstPhoneNumberArray[0]];
     //去除掉第一個位元
    for (PhoneElementNum=0 ; PhoneElementNum<_totalContactsNum;PhoneElementNum++) {
    NSString *CheckPhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        if(CheckPhoneNumList){
        }
    
            }

}









- (IBAction)writeToAddressBook:(id)sender {
    
    
    
    [_TheFirstPhoneNumberArray removeObject:_TheFirstPhoneNumberArray[0]];
    NSLog(@"REMOVE:%@",_TheFirstPhoneNumberArray);
    for(int count=1;count<=_totalContactsNum;count++)
    {
        //        //_TheFirstPhoneNumberarray//剃出第一個（後進先出）
        //        //_FormWhichCompanyList//取出網內外（後進先出）
        //        //_ContactNamerarray//去名字（後進先出)
        //_TheFirstPhoneNumberarray[_totalContactsNumber-count-1]
        [[MyContactList sharedContacts]updateContactFromContact:_ContactNamerarray[_totalContactsNum-count] NetLabel:_ContactNamerarray[_totalContactsNum-count] ContactPhone:_TheFirstPhoneNumberArray[_totalContactsNum-count]];
        //測試多按幾次會當掉
        
    }
}





@end
