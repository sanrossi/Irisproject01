//
//  TWMemberModifyViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/9/1.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "TWMemberModifyViewController.h"

@interface TWMemberModifyViewController (){
    BOOL flag1;
    
}
@property (weak, nonatomic) IBOutlet UITextField *TWLogin;
@property (weak, nonatomic) IBOutlet UITextField *TWPassWord;
@property(nonatomic)NSMutableArray *loginaccount;
@property(nonatomic)NSMutableArray *loginpassword;

@end

@implementation TWMemberModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginaccount=[NSMutableArray array];
    _loginpassword=[NSMutableArray array];
    flag1=false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(BOOL)shouldSavetheFile:(NSString*)chtLoginName chtPassword:(NSString*)chtpassword{
//    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
//    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
//    NSArray *detail=[context executeFetchRequest:request error:nil];
//    for(int i=0;i<detail.count;i++){
//        CHTLoginDetail *loginDetail = [detail objectAtIndex:i];
//        if(loginDetail.chtLogin.length !=0 &&loginDetail.chtPassword.length !=0){
//            [_loginaccount addObject:loginDetail.chtLogin];
//            [_loginpassword addObject:loginDetail.chtPassword];
//        }
//    }
//    for(int i=0;i<_loginpassword.count;i++){
//        
//        if([[_loginaccount objectAtIndex:i]length]!=0 &&[[_loginpassword objectAtIndex:i] length]!=0){
//            NSString *login=[_loginaccount objectAtIndex:i];
//            NSString *password =[_loginpassword objectAtIndex:i];
//            
//            if(![chtLoginName isEqualToString:login] && ![chtpassword isEqualToString:password]){
//                
//                return true;
//            }
//            
//        }
//        
//    }
//    return false;
//}

@end
