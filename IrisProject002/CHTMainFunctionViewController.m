//
//  CHTMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMainFunctionViewController.h"
#import "CHTAnalysisChartViewController.h"
#import "MyContactList.h"
#import <QuartzCore/QuartzCore.h>
#import "VMGearLoadingView.h"
#import "CHTLoginDetail.h"
#import "CoreDataHelper.h"


@interface CHTMainFunctionViewController ()<UIWebViewDelegate>

{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag1;
    BOOL flag2;
    BOOL flag3;
}


@property (weak, nonatomic) IBOutlet UIWebView *CHTWebView;
@property(nonatomic)UITextField *CHTLogin;
@property(nonatomic)UITextField *CHTPassword;
@property(nonatomic)UITextField *CHTConfirmcode;
@property(nonatomic)UIImageView *dyImageViewac;
@property(nonatomic)NSMutableArray *innerNet;
@property(nonatomic)NSMutableArray *outerNet;
@property(nonatomic)NSMutableArray *localphone;
@property(nonatomic)NSMutableArray *otherphone;
@property(nonatomic)NSMutableArray *loginaccount;
@property(nonatomic)NSMutableArray *loginpassword;
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;

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
    flag2 = true;
    
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
    flag3=false;
    

    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
   
   
    
    
    

    UIAlertController * alert= [UIAlertController
                                alertControllerWithTitle:@"會員登入\n"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];
    

  
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   _CHTLogin = alert.textFields.firstObject;
                                                    _CHTPassword = alert.textFields.lastObject;
                                                   NSLog(@"%@",context);
                                                   [self shouldSavetheFile:_CHTLogin.text chtPassword:_CHTPassword.text];
                                                 
                                                   if(flag3){
                                                        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
                                                           CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"CHTLoginDetail" inManagedObjectContext:context];
                                                       
                                                       
                                                       login.chtLogin=_CHTLogin.text;
                                                       NSLog(@"%@",login.chtLogin);
                                                       login.chtPassword=_CHTPassword.text;
                                                         if(login.chtLogin.length !=0 &&login.chtPassword.length !=0){
                                                       [context save:nil];
                                                       }
                                                   };
                                                
                                               
                                                   
                                                   [self loadCHTWebView];
                                                   [[MyContactList sharedContacts] exportAddressBook];
                                                   _totalContactsNum=[[MyContactList sharedContacts]totalContactsNum];
                                                   _theFirstPhone=[[MyContactList sharedContacts]theFirstPhone];
                                                   _TheFirstPhoneNumberArray=[[MyContactList sharedContacts]TheFirstPhoneNumberArray];
                                                   _ContactFamilyNameArray =[[MyContactList sharedContacts]ContactFamilyNameArray];
                                                   _ContactGivenNameArray =[[MyContactList sharedContacts]ContactGivenNameArray];
                                                   [VMGearLoadingView showGearLoadingForView:self.view];
                                                   // }
                                                   [_TheFirstPhoneNumberArray insertObject:@"0999876654" atIndex:0];
                                                   NSLog(@"test%@",_TheFirstPhoneNumberArray);
                                                   //check the firstphone
                                                   
                                                   
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
    
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
    
    NSArray *detail=[context executeFetchRequest:request error:nil];
    NSLog(@"%@",detail);
    NSPredicate *myPrdicate=[NSPredicate predicateWithFormat:@"chtLogin == %@ && chtPassword = %@ ",nil,nil];
 
    [request setPredicate:myPrdicate];
    _fetchArray=[context executeFetchRequest:request error:nil];
     NSLog(@"fetchArray%@",_fetchArray);
    // 執行fetch request  return 你的搜尋結果在fetcharray中
    
    if(_fetchArray.count==0){
        CHTLoginDetail *loginDetail = [detail objectAtIndex:0];
        NSLog(@">>>>>>>>>>%@",loginDetail);
        
        alert.textFields[0].text= loginDetail.chtLogin;
        alert.textFields[1].text=loginDetail.chtPassword;
        
    }else{
        
            for (CHTLoginDetail *managedObject1 in _fetchArray) {
                [context deleteObject:managedObject1];
                //                [context deletedObjects];
            }
        
    
            CHTLoginDetail *loginDetail = [detail objectAtIndex:0];
            alert.textFields[0].text= loginDetail.chtLogin;
            NSLog(@"CHTLogin:%@",alert.textFields[0].text);
            alert.textFields[1].text=loginDetail.chtPassword;

    }

    
    
    
    
    
    
    
    
    
    

}

