//
//  GameConfig.h
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright DibiStore 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController

#define kRows 20
#define kColumns 30

#define kCellWidth 15

#define kXOffset 10
#define kYOffset 15

#define kMoveUp 1
#define kMoveRight 2
#define kMoveDown 3
#define kMoveLeft 4

#endif // __GAME_CONFIG_H