//
//  CHTLoginViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//



#import "MyContactList.h"

@implementation ContactList
@synthesize totalPhoneNumberArray;

#pragma mark - Singleton Methods
+ (id)sharedContacts { //Shared instance method
    
    static ContactList *sharedMyContacts = nil; //create contactsList Object
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //for first time create shared instance object
        sharedMyContacts = [[self alloc] init];
    });
    
    return sharedMyContacts;
}

- (id)init { //init method
    if (self = [super init]) {
        totalPhoneNumberArray = [NSMutableArray array]; //init a mutableArray
    }
    return self;
}

#pragma mark - Fetch All Contacts from Addressbooks or Contacts framework
//Method of fetch contacts from Addressbooks or Contacts framework
- (void)fetchAllContacts {
    //獲取所有聯絡人
    groupsOfContact = [@[] mutableCopy]; //init a mutable array初始化一個mutablearray
    
    //In iOS 9 and above, use Contacts.framework
    if (NSClassFromString(@"CNContactStore")) { //if Contacts.framework is available
        contactStore = [[CNContactStore alloc] init]; //init a contactStore object
        
        //Check contacts authorization status using Contacts.framework entity
        switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]) {
                
            case CNAuthorizationStatusNotDetermined: { //Address book status not determined.
                
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError *error) { //permission Request alert will show here.
                    if (granted) { //if user allow to access a contacts in this app.
                        [self fetchContactsFromContactsFrameWork]; //access contacts
                        //增加一個寫入方法
                        [self creatContact];
                    } else { // else ask to get a permission to access a contacts in this app.
                        [self getPermissionToUser]; //Ask permission to user
                        
                    }
                }];
            }
                break;
            case kABAuthorizationStatusAuthorized: { //Contact access permission is already authorized.
                [self fetchContactsFromContactsFrameWork]; //access contacts
                //增加一個寫入方法
                [self creatContact];
            }
                break;
            default: { //else ask permission to user
                [self getPermissionToUser];
            }
                break;
        }
        
    } else { //else AddressBook.framework is available below iOS 9
        NSMutableArray *phoneNumberArray = [@[] mutableCopy]; //init array
        
        if ([self getAddressBookAuthorizationFromUser].count !=0) { //if the User permission granted to access a contacts
            phoneNumberArray = [self fetchContactsFromAddressBookFrameWork]; // fetch contacts from contacts app
        }//從手機通訊錄讀出
        totalPhoneNumberArray = [phoneNumberArray mutableCopy]; // take a copy of all contacts.
    }
}

#pragma mark - Contacts.framework method
- (void)fetchContactsFromContactsFrameWork { //access contacts using contacts.framework
    
    NSArray *keyToFetch = @[CNContactEmailAddressesKey,CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactPostalAddressesKey,CNContactThumbnailImageDataKey]; //contacts list key params to access using contacts.framework contact
    
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keyToFetch]; //Contacts fetch request parrams object allocation
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [groupsOfContact addObject:contact]; //add objects of all contacts list in array加入所有聯絡人物件在陣列中陣列名字是groupsOfContact
    }];
    
    NSMutableArray *phoneNumberArray = [@[] mutableCopy]; // init a mutable array初始化一個array
    
    NSDictionary *peopleDic; // create object建立一個dictionary的物件
    
    //generate a custom dictionary to access
    for (CNContact *contact in groupsOfContact) {
        NSArray *thisOne = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        //   [phoneNumberArray addObjectsFromArray:thisOne];
        //  NSLog(@"contact identifier: %@",contact.identifier);
        
        peopleDic = @{@"name":contact.givenName,
                      @"image":contact.thumbnailImageData != nil ? contact.thumbnailImageData:@"",
                      @"phone":thisOne,
                      @"selected":@"NO"
                      };
        
        [phoneNumberArray addObject:peopleDic]; //add object of people info to array
    }
    
    totalPhoneNumberArray = [phoneNumberArray mutableCopy]; //get a copy of all contacts list to array.
}

#pragma mark - Addressbook.framework method
- (NSMutableArray *)getAddressBookAuthorizationFromUser{ //access contacts using AddressBook.framework
    
    NSMutableArray *finalContactList = [[NSMutableArray alloc] init]; //init a array
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL); //init a addressbook ref object
    
    //Check a AddressBook.framework to access a contacts app
    switch (ABAddressBookGetAuthorizationStatus()) {
            
        case kABAuthorizationStatusNotDetermined:{ //Address book status not determined.
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) { // First time access has been granted, add the contact
                    
                    [finalContactList addObject:[self fetchContactsFromAddressBookFrameWork]];  //fetch all contacts and add to array.
                } else { // User denied to access a contacts app
                    
                    // Display an alert telling user the contact could not be added
                    [self getPermissionToUser];  //Ask permission to access a contacts
                }
            });
            
        }
            break;
        case kABAuthorizationStatusAuthorized:{ //Address book status Authorized.
            
            // The user has previously given access, add the contact
            finalContactList = [self fetchContactsFromAddressBookFrameWork];
            
        }break;
        default:{ //else ask permission to user
            // The user has previously denied access
            // Send an alert telling user to change privacy setting in settings app
            
            [self getPermissionToUser];  //Ask permission to access a contacts
            
        }break;
    }
    return finalContactList;
}

