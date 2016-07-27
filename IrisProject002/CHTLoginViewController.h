//
//  CHTLoginViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTLoginViewController : UIViewController
@property(nonatomic,weak)
NSString*UserPhoneNumber;
@property(nonatomic,weak)
NSString*emomeAccount;
@property(nonatomic,weak)
NSString*Passwrd;

@property (weak, nonatomic) IBOutlet UITextField *UserPhoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emomeAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswrdTextField;
@property (weak, nonatomic) IBOutlet UILabel *NotificationLabel;
@end
