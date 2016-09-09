//
//  CarriersViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CarriersViewController.h"
#import "MyContactList.h"
@interface CarriersViewController ()@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dayoftheweek;
@property (weak, nonatomic) IBOutlet UILabel *monthandyear;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twBtnLayout;

@end

@implementation CarriersViewController







- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    [[MyContactList sharedContacts]fetchAllContacts];
    // Do any additional setup after loading the view.
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
//    [formatter setDateFormat:@" YYYY年 M月 d日(eeee) HH:mm:ss"];
    // Date to string
    NSDate *now = [NSDate date];
    
    
    [formatter setDateFormat:@"MM/yyyy"];
   NSString* MonthandYear = [formatter stringFromDate:now];
    NSLog(@"%@",MonthandYear);
 
    
    [formatter setDateFormat:@"cccc"];
     NSString *currentDateStringfordayoftheweek = [formatter stringFromDate:now];

     [formatter setDateFormat:@"d"];
     NSString *currentDateStringforDay= [formatter stringFromDate:now];


    _date.text=currentDateStringforDay;
    _dayoftheweek.text=currentDateStringfordayoftheweek;
    _monthandyear.text=MonthandYear;


    self.bottomLayout.constant =  [UIScreen mainScreen].bounds.size.height * 0.4;
    self.twBtnLayout.constant= [UIScreen mainScreen].bounds.size.height * 0.3;
}

-(void)viewWillAppear:(BOOL)animated{
//    
//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{self.TWimage.alpha = 0.0;} completion:^(BOOL finished){ self.TWimage.transform= ; }];

}


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