-(void)shouldSavetheFile:(NSString*)chtLoginName chtPassword:(NSString*)chtpassword{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
    _detail=[context executeFetchRequest:request error:nil];
        NSPredicate *myPrdicate=[NSPredicate predicateWithFormat:@"chtLogin == %@ && chtPassword = %@ ",chtLoginName,chtpassword];
        [request setPredicate:myPrdicate];
    NSArray *fetchArray=[context executeFetchRequest:request error:nil];
    // 執行fetch request  return 你的搜尋結果在fetcharray中
    
    if(fetchArray.count==0){
        if(_detail.count != 0){
            for (CHTLoginDetail *managedObject in _detail) {
                [context deleteObject:managedObject];
//                [context deletedObjects];
            }
        }
        
        flag3=true;
    }else{
        
        flag3=false;
                }
    
}






//-(BOOL)shouldSavetheFile:(NSString*)chtLoginName chtPassword:(NSString*)chtpassword{
//    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
//    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
//    NSArray *detail=[context executeFetchRequest:request error:nil];
//        for(int i=0;i<detail.count;i++){
//        CHTLoginDetail *loginDetail = [detail objectAtIndex:i];
//            if(loginDetail.chtLogin.length !=0 &&loginDetail.chtPassword.length !=0){
//            [_loginaccount addObject:loginDetail.chtLogin];
//            [_loginpassword addObject:loginDetail.chtPassword];
//            NSLog(@"cht%@",loginDetail.chtLogin);
//            }
//        }
//    for(chtLoginName in _loginaccount){
//        for(chtpassword in _loginpassword){
//            return true;
//        }
//    }
//    return false;
//}




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
    }else{
     //0++++++++++++++++++++++++++++++++++++++++++++0
        
        
    
    
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
-(void)displayUIAlertAction1:(NSString *)title  message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
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
        
            if (PhoneElementNum>=0 && PhoneElementNum<_totalContactsNum+1) {
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
        
                
                NSString *script = [NSString stringWithFormat:@"document.getElementById('telnum').value='%@'", _PhoneNumList];
                
                [_CHTWebView stringByEvaluatingJavaScriptFromString:script];
                
                
                double delayInSeconds = 0.5;
                
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
                
                
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_CHTWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('btn_submit').click()"];
                });
                
                
            }
                
                //delay 1 sencond to click the submit
             if(PhoneElementNum == _totalContactsNum){
                [VMGearLoadingView hideGearLoadingForView:self.view];

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
        }
    }

}




- (IBAction)writeToAddressBook:(id)sender {
    [self distinguishLandline];
    
    NSLog(@"REMOVE:%@",_TheFirstPhoneNumberArray);
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
       
        
        //測試多按幾次會當掉
        //改過了
    }
     [self calculateNumbersOfInternalNetwork];
    [self displayUIAlertAction1:@"恭喜完成寫入" message:@"趕快查看您的通訊錄唷!!"];
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
    if([segue.identifier isEqualToString:@"CHTPieChart"])
    {   CHTAnalysisChartViewController *chtAnalysisChartViewController =segue.destinationViewController;
         NSNumber *myNum = @(_innerNet.count);
        NSNumber *myNum1 = @(_outerNet.count);
        NSNumber *myNum2 = @(_localphone.count);
        NSNumber *myNum3 = @(_otherphone.count);
        
        chtAnalysisChartViewController.innerNetCount=myNum;
        chtAnalysisChartViewController.outerNetCount=myNum1;
        chtAnalysisChartViewController.localPhoneCount=myNum2;
        chtAnalysisChartViewController.otherPhoneCount=myNum3;
        
        NSLog(@"\n _innerNet.count: %ld, \n _outerNet.count: %ld, \n _outerNet.count: %ld, \n _otherphone.count: %ld", _innerNet.count, _outerNet.count, _localphone.count, _otherphone.count);
      
       
        
    }




}




@end
