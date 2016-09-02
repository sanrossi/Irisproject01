//
//  NETCount+CoreDataProperties.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/9/2.
//  Copyright © 2016年 iris shen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NETCount.h"

NS_ASSUME_NONNULL_BEGIN

@interface NETCount (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *innerNetCount;
@property (nullable, nonatomic, retain) NSNumber *localPhoneCount;
@property (nullable, nonatomic, retain) NSNumber *otherPhoneCount;
@property (nullable, nonatomic, retain) NSNumber *outerNetCount;
@property (nullable, nonatomic, retain) CHTLoginDetail *chtLogintoNetcount;

@end

NS_ASSUME_NONNULL_END
