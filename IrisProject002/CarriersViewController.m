//
//  CarriersViewController.m
//  IrisProject001
//
//  Created by 沈秋蕙 on 2016/7/27.
//  Copyright © 2016年 iris shen. All rights reserved.
//

#import "CarriersViewController.h"

@interface CarriersViewController ()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dayoftheweek;
@property (weak, nonatomic) IBOutlet UILabel *monthandyear;
@property (weak, nonatomic) IBOutlet UIImageView *TWimage;
@property (weak, nonatomic) IBOutlet UIImageView *CHTimage;


@end

@implementation CarriersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [formatter setDateFormat:@" YYYY年 M月 d日(eeee) HH:mm:ss"];
    // Date to string
    NSDate *now = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:now];
    NSLog(@"currentDate=%@", currentDateString);
    NSString *currentDateStringforYear = [currentDateString substringWithRange:NSMakeRange(1,4)];
    NSString *currentDateStringforMonth = [currentDateString substringWithRange:NSMakeRange(6,2)];
    NSString* MonthandYear = [NSString stringWithFormat:@"%@/%@",currentDateStringforMonth,currentDateStringforYear];
    NSString *currentDateStringforDay = [currentDateString substringWithRange:NSMakeRange(10,2)];
    
    //拉一下autolayout
    NSString *currentDateStringfordayoftheweek = [currentDateString substringWithRange:NSMakeRange(14,3)];
    _date.text=currentDateStringforDay;
    NSLog(@"currentDate=%@", MonthandYear);
    _dayoftheweek.text=currentDateStringfordayoftheweek;
    
//    [UIView animateWithDuration:(NSTimeInterval)
//                          delay:(NSTimeInterval)
//         usingSpringWithDamping:(CGFloat)
//          initialSpringVelocity:(CGFloat)
//                        options:(UIViewAnimationOptions)
//                     animations:^{}
//                     completion:^(BOOL finished) {}];

    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
//    [UIView animateWithDuration:1.0 animations:^{self.TWimage
//        = CGRectMake(self.TWimage.center.x +10 , self.TWimage.center.y+10)} completion:];

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
