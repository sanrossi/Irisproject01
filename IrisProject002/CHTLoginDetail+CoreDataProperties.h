//
//  CHTLoginDetail+CoreDataProperties.h
//  
//
//  Created by 沈秋蕙 on 2016/9/1.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CHTLoginDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface CHTLoginDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chtLogin;
@property (nullable, nonatomic, retain) NSString *chtPassword;
@property (nullable, nonatomic, retain) NSSet<NETCount *> *chtLogintonetCount;

@end

@interface CHTLoginDetail (CoreDataGeneratedAccessors)

- (void)addChtLogintonetCountObject:(NETCount *)value;
- (void)removeChtLogintonetCountObject:(NETCount *)value;
- (void)addChtLogintonetCount:(NSSet<NETCount *> *)values;
- (void)removeChtLogintonetCount:(NSSet<NETCount *> *)values;

@end

NS_ASSUME_NONNULL_END
