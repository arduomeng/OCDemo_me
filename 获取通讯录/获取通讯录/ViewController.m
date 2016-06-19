//
//  ViewController.m
//  获取通讯录
//
//  Created by LCS on 16/6/18.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>
@interface ViewController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
    
}


#pragma    mark   ABPeoplePickerNavigationControllerDelegate
// 选中某一个联系人的时候会执行该代理方法，如果实现该方法就不会进入联系人详情界面

// 注意coreFoundation框架使用时，如果有create或者copy的时候，需要手动管理内存
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    CFStringRef firstname=ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //CFStringRef middleName=ABRecordCopyValue(person, kABPersonMiddleNameProperty);
    CFStringRef lastname=ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // 将coreFoundation桥接成Foundation有两种方式
    // 1.(__bridge NSString *)需要手动释放coreFoundation对象的内存
    // 2.(__bridge_transfer NSString *)将coreFoundation的内存交给foundation对象管理,不需要手动释放内存
    NSString *firstName = (__bridge_transfer NSString *)firstname;
    NSString *lastName = (__bridge NSString *)(lastname);
    
    NSString *string = [NSString stringWithFormat:@"%@%@",lastName,firstName];
    
    CFRelease(lastname);
//    string = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    NSLog(@"string is %@",string);
    
    
    // 获取电话号码
    ABMutableMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i =0; i < ABMultiValueGetCount(phones); i++) {
        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        NSLog(@"label : %@, value : %@",phoneLabel, phoneValue);
    }
    
    // 注意释放不再使用对象
    CFRelease(phones);
    
//    NSMutableArray *phones = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
//        
//        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
//        
//        [phones addObject:aPhone];
//        
//    }
//    NSString *mobileNo = [phones objectAtIndex:0];
//    mobileNo = [mobileNo stringByReplacingOccurrencesOfString:@"+86" withString:@""];
//    mobileNo = [mobileNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    _name.text = string;
//    _mobile.text = mobileNo;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 选中联系人详情中的某个属性时候调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
}

@end
