//
//  TWMainFunctionViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/6.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "TWMainFunctionViewController.h"
#import "CHTMainFunctionViewController.h"
#import "TWAnalysisChartViewController.h"
#import "MyContactList.h"
#import "VMGearLoadingView.h"
#import "TWLoginDetail.h"
#import "CoreDataHelper.h"
@interface TWMainFunctionViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSInteger WebPageNum;
    NSInteger PhoneElementNum;
    BOOL flag3;
    
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
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;
@property(nonatomic)NSMutableArray *innerNet;
@property(nonatomic)NSMutableArray *outerNet;
@property(nonatomic)NSMutableArray *localphone;
@property(nonatomic)NSMutableArray *otherphone;
@property(nonatomic)NSArray *ContactId;
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
    _ContactFamilyNameArray= [NSMutableArray array];
    _fetchArray=[NSMutableArray array];
    _detail=[NSArray array];
    _innerNet= [NSMutableArray array];
    _outerNet= [NSMutableArray array];
    _localphone= [NSMutableArray array];
    _otherphone= [NSMutableArray array];
    _ContactId=[NSMutableArray array];
     WebPageNum =1;
    _FromWhichCompany=@"";
    //_TWWebView.scrollView.scrollEnabled = NO;
    //_TWWebView.hidden=YES;

    [self loadTWWebView];

    
    [[MyContactList sharedContacts] exportAddressBook];
    _totalContactsNum=[[MyContactList sharedContacts]totalContactsNum];
    _theFirstPhone=[[MyContactList sharedContacts]theFirstPhone];
    _TheFirstPhoneNumberArray=[[MyContactList sharedContacts]TheFirstPhoneNumberArray];
    _ContactFamilyNameArray =[[MyContactList sharedContacts]ContactFamilyNameArray];
    _ContactGivenNameArray =[[MyContactList sharedContacts]ContactGivenNameArray];
    _ContactId =[[MyContactList sharedContacts]ContactId];

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
    //NSLog(@"width %f,height %f",image.size.width,image.size.height);
    
    
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