#pragma mark fetch contacts using addressbook framework
- (NSMutableArray *)fetchContactsFromAddressBookFrameWork { //fetch contacts using addressbook framework
    
    NSMutableArray *newContactArray  = [NSMutableArray array]; //init a array
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL); //init a addressbook object
    
    arrayOfAllPeople = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook); //get all contacts from contacts app.
    
    NSUInteger peopleCounter = 0; //set a initial value as ZERO.
    
    //Create custom Contacts list
    for (peopleCounter = 0; peopleCounter < [arrayOfAllPeople count]; peopleCounter++) {
        
        ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter]; // get every person record one by one.
        
        NSString *name = (__bridge NSString *) ABRecordCopyCompositeName(thisPerson); //get a person name
        
        
        
        ABMultiValueRef number = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty); //get a person number
        
        //optimize a phone numbers
        for (NSUInteger emailCounter = 0; emailCounter < ABMultiValueGetCount(number); emailCounter++) {
            
            NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(number, emailCounter);
            
            if ([email length] != 0) { //remove unwanted special characters in phone number
                
                NSString* phoneNumber = [email stringByReplacingOccurrencesOfString:@"-"withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")"withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" "withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"("withString:@""];
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+"withString:@""];
                phoneNumber =  [[phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                
                NSMutableDictionary *contantDic = [NSMutableDictionary dictionary]; //init a dictionary
                
                //add name value
                if ([name length]==0) {
                    [contantDic setValue:@"No name" forKey:@"name"];
                } else {
                    [contantDic setValue:name forKey:@"name"];
                }
                
                [contantDic setValue:phoneNumber forKey:@"phone"]; // add phone number value
                
                [contantDic setValue:@"NO" forKey:@"selected"]; // add this option for developer usage
                
                //get person image
                NSData *contactImageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(thisPerson, kABPersonImageFormatThumbnail);
                
                //check and add a person image
                if (contactImageData!=nil) {
                    [contantDic setObject:contactImageData forKey:@"image"];
                } else {
                    [contantDic setObject:@"" forKey:@"image"];
                }
                
                [newContactArray addObject:contantDic]; //add every person to array
            }
        }
    }
    return newContactArray; //return a contacts
}

-(void)getPermissionToUser {
#warning TODO: Show alert to the User, for enable the contacts permission in the Settings
    // The user has previously denied access
    // Send an alert telling user to change privacy setting in settings app
    NSLog(@"Get Permission to User");
}








#pragma mark - 添加联系人
- (void)creatContact{
    
    CNMutableContact *contact = [[CNMutableContact alloc] init]; // 第一次运行的时候，会获取通讯录的授权（对通讯录进行操作，有权限设置）
    
    // 1、添加姓名（姓＋名）
    contact.givenName = @"san";
    contact.familyName = @"wangg";
    //    contact.nickname = @"hahahah"; // 昵称
    //    contact.nameSuffix = @"nameSuffix"; // 名字后缀
    //    contact.namePrefix = @"namePrefix"; // 前字后缀
    //    contact.previousFamilyName = @"previousFamilyName"; // 之前的familyName
    
    // 2、添加职位相关
    contact.organizationName = @"公司名称";
    contact.departmentName = @"开发部门";
    contact.jobTitle = @"工程师";
    
    // 3、这一部分内容会显示在联系人名字的下面，phoneticFamilyName属性设置的话，会影响联系人列表界面的排序
    //    contact.phoneticGivenName = @"GivenName";
    //    contact.phoneticFamilyName = @"FamilyName";
    //    contact.phoneticMiddleName = @"MiddleName";
    
    // 4、备注
    contact.note = @"同事";
    
    // 5、头像
    contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"1"]);
    
    // 6、添加生日
    NSDateComponents *birthday = [[NSDateComponents alloc] init];
    birthday.year = 1990;
    birthday.month = 6;
    birthday.day = 6;
    contact.birthday = birthday;
    
    
    // 7、添加邮箱
    CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:@"bvbdsmv@icloud.com"];
    //    CNLabeledValue *workEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"11111888888"];
    //    CNLabeledValue *iCloudEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:@"34454554"];
    //    CNLabeledValue *otherEmail = [CNLabeledValue labeledValueWithLabel:CNLabelOther value:@"6565448"];
    contact.emailAddresses = @[homeEmail];
    
    
    // 8、添加电话
    CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"11122233344"]];
    contact.phoneNumbers = @[homePhone];
    
    // 9、添加urlAddresses,
    CNLabeledValue *homeurl = [CNLabeledValue labeledValueWithLabel:CNLabelURLAddressHomePage value:@"http://baidu.com"];
    contact.urlAddresses = @[homeurl];
    
    // 10、添加邮政地址
    CNMutablePostalAddress *postal = [[CNMutablePostalAddress alloc] init];
    postal.city = @"北京";
    postal.country =  @"中国";
    CNLabeledValue *homePostal = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:postal];
    contact.postalAddresses = @[homePostal];
    
    
    // 获取通讯录操作请求对象
    CNSaveRequest *request = [[CNSaveRequest alloc] init];
    [request addContact:contact toContainerWithIdentifier:nil]; // 添加联系人操作（同一个联系人可以重复添加）
    // 获取通讯录
    CNContactStore *store = [[CNContactStore alloc] init];
    // 保存联系人
    [store executeSaveRequest:request error:nil]; // 通讯录有变化之后，还可以监听是否改变（CNContactStoreDidChangeNotification）
    
}






@end
