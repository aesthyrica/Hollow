//
//  NSData+BH.m
//  Hollow
//
//  Created by BandarHelal on 27/12/1440 AH.
//

#import "NSData+BH.h"


@implementation Data

+ (NSInteger)year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    return [components year];
}

+ (NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    return [components day];
}
+ (NSInteger)month {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    return [components month];
}

@end