-(void)inputtheLoginNum{

    if((_TWLogin.text.length==0 || _TWLogin.text.length != 10)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入帳號"];
        
    }
    else if((_TWPassword.text.length  == 0)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入密碼"];
        
    }else if((_TWChkNum.text.length == 0)){
        [self displayUIAlertAction:@"提醒" message:@"請輸入驗證碼"];
        
    }else if(_TWLogin.text.length!= 0 && _TWPassword.text.length!= 0 &&_TWChkNum.text.length!= 0){
        NSString *loginaccount = [NSString stringWithFormat:@"document.getElementById('input-mobile').value='%@'",_TWLogin.text];
        
        //NSString *loginpasswordtxt = [NSString stringWithFormat:@"document.getElementById('passtxt').value='%@'",_TWPassword.text];
        NSString *loginpassword = [NSString stringWithFormat:@"document.getElementById('input-password').value='%@'",_TWPassword.text];
        
        NSString *logincchknum = [NSString stringWithFormat:@"document.getElementById('input-code').value='%@'",_TWChkNum.text];
        [_TWWebView stringByEvaluatingJavaScriptFromString:loginaccount];
        //[_TWWebView stringByEvaluatingJavaScriptFromString:loginpasswordtxt];
        [_TWWebView stringByEvaluatingJavaScriptFromString:loginpassword];
        [_TWWebView stringByEvaluatingJavaScriptFromString:logincchknum];
        double delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn btn-centerlize btn-login')[0].click()"];
        });
    }else{
    //0++++++++++++++++++++++++++++++++++++++++++++0
    [self displayUIAlertAction:@"請輸入正確的帳號密碼" message:@""];
    [self viewDidLoad];
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



-(void)shouldSavetheFile:(NSString*)twLoginName twPassword:(NSString*)twpassword{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"TWLoginDetail"];
    _detail=[context executeFetchRequest:request error:nil];
    
    if(_detail.count != 0){

        for (TWLoginDetail *managedObject in _detail) {
            [context deleteObject:managedObject];

        }
        flag3=true;
    }
    else{
        flag3=true;
    }
    
    
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
                                        message:@"驗證碼:   ＿＿＿＿＿＿"
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
                                                           [self shouldSavetheFile:_TWLogin.text twPassword:_TWPassword.text];
                                                       
                                                           
                                                           if(flag3){
                                                               NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
                                                               TWLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"TWLoginDetail" inManagedObjectContext:context];
                                                               
                                                               login.twLogin=_TWLogin.text;
                                                               //NSLog(@"%@",login.twLogin);
                                                               login.twPassword=_TWPassword.text;
                                                               if(login.twLogin.length !=0 &&login.twPassword.length !=0){
                                                                   [context save:nil];
                                                               }
                                                           };



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
            
            
            NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"TWLoginDetail"];
            NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
            
            if(_detail !=0){
            NSArray *detail=[context executeFetchRequest:request error:nil];
            //NSLog(@"%@",detail);
            NSPredicate *myPrdicate=[NSPredicate predicateWithFormat:@"twLogin == %@ && twPassword = %@ ",nil,nil];
            
            [request setPredicate:myPrdicate];
            
            _fetchArray=[context executeFetchRequest:request error:nil];
            //NSLog(@"fetchArray%@",_fetchArray);
            // 執行fetch request  return 你的搜尋結果在fetcharray中
            
            if(_fetchArray.count==0){
                if(detail.count !=0){
                TWLoginDetail *loginDetail = [detail objectAtIndex:0];
                //NSLog(@">>>>>>>>>>%@",loginDetail);
                
                alert.textFields[0].text= loginDetail.twLogin;
                alert.textFields[1].text=loginDetail.twPassword;
                }
            }else{
                
                for (TWLoginDetail *managedObject1 in _fetchArray) {
                    [context deleteObject:managedObject1];
                    //                [context deletedObjects];
                }
                
                
                TWLoginDetail *loginDetail = [detail objectAtIndex:0];
                alert.textFields[0].text= loginDetail.twLogin;
                //NSLog(@"CHTLogin:%@",alert.textFields[0].text);
                alert.textFields[1].text=loginDetail.twPassword;
                
            }
            }//括號家這裡
        
        
         });
        
    
        
      

        
        
    }
    
    else if ([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://cs.taiwanmobile.com/wap-portal/smpQueryTwmPhoneNbr.action"]||[[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://cs.taiwanmobile.com/wap-portal/smpQueryTwmPhoneNbr.action#"]){

      
  
        if (PhoneElementNum>=0 && PhoneElementNum<_totalContactsNum) {
            if(PhoneElementNum==_totalContactsNum-1){
                [VMGearLoadingView hideGearLoadingForView:self.view];
            }
        
            _PhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
            //正則化
            NSString *letters = @"0123456789";
            NSCharacterSet *notLetters = [[NSCharacterSet characterSetWithCharactersInString:letters] invertedSet];
            _PhoneNumList = [[_PhoneNumList componentsSeparatedByCharactersInSet:notLetters] componentsJoinedByString:@""];
            //NSLog(@"newString: %@", _PhoneNumList);
            //正則化
            
            
            
            
      if((_PhoneNumList.length==10 && [_PhoneNumList hasPrefix:@"09"]) || ([_PhoneNumList hasPrefix:@"8869"] && _PhoneNumList.length==12)){
            if([_PhoneNumList hasPrefix:@"8869"]){
                    _PhoneNumList = [_PhoneNumList substringWithRange:NSMakeRange(3,9)];
                    
                    //NSLog(@"去除886%@",_PhoneNumList);
                    
                    _PhoneNumList=[NSString stringWithFormat:@"0%@",_PhoneNumList];
                   
                    //NSLog(@"加0%@",_PhoneNumList);
            }
          
          if(_TWWebView.loading==NO){
               NSLog(@"加0%@",_PhoneNumList);
               NSString *script = [NSString stringWithFormat:@"document.getElementById('input-phone').value ='%@'",_PhoneNumList];
              [_TWWebView stringByEvaluatingJavaScriptFromString:script];
              
              double delayInSeconds = 0.3;
              
              dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
              dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       
                  [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn btn-centerlize btn-change ui-link btn-disable')[0].click()"];
                  
                  //NSLog(@"+++++++++++++++++");
              });
              

                 }
          
            }
      
            else {
                 PhoneElementNum+=1;
                
                
                NSLog(@"加0%@",_PhoneNumList);
                _FromWhichCompanyinfo=@"其他";
                [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
                NSLog(@"wenet:%@",_FormWhichCompanyList);
                
                _PhoneNumList=@"11111111111";
                if(_TWWebView.loading==NO){
              
                NSString *script = [NSString stringWithFormat:@"document.getElementById('input-phone').value ='%@'",_PhoneNumList];
                [_TWWebView stringByEvaluatingJavaScriptFromString:script];
                
                    double delayInSeconds = 0.3;
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             
                  [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn btn-centerlize btn-change ui-link btn-disable')[0].click()"];
                   });
                    
                    }
//                NSLog(@"didFinish1111: %@; stillLoading: %@", [[_TWWebView request]URL],
//                      (_TWWebView.loading?@"YES":@"NO"));
                //改這裡
            }

          }
            

       
    }
    else if ([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://cs.taiwanmobile.com/wap-portal/smpCheckTwmPhoneNbr.action"]){
        
        
        
        
        
        
        
        
        
        //NSLog(@"ooooooooooooooooooooo");
//        if([_FromWhichCompany  isEqual:@""]){
        
            if(_TWWebView.loading==NO){
                if(PhoneElementNum == 0){
                    [VMGearLoadingView showGearLoadingForView:self.view];
                }
                
          
                _FromWhichCompany = [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('red')[6].innerHTML"];
                
//                if([_FromWhichCompany  isEqual:@""]){
//                    _FromWhichCompany = [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('font')[0].innerHTML"];
//                    
//                }
            
//                NSLog(@"didFinish: %@; stillLoading: %@", [[_TWWebView request]URL],
//                      (_TWWebView.loading?@"YES":@"NO"));
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
               // NSLog(@"login%@",_FromWhichCompanyinfo);
                if(_FromWhichCompanyinfo != NULL){
                    [_FormWhichCompanyList addObject:_FromWhichCompanyinfo];
                    NSLog(@"wenet:%@",_FormWhichCompanyList);
                    
                }
            
            
          //轉轉轉打開這裡        
       
//                if(PhoneElementNum == 0){
//                    [VMGearLoadingView showGearLoadingForView:self.view];
//                }
//            
//            if(PhoneElementNum==_totalContactsNum-1){
//                [VMGearLoadingView hideGearLoadingForView:self.view];
//            }
            //}
        
            //轉轉轉打開這裡
            //NSLog(@"TOTALCOUNT%ld",_totalContactsNum);
            //NSLog(@"PHONELEMENT:%ld",PhoneElementNum);
                // if(_TWWebView.loading==NO){
                     
                    
                     PhoneElementNum+=1;
                [_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
             //  [_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn ui-link')[0].click()"];
                     
                
                            
                 }
                
//            }else if(![_FromWhichCompany  isEqual:@""]){
//        
//                 if(_TWWebView.loading==NO){
//                     PhoneElementNum+=1;
//                     _FromWhichCompany=@"";
//                [_TWWebView stringByEvaluatingJavaScriptFromString:@"history.go(-1)"];
//                //[_TWWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('btn ui-link')[0].click()"];
//
//                     
//                 }
//                
//            }

    }
else if([[[[_TWWebView request]URL]absoluteString]  isEqualToString: @"https://www.catch.net.tw/auth/loginMessage_m.jsp"]){
        
        [self loadTWWebView];

    }
    
}









-(void)distinguishLandline{
    if(_TheFirstPhoneNumberArray.count==0){
        [self displayUIAlertAction:@"請先輸入帳號密碼" message:@""];
        
    }
    else{
    if(_FormWhichCompanyList.count == _TheFirstPhoneNumberArray.count+1){
        [_FormWhichCompanyList removeObjectAtIndex:0];
    }
    for (PhoneElementNum=0 ; PhoneElementNum<_totalContactsNum;PhoneElementNum++) {
        NSString *CheckPhoneNumList=_TheFirstPhoneNumberArray[PhoneElementNum];
        //正則化
        NSString *letters = @"0123456789";
        NSCharacterSet *notLetters = [[NSCharacterSet characterSetWithCharactersInString:letters] invertedSet];
        CheckPhoneNumList= [[CheckPhoneNumList componentsSeparatedByCharactersInSet:notLetters] componentsJoinedByString:@""];
        //NSLog(@"newString: %@", CheckPhoneNumList);
        //正則化
        
        NSArray *twRegionCod =[ [ NSArray alloc ] initWithObjects:@"02",@"03",@"037",@"04",@"049",@"05",@"06",@"07",@"089",@"082",@"0826",@"0836",@"8862",@"8863",@"88637",@"8864",@"88649",@"8865",@"8866",@"8867",@"88989",@"88682",@"886826",@"886836", nil];
        
        for(int twRegionCodElement=0;twRegionCodElement<twRegionCod.count;twRegionCodElement++){
            NSString * stringFromtwRegionCod = [twRegionCod objectAtIndex:twRegionCodElement];
            if ([CheckPhoneNumList hasPrefix:stringFromtwRegionCod]) {
                 if(_FormWhichCompanyList.count !=0){
                _FormWhichCompanyList[PhoneElementNum]=@"市話";
                 }
            }
            //NSLog(@"市話%@",_FormWhichCompanyList);
        }
    }
    }
}






- (IBAction)writeToAddressBook:(id)sender {
    [self distinguishLandline];
    //NSLog(@"count%ld",_FormWhichCompanyList.count);

    if(_FormWhichCompanyList.count==_TheFirstPhoneNumberArray.count){
    for(int count=0;count<_totalContactsNum;count++)
    {
        //        //_TheFirstPhoneNumberarray//剃出第一個（後進先出）
        //        //_FormWhichCompanyList//取出網內外（後進先出）
        //        //_ContactGivenNameArray//去名字（後進先出)
        //_TheFirstPhoneNumberarray[_totalContactsNumber-count-1]
        
        
//        if(_TheFirstPhoneNumberArray[count]==nil){
//            _TheFirstPhoneNumberArray[count]=@""; }
//        
//        if([_ContactGivenNameArray[count] isEqual:@""]){
//            [[MyContactList sharedContacts]updateContactFromContact:_ContactFamilyNameArray[count] NetLabel:_FormWhichCompanyList[count] ContactPhone:_TheFirstPhoneNumberArray[count]];}
//        
//        else{
//            [[MyContactList sharedContacts]updateContactFromContact:_ContactGivenNameArray[count] NetLabel:_FormWhichCompanyList[count] ContactPhone:_TheFirstPhoneNumberArray[count]];
//        }
        [[MyContactList sharedContacts]updateContactById:_ContactId[count] NetLabel:_FormWhichCompanyList[count] ContactPhone:_TheFirstPhoneNumberArray[count]];        
    }
        [self calculateNumbersOfInternalNetwork];
        [self displayUIAlertAction1:@"恭喜完成寫入" message:@"趕快查看您的通訊錄唷!!"];
    } else if(_FormWhichCompanyList.count ==0){
        [self displayUIAlertAction1:@"請登入帳號密碼" message:@""];
    }
    
    else{
        
        [self displayUIAlertAction1:@"請檢查網路狀態" message:@"請改wifi連線"];
    
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
        //NSLog(@"netname:%@",Netname);
        
        if([Netname isEqualToString:@"網內" ]){
            [_innerNet addObject:Netname];
        }else if([Netname isEqualToString:@"網外"]){
            [_outerNet addObject:Netname];
        }else if([Netname isEqualToString:@"市話"]){
            [_localphone addObject:Netname];
        }else if([Netname isEqualToString:@"其他"]){
            [_otherphone addObject:Netname];
        }
        
        
//        NSLog(@"網內%ld",_innerNet.count);
//        NSLog(@"網外%ld",_outerNet.count);
//        NSLog(@"市話%ld",_localphone.count);
//        NSLog(@"其他%ld",_otherphone.count);
        
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"TWTPieChart"])
    {   TWAnalysisChartViewController *twAnalysisChartViewController =segue.destinationViewController;
        NSNumber *myNum = @(_innerNet.count);
        NSNumber *myNum1 = @(_outerNet.count);
        NSNumber *myNum2 = @(_localphone.count);
        NSNumber *myNum3 = @(_otherphone.count);
        
        twAnalysisChartViewController.innerNetCount=myNum;
        twAnalysisChartViewController.outerNetCount=myNum1;
        twAnalysisChartViewController.localPhoneCount=myNum2;
        twAnalysisChartViewController.otherPhoneCount=myNum3;
        
//        NSLog(@"\n _innerNet.count: %ld, \n _outerNet.count: %ld, \n _outerNet.count: %ld, \n _otherphone.count: %ld", _innerNet.count, _outerNet.count, _localphone.count, _otherphone.count);
        
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
