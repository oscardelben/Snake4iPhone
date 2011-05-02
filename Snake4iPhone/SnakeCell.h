//
//  SnakeCell.h
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SnakeCell : NSObject {
    
}

@property (nonatomic, retain) SnakeCell *parentCell;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int row;

- (CCSprite *)spriteRepresentation;

@end
