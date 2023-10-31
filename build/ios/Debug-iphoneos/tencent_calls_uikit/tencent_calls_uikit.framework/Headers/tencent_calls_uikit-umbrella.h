#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CallsUikitPlugin.h"
#import "NSObject+Extension.h"

FOUNDATION_EXPORT double tencent_calls_uikitVersionNumber;
FOUNDATION_EXPORT const unsigned char tencent_calls_uikitVersionString[];

