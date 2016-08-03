//
//  CHTLoginViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h> //AddressBook.framework for below iOS 9
#import <Contacts/Contacts.h> //Contacts.framework for above iOS 9
#import "CHTMainFunctionViewController.h"

@interface MyContactList : NSObject{
    
    NSMutableArray *totalPhoneNumberArray; //Total Mobile Contacts from access from this variable
    
    NSMutableArray *groupsOfContact; //Collection of contacts by using contacts.framework
    NSArray *arrayOfAllPeople; //Collection of contacts by using  AddressBook.framework
    
    ABAddressBookRef addressBook; //Address Book Object
    
    CNContactStore *contactStore; //ContactStore Object
    NSDictionary *peopleDic;
}

//@property(nonatomic)NSMutableDictionary *contantDic;
@property (nonatomic,retain) NSMutableArray *totalPhoneNumberArray; //Total Mobile Contacts access from this variable property

//fetch Contact shared instance method
+(id)sharedContacts; //Singleton method

///fetch contacts from Addressbooks or Contacts framework
-(void)fetchAllContacts; //Method of fetch contacts from Addressbooks or Contacts framework
- (void)updateContactFromContact:(NSString*)contactName NetLabel:(NSString*)netLabel ContactPhone:(NSString*)origincontactphone;


@end



