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
@property(nonatomic)NSArray *detail;
@property(nonatomic)NSArray *fetchArray;
@end

@implementation CHTMemberModifyViewController{

    BOOL flag3;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _loginaccount=[NSMutableArray array];
    _loginpassword=[NSMutableArray array];
     _fetchArray=[NSMutableArray array];
    flag1=false;
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)checkBtn:(id)sender {

    [self shouldSavetheFile:_CHTLogin.text chtPassword:_CHTPassWord.text];
    
    
    if(flag3){
//        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
//        NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"CHTLoginDetail"];
//        
//        NSArray *result = [context executeFetchRequest:request1 error:nil];
//        CHTLoginDetail *login = (CHTLoginDetail *)result.firstObject;
        NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
        CHTLoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"CHTLoginDetail" inManagedObjectContext:context];
        login.chtLogin=_CHTLogin.text;
        NSLog(@"%@",login.chtLogin);
        login.chtPassword=_CHTPassWord.text;
        if(login.chtLogin.length !=0 &&login.chtPassword.length !=0){
            [context save:nil];
        }
    };

    

}





-(void)shouldSavetheFile:(NSString*)chtLoginName chtPassword:(NSString*)chtpassword{
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    NSFetchRequest *request =[[NSFetchRequest alloc]initWithEntityName:@"CHTLoginDetail"];
    _detail=[context executeFetchRequest:request error:nil];
    NSPredicate *myPrdicate=[NSPredicate predicateWithFormat:@"chtLogin == %@ && chtPassword = %@ ",chtLoginName,chtpassword];
    [request setPredicate:myPrdicate];
    NSArray *fetchArray=[context executeFetchRequest:request error:nil];
    // 執行fetch request  return 你的搜尋結果在fetcharray中
    NSLog(@"fetchArray:%@",fetchArray);
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
