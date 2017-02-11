#import "SPARCDemo.h"

@implementation SPARCDemo

// If we specify `nonnull` on any type, we needn't consider the cases it could be nil
+ (void)printString:(nonnull NSString *)str {
  NSLog(@"%@",str);
}

/* If we are okay with str being nil, we may specify `nullable` but then must test it; Objective-C
 *  doesn't do this for us (i.e. calling printString with a nil value will not cause warning/error).
 */
+ (void)screenPrint:(nullable NSString *)str {
  // if str not nil, we may call a function requiring a nonnull pointer
  if (str) [SPARCDemo printString:str];
  // otherwise we do nothing
}

@end
