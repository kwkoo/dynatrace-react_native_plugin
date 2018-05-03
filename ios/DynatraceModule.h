//
//  DynatraceModule.h
//  Parking
//
//  Created by Koo Kin-Wai on 2017-09-11.
//  Copyright © 2017 Facebook. All rights reserved.
//

#ifndef DynatraceModule_h
#define DynatraceModule_h

#import <React/RCTBridgeModule.h>
#import "Dynatrace.h"


@interface DynatraceModule : NSObject <RCTBridgeModule>
- (void) newAction:(NSString *)name key:(NSNumber *)key parentAction:(DTXAction *)parentAction;
- (DTXAction *) getAction:(NSNumber *)key;
@end

#endif /* DynatraceModule_h */
