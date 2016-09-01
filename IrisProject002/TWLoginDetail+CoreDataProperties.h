//
//  TWLoginDetail+CoreDataProperties.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/9/1.
//  Copyright © 2016年 iris shen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TWLoginDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWLoginDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *twLogin;
@property (nullable, nonatomic, retain) NSString *twPassword;
@property (nullable, nonatomic, retain) NSSet<NETCount *> *twLogintonetCount;

@end

@interface TWLoginDetail (CoreDataGeneratedAccessors)

- (void)addTwLogintonetCountObject:(NETCount *)value;
- (void)removeTwLogintonetCountObject:(NETCount *)value;
- (void)addTwLogintonetCount:(NSSet<NETCount *> *)values;
- (void)removeTwLogintonetCount:(NSSet<NETCount *> *)values;

@end

NS_ASSUME_NONNULL_END
