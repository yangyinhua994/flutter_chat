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

#import "PlainNotificationTokenPlugin.h"

FOUNDATION_EXPORT double plain_notification_token_for_usVersionNumber;
FOUNDATION_EXPORT const unsigned char plain_notification_token_for_usVersionString[];

