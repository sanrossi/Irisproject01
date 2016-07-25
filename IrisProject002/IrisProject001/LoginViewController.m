//
//  LoginViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/22.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.UserPhoneNumber=@"0919552512";
    self.Carriers=@"中華電信";
    self.PasswrdTextField.secureTextEntry =YES;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
//    if(){
//    
//    }
}
- (IBAction)ChLoginSubmit:(id)sender {
    
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
