//
//  CHTMemberModifyViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/31.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMemberModifyViewController.h"
#import "CHTLoginDetail.h"
#import "CoreDataHelper.h"
@interface CHTMemberModifyViewController (){
    BOOL flag1;

}
@property (weak, nonatomic) IBOutlet UITextField *CHTLogin;
@property (weak, nonatomic) IBOutlet UITextField *CHTPassWord;
@property(nonatomic)NSMutableArray *loginaccount;
@property(nonatomic)NSMutableArray *loginpassword;

@end

@implementation CHTMemberModifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _loginaccount=[NSMutableArray array];
    _loginpassword=[NSMutableArray array];
    flag1=false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkBtn:(id)sender {
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"CHTLoginDetail" inManagedObjectContext:context];
    if([self shouldSavetheFile:_CHTLogin.text chtPassword:_CHTPassWord.text]){
        flag1=true;
    }
    // Do any additional setup after loading the view.
    login.chtLogin=_CHTLogin.text;
    login.chtPassword=_CHTPassWord.text;
    if(flag1){
        if(login.chtLogin.length !=0 &&login.chtPassword.length !=0){
            [context save:nil];
        }
        
    };
}

-(BOOL)shouldSavetheFile:(NSString*)chtLoginName chtPassword:(NSString*)chtpassword{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
    NSArray *detail=[context executeFetchRequest:request error:nil];
    for(int i=0;i<detail.count;i++){
        CHTLoginDetail *loginDetail = [detail objectAtIndex:i];
        if(loginDetail.chtLogin.length !=0 &&loginDetail.chtPassword.length !=0){
            [_loginaccount addObject:loginDetail.chtLogin];
            [_loginpassword addObject:loginDetail.chtPassword];
        }
    }
    for(int i=0;i<_loginpassword.count;i++){
        
        if([[_loginaccount objectAtIndex:i]length]!=0 &&[[_loginpassword objectAtIndex:i] length]!=0){
            NSString *login=[_loginaccount objectAtIndex:i];
            NSString *password =[_loginpassword objectAtIndex:i];
            
            if(![chtLoginName isEqualToString:login] && ![chtpassword isEqualToString:password]){
                
                return true;
            }
           
        }
        
    }
     return false;
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
