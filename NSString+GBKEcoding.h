//
//  NSString+GBKEcoding.h
//  DYTT
//
//  Created by Matt on 2018/9/12.
//  Copyright © 2018年 HJ-CAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(GBKEcoding)
+ (NSString *)GB18030String:(NSData *)sender;
@end
