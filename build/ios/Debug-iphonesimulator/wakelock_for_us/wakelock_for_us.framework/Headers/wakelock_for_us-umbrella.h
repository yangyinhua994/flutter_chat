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

#import "messages.h"
#import "UIApplication+idleTimerLock.h"
#import "WakelockPluginForUS.h"

FOUNDATION_EXPORT double wakelock_for_usVersionNumber;
FOUNDATION_EXPORT const unsigned char wakelock_for_usVersionString[];

