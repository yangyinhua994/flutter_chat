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

#import "DPAudioPlayer.h"
#import "DPAudioRecorder.h"
#import "FlutterPluginRecordPlugin.h"
#import "JX_GCDTimerManager.h"

FOUNDATION_EXPORT double flutter_plugin_record_plusVersionNumber;
FOUNDATION_EXPORT const unsigned char flutter_plugin_record_plusVersionString[];

