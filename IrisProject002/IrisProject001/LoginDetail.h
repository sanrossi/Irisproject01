//
//  LoginDetail.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/8/31.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHTMainFunctionViewController.h"
#import "TWMainFunctionViewController.h"
#import <CoreData/CoreData.h>
@interface LoginDetail : NSManagedObject
@property(nonatomic)NSString *chtLogin;
@property(nonatomic)NSString *chtPassword;
//@property(nonatomic)NSString *TWLogin;
//@property(nonatomic)NSString *TWPassword;

@end
