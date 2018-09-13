//
//  NSString+GBKEcoding.h
//  DYTT
//
//  Created by Ruite Chen on 2018/9/12.
//  Copyright © 2018年 乐刷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(GBKEcoding)
+ (NSString *)GB18030String:(NSData *)sender;
@end
