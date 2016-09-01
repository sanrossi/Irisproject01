//
//  FetNetLoginDetail.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/9/1.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface FetNetLoginDetail : NSManagedObject
@property(nonatomic)NSNumber *innerNetCount;
@property(nonatomic)NSNumber *outerNetCount;
@property(nonatomic)NSNumber *localPhoneCount;
@property(nonatomic)NSNumber *otherPhoneCount;
@end
