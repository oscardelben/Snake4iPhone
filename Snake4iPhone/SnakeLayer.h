//
//  SnakeLayer.h
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface SnakeLayer : CCLayer {
}

@property (nonatomic, retain) NSMutableArray *snake;
@property (nonatomic, retain) NSMutableArray *food;
@property (nonatomic, assign) int direction;
@property (nonatomic, assign) BOOL gameRunning;

+(CCScene *) scene;

@end
