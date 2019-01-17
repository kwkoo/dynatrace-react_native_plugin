//
//  DynatraceModule.m
//  Parking
//
//  Created by Koo Kin-Wai on 2017-09-11.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "DynatraceModule.h"
#import <Foundation/Foundation.h>

@implementation DynatraceModule

NSMutableDictionary *actionDict;

RCT_EXPORT_MODULE(DynatraceUEM);

- (id) init
{
  self = [super init];
  if (self) {
    actionDict = [[NSMutableDictionary alloc] init];
  }
  return self;
}

RCT_EXPORT_METHOD(enterAction:(NSString *)name key:(nonnull NSNumber *)key)
{
  [self newAction:name key:key parentAction:nil];
}

RCT_EXPORT_METHOD(enterActionWithParent:(NSString *)name key:(nonnull NSNumber *)key parentKey:(nonnull NSNumber *)parentKey)
{
  [self newAction:name key:key parentAction:[self getAction:parentKey]];
}

RCT_EXPORT_METHOD(leaveAction:(nonnull NSNumber *)key)
{
  DTXAction *action = [self getAction:key];
  if (action == nil) return;
  [action leaveAction];
  [actionDict removeObjectForKey:key];
}

RCT_EXPORT_METHOD(endVisit)
{
  [DTXAction endVisit];
}

RCT_EXPORT_METHOD(reportError:(NSString *)errorName errorCode:(nonnull NSNumber *)errorCode)
{
  DTXAction *action = [DTXAction enterActionWithName:@"Error"];
  [action reportErrorWithName:errorName errorValue:[errorCode intValue]];
  [action leaveAction];
}

RCT_EXPORT_METHOD(reportErrorInAction:(nonnull NSNumber *)key errorName:(NSString *)errorName errorCode:(nonnull NSNumber *)errorCode)
{
  DTXAction *action = [self getAction:key];
  if (action == nil) return;
  [action reportErrorWithName:errorName errorValue:[errorCode intValue]];
}

RCT_EXPORT_METHOD(reportValue:(NSNumber *)key valueName:(NSString *)valueName errorCode:(NSString *)value)
{
  DTXAction *action = [self getAction:key];
  if (action == nil) return;
  [action reportValueWithName:valueName stringValue:value];
}

RCT_REMAP_METHOD(getRequestTag, getRequestTagWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
  resolve([Dynatrace getRequestTagValueForURL:nil]);
}

RCT_EXPORT_METHOD(identifyUser:(NSString *)user)
{
  [Dynatrace identifyUser:user];
}

- (void) newAction:(NSString *)name key:(NSNumber *)key parentAction:(DTXAction *)parentAction
{
  DTXAction *action = [DTXAction enterActionWithName:name parentAction:parentAction];
  if (action)
  {
    [actionDict setObject:action forKey:key];
  }
}

- (DTXAction *) getAction:(NSNumber *)key
{
  return [actionDict objectForKey:key];
}

  
+ (BOOL)requiresMainQueueSetup
{
  return YES;
}
  
@end

