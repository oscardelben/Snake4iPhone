//
//  AppDelegate.h
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright DibiStore 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
