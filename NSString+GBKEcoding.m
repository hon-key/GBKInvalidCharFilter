//
//  NSString+GBKEcoding.m
//  DYTT
//
//  Created by Matt on 2018/9/12.
//  Copyright © 2018年 HJ-CAI. All rights reserved.
//

#import "NSString+GBKEcoding.h"

@implementation NSString(GBKEcoding)

+ (NSString *)GB18030String:(NSData *)data {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:enc] ?:
           [[NSString alloc] initWithData:[self filterInvalidString:data] encoding:enc];
}


+ (NSData *)filterInvalidString:(NSData *)data {
    if ([data length] == 0) {
        return data;
    }
    NSMutableData *resultData = [NSMutableData dataWithCapacity:data.length];
    const Byte *bytes = [data bytes];
    const Byte *indexBytes = bytes;
    while (indexBytes < bytes + data.length) {
        NSData *parsedData;
        if ((parsedData = [self parseASCII:indexBytes])) {
            [resultData appendData:parsedData];
            indexBytes += 1;
        }else if (indexBytes + 2 > bytes + data.length) {
            break;
        }else if ((parsedData = [self parseDoubleWord:indexBytes])) {
            [resultData appendData:parsedData];
            indexBytes += 2;
        }else if (indexBytes + 4 > bytes + data.length) {
            break;
        }else if ((parsedData = [self parseQuadraWord:indexBytes])) {
            [resultData appendData:parsedData];
            indexBytes += 4;
        }else {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            [resultData appendData:[@"?" dataUsingEncoding:enc]];
            indexBytes += 1;
        }
    }
    return resultData;
}

+ (NSData *)parseASCII:(const Byte *)byte {
    if (*byte >= 0 && *byte <= (Byte)0x7f) {
        return [NSData dataWithBytes:byte length:1];
    }
    return nil;
}

+ (NSData *)parseDoubleWord:(const Byte *)byte {
    Byte firstByte = *byte;
    if (firstByte >= (Byte)0x81 && firstByte <= (Byte)0xfe) {
        Byte secondByte = *(byte+1);
        if (secondByte >= (Byte)0x40 && secondByte <= (Byte)0xfe && secondByte != (Byte)0x7f) {
            Byte validBytes[] = {firstByte, secondByte};
            CFStringRef cStr = CFStringCreateWithBytes(kCFAllocatorDefault,validBytes,2,kCFStringEncodingGB_18030_2000,false);
            return cStr ? [NSData dataWithBytes:byte length:2] : nil;
        }
    }
    return nil;
}

+ (NSData *)parseQuadraWord:(const Byte *)byte {
    Byte firstByte = *byte;
    if (firstByte >= (Byte)0x81 && firstByte <= (Byte)0xfe) {
        Byte secondByte = *(byte+1);
        if (secondByte >= (Byte)0x30 && secondByte <= (Byte)0x39) {
            Byte thirdByte = *(byte+2);
            if (thirdByte >= (Byte)0x81 && thirdByte <= (Byte)0xfe) {
                Byte fourthByte = *(byte+3);
                if (fourthByte >= (Byte)0x30 && fourthByte <= (Byte)0x39) {
                    Byte validBytes[] = {firstByte, secondByte, thirdByte, fourthByte};
                    CFStringRef cStr = CFStringCreateWithBytes(kCFAllocatorDefault,validBytes,4,kCFStringEncodingGB_18030_2000,false);
                    return cStr? [NSData dataWithBytes:byte length:4] : nil;
                }
            }
        }
    }
    return nil;
}



@end
