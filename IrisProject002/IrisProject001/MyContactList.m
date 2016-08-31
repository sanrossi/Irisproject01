//
//  CHTLoginViewController.h
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//



#import "MyContactList.h"
@implementation MyContactList
@synthesize totalPhoneNumberArray;

#pragma mark - Singleton Methods
+ (id)sharedContacts { //Shared instance method
    
    static MyContactList *sharedMyContacts = nil; //create contactsList Object
    
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
    groupsOfContact = [@[] mutableCopy]; //init a mutable array
    
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
                      //  [self updateContactFromContact];
                    } else { // else ask to get a permission to access a contacts in this app.
                        [self getPermissionToUser]; //Ask permission to user
                      
                    }
                }];
            }
                break;
            case kABAuthorizationStatusAuthorized: { //Contact access permission is already authorized.
                [self fetchContactsFromContactsFrameWork]; //access contacts
                //增加一個寫入方法
            //    [self updateContactFromContact];
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
        //NSLog(@"%@",contact.identifier);
        [groupsOfContact addObject:contact]; //add objects of all contacts list in array加入所有聯絡人物件在陣列中陣列名字是groupsOfContact
    }];

    
    
    NSMutableArray *phoneNumberArray = [@[] mutableCopy]; // init a mutable array初始化一個array
    
    // create object建立一個dictionary的物件
    
    //generate a custom dictionary to access
    for (CNContact *contact in groupsOfContact) {
        NSMutableArray *thisOne = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        NSLog(@"digits:%@",thisOne);
        //   [phoneNumberArray addObjectsFromArray:thisOne];
        //  NSLog(@"contact identifier: %@",contact.identifier);
        if(thisOne.count == 0){
            peopleDic = @{@"givenname":contact.givenName,
                          @"familyname":contact.familyName,
                          @"image":contact.thumbnailImageData != nil ? contact.thumbnailImageData:@"",
                          @"phone":@[@"",@""],
                          @"selected":@"NO"
                          };
        }
        else {
        peopleDic = @{@"givenname":contact.givenName,
                      @"familyName":contact.familyName,
                      @"image":contact.thumbnailImageData != nil ? contact.thumbnailImageData:@"",
                      @"phone":thisOne,
                      @"selected":@"NO"
                      };
        }
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





- (void)updateContactFromContact:(NSString*)contactName NetLabel:(NSString*)netLabel ContactPhone:(NSString*)origincontactphone{
    CNContactStore * store = [[CNContactStore alloc]init];
         //检索条件，检索所有名字中有san的联系人
         NSPredicate * predicate = [CNContact predicateForContactsMatchingName:contactName];
      //提取数据
     
         NSArray * contactsphone = [store unifiedContactsMatchingPredicate:predicate keysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] error:nil];
    NSLog(@"contactsphone:%@",contactsphone);

        CNMutableContact *contactphone2 = [[contactsphone objectAtIndex:0] mutableCopy];
    NSLog(@"contactphone2:%@",contactphone2.phoneNumbers);
     //    修改联系人的属性
    
    CNLabeledValue *cellPhone1 = [CNLabeledValue labeledValueWithLabel:netLabel value:[CNPhoneNumber phoneNumberWithStringValue:origincontactphone]];
    
    //contactphone2.phoneNumbers =@[cellPhone1];
    NSMutableArray *arrayupdate = [contactphone2.phoneNumbers mutableCopy];
    arrayupdate[0]=cellPhone1;
    contactphone2.phoneNumbers =[NSArray arrayWithArray:arrayupdate];
    
    

    NSLog(@"testtest:%@",contactphone2.phoneNumbers);
     //    实例化一个CNSaveRequest
         CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
         [saveRequest updateContact:contactphone2];
         [store executeSaveRequest:saveRequest error:nil];
    
    
}

//- (CNLabeledValue *)getCNLabeledValue:(CNLabeledValue *)cnLabeledValue to:(NSString*)netLabel {
//    
//    CNLabeledValue *cellPhone = [CNLabeledValue labeledValueWithLabel:netLabel value:[CNPhoneNumber phoneNumberWithStringValue:origincontactphone]];
//    
//    return cellPhone;
//}





//測試用



-(void)exportAddressBook{
    _theFirstPhone = [NSMutableArray array];
    _TheFirstPhoneNumberArray = [NSMutableArray array];
    _SecondPhoneNumberArray = [NSMutableArray array];
    _TheThirdPhoneNumberArray = [NSMutableArray array];
    _ContactGivenNameArray= [NSMutableArray array];
    _ContactFamilyNameArray= [NSMutableArray array];
    [[MyContactList sharedContacts] fetchAllContacts];
    //fetch all contacts by calling single to method
    
    if ([[MyContactList sharedContacts]totalPhoneNumberArray].count !=0) {
        NSLog(@"Fetched Contact Details : %ld",[[MyContactList sharedContacts]totalPhoneNumberArray].count);
        _totalContactsNum=[[MyContactList sharedContacts]totalPhoneNumberArray].count;
        NSLog(@"%@", [[MyContactList sharedContacts]totalPhoneNumberArray]);
        
        for(int i=0; i<_totalContactsNum;i++)
            
        {self.theFirstPhone=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"phone"];
            
            if([_theFirstPhone[0] length] == 0 ){
                [_TheFirstPhoneNumberArray addObject:@""];
                NSLog(@"test%@",_TheFirstPhoneNumberArray);
                
            }else{
                
                [_TheFirstPhoneNumberArray addObject:_theFirstPhone[0]];
                NSLog(@"test%@",_TheFirstPhoneNumberArray);
                //check the firstphone
            }
            
          
            if( _theFirstPhone.count == 2){
                [_SecondPhoneNumberArray addObject:_theFirstPhone[1]];
                NSLog(@"test%@",_SecondPhoneNumberArray);
            }else{
                [_SecondPhoneNumberArray addObject:@""];
                NSLog(@"test%@",_SecondPhoneNumberArray);
                //check the firstphone
            }
            
            if(_theFirstPhone.count == 3){
                 [_TheThirdPhoneNumberArray  addObject:_theFirstPhone[1]];
                NSLog(@"test%@",_TheThirdPhoneNumberArray );
            }else{
                [_TheThirdPhoneNumberArray addObject:@""];
                NSLog(@"test%@",_TheThirdPhoneNumberArray );
                //check the firstphone
            }
            
            
            
        }
        for(int i=0; i<[[MyContactList sharedContacts]totalPhoneNumberArray].count;i++)
        {
            NSString*ContactGivenname=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"givenname"];
            if(ContactGivenname==nil){
                [_ContactGivenNameArray addObject:@""];
            }else{
                [_ContactGivenNameArray addObject:ContactGivenname];
            }
            NSLog(@"givenname%@",_ContactGivenNameArray);
            
            NSString*ContactFamilynname=[[[MyContactList sharedContacts]totalPhoneNumberArray][i] objectForKey:@"familyName"];
            if(ContactFamilynname==nil){
                [_ContactFamilyNameArray addObject:@""];
            }
            else{
                [_ContactFamilyNameArray addObject:ContactFamilynname];
            }
            NSLog(@"familyName%@",_ContactFamilyNameArray);
        }
    }
    

    
}












@end
