#import <Foundation/Foundation.h>

/**
 *  This class is designed to demonstrate how to write Objective-C
 *    framework code such that it may be imported to a Swift app.
 */
@interface SPARCDemo : NSObject

+ (void)printString:(nonnull NSString *)str;

+ (void)screenPrint:(nullable NSString *)str;

@end
