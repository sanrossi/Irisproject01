//
//  CHTMemberModifyViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/31.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CHTMemberModifyViewController.h"
#import "LoginDetail.h"
#import "CoreDataHelper.h"
@interface CHTMemberModifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *CHTLogin;
@property (weak, nonatomic) IBOutlet UITextField *CHTPassWord;

@end

@implementation CHTMemberModifyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkBtn:(id)sender {
    NSManagedObjectContext *context =[CoreDataHelper sharedInstance].managedObjectContext;
    LoginDetail *login = [NSEntityDescription insertNewObjectForEntityForName:@"LoginDetail" inManagedObjectContext:context];
    
    // Do any additional setup after loading the view.
    login.chtLogin=_CHTLogin.text;
    login.chtPassword=_CHTPassWord.text;
    [context save:nil];
    
    
    
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
