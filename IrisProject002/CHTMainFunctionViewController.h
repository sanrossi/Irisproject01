//
//  CHTMainFunctionViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//
#import "TWMainFunctionViewController.h"
#import <UIKit/UIKit.h>
@import WebKit;
@import UIKit;

@interface CHTMainFunctionViewController : UIViewController
@property(nonatomic)NSMutableArray *FormWhichCompanyList;
@property(nonatomic)NSMutableArray *ContactGivenNameArray;
@property(nonatomic)NSMutableArray *ContactFamilyNameArray;
@property(weak,nonatomic)NSMutableArray *theFirstPhone;
@property(weak,nonatomic)NSString *PhoneNumList;
@property(nonatomic)NSMutableArray *TheFirstPhoneNumberArray;
@property(nonatomic)NSString*FromWhichCompanyinfo;
@property(nonatomic)NSInteger totalContactsNum;


@end
