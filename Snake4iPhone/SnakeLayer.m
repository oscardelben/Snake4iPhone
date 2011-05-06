//
//  SnakeLayer.m
//  Snake4iPhone
//
//  Created by Oscar Del Ben on 5/2/11.
//  Copyright 2011 DibiStore. All rights reserved.
//

#import "SnakeLayer.h"
#import "GameConfig.h"

#define kColumnIndex 0
#define kRowIndex    1
#define kSpriteIndex 2

@interface SnakeLayer (PrivateMethods)

- (void)resetGame;
- (void)advance:(ccTime)dt;
- (void)removeSnakeTail;
- (void)addSnakeCell:(int)column andRow:(int)row;
- (void)drawSnake;
- (void)addFood;
- (void)eatFood;
- (BOOL)eatingFood:(int)column andRow:(int)row;
- (BOOL)positionTaken:(int)column andRow:(int)row;
- (CCSprite *)snakeCell:(int)column row:(int)row;

@end

// Snake is an ordered array of the form:
// [[column, row, cell], [column, row, cell]]
// where column and row are the x and y coordinates, and cell is a pointer to the CCSprite (so that we can remove it later)

@implementation SnakeLayer

@synthesize snake;
@synthesize direction;
@synthesize food;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SnakeLayer *layer = [SnakeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    self = [super init];
    if (self) 
    {
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        
        self.isTouchEnabled = YES;
                
        [self resetGame];

        [self schedule:@selector(advance:) interval:kSnakeSpeed];
    }
    
    return self;
}

- (void)dealloc
{
    [snake release];
    [food release];
    [super dealloc];
}

#pragma mark -

- (CCSprite *)snakeCell:(int)column row:(int)row
{
    CCSprite *sprite = [CCSprite spriteWithFile:@"snake-body.png"];
    
    float x = kCellWidth * column + kXOffset;
    float y = kCellWidth * row + kYOffset;
    
    sprite.anchorPoint = ccp(0, 0);
    sprite.position = CGPointMake(x, y);
    
    return sprite;
}

- (void)resetGame
{    
    self.snake = [NSMutableArray array];
    
    self.direction = kMoveRight;
        
    [self drawSnake];
}

- (void)drawSnake
{
    // Add a new cell in the new direction
    int column;
    int row;
    
    if ([snake count] > 0) 
    {
        column = [[[snake objectAtIndex:0] objectAtIndex:kColumnIndex] intValue];
        row = [[[snake objectAtIndex:0] objectAtIndex:kRowIndex] intValue];
    }
    else // empty snake
    {
        column = 3; // put into a configuration
        row = 5; // put into a configuration
    }


    // Add a new cell in the direction
    switch (self.direction) {
        case kMoveUp:
            column = column;
            row = row + 1;
            break;
        
        case kMoveRight:
            column = column + 1;
            row = row;
            break;
            
        case kMoveDown:
            column = column;
            row = row - 1;
            break;
            
        case kMoveLeft:
            column = column - 1;
            row = row;
            break;
            
        default:
            NSLog(@"direction unknown: %@", self.direction);
            break;
    }
    
    // TODO: check if the new position is valid
    
    // Draw the new head
    [self addSnakeCell:column andRow:row];

    // If the snake is not eating, we just remove its tail to simulate that it's moving
    if ([self eatingFood:column andRow:row]) 
    {
        [self eatFood];
    }
    else
    {
        [self removeSnakeTail];
    }
    
    [self addFood];
}

- (BOOL)positionTaken:(int)column andRow:(int)row
{
    BOOL result = NO;
    
    for (int i = 0; i < [[self snake] count]; i++) 
    {
        NSArray *columnArray = [self.snake objectAtIndex:i];
        
        int currentColumn = [[columnArray objectAtIndex:kColumnIndex] intValue];
        int currentRow = [[columnArray objectAtIndex:kRowIndex] intValue];
        
        if (column == currentColumn && row == currentRow) 
        {
            result = YES;
            break;
        }
    }
    
    return result;
}

- (void)addFood
{
    // If there's already food, return
    if (self.food) {
        return;
    }

    // positions is an array of possible positions of the form [[column, row], [column, row], ...]
    
    NSMutableArray *positions = [NSMutableArray array];
    
    for (int i = 0; i < kColumns; i++) 
    {
        for (int j = 0; j < kRows; j++) 
        {
            if (![self positionTaken:i andRow:j]) {
                [positions addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:i], [NSNumber numberWithInt:j], nil]];
            }
        }
    }
    
    // TODO: show a message or something
    
    if ([positions count] > 0) 
    {
        int randomIndex = arc4random() % [positions count];
        NSArray *position = [positions objectAtIndex:randomIndex];
        
        int column = [[position objectAtIndex:kColumnIndex] intValue];
        int row = [[position objectAtIndex:kRowIndex] intValue];
        
        // Food is represented through an array of the format [column, row, sprite]
        CCSprite *cell = [self snakeCell:column row:row];
        
        self.food = [NSArray arrayWithObjects:[NSNumber numberWithInt:column], [NSNumber numberWithInt:row], cell, nil];
        
        [self addChild:cell];
    }
    else
    {
        NSLog(@"Game ended.");
    }
}

- (void)removeSnakeTail
{
    // Only remove if there's more than one block
    if ([snake count] > 1) {
        CCSprite *snakeTailSprite = (CCSprite *)[[snake lastObject] objectAtIndex:kSpriteIndex];
        [snakeTailSprite removeFromParentAndCleanup:YES];
        
        int lastIndex = [snake count] - 1;
        [snake removeObjectAtIndex:lastIndex];
    }
}

- (void)addSnakeCell:(int)column andRow:(int)row
{
    CCSprite *cell = [self snakeCell:column row:row];
    
    // Add information to the snake array
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:column], [NSNumber numberWithInt:row], cell, nil];
    [self.snake insertObject:array atIndex:0];
    
    // Draw the cell
    [self addChild:cell];
}

- (BOOL)eatingFood:(int)column andRow:(int)row
{
    int foodColumn = [[self.food objectAtIndex:kColumnIndex] intValue];
    int foodRow = [[self.food objectAtIndex:kRowIndex] intValue];
    
    return foodColumn == column && foodRow == row;
}
                                
- (void)eatFood
{
    CCSprite *sprite = [self.food objectAtIndex:kSpriteIndex];
    [sprite removeFromParentAndCleanup:YES];
    
    // Set food to nil in order to generate a new one.
    self.food = nil;
    
    // TODO: if all the rows and column have been fille dup we should display a win message.
}

#pragma mark -

- (void)advance:(ccTime)dt
{
    [self drawSnake];    
}

#pragma mark -

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
        
    // TODO: this is incorrect of course
    CCSprite *headCell = (CCSprite *)[[snake objectAtIndex:0] objectAtIndex:kSpriteIndex];
    
    CGPoint cellCenter = CGPointMake(headCell.position.x + kCellWidth / 2, headCell.position.y + kCellWidth / 2);

    BOOL up = location.y > cellCenter.y;
    BOOL right = location.x > cellCenter.x;

    CGPoint normalizedLocation = CGPointMake(abs(location.x - cellCenter.x), abs(location.y - cellCenter.y));
    
    if (up) 
    {
        if (right)
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                if (self.direction != kMoveDown)
                    self.direction = kMoveUp;
            }
            else
            {
                if (self.direction != kMoveLeft)
                    self.direction = kMoveRight;
            }
        
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                if (self.direction != kMoveDown)
                    self.direction = kMoveUp;
            }
            else
            {
                if (self.direction != kMoveRight)
                    self.direction = kMoveLeft;
            }
        }
    } else
    {
        if (right)
        {

            if (normalizedLocation.y > normalizedLocation.x)
            {
                if (self.direction != kMoveUp)
                    self.direction = kMoveDown;
            }
            else
            {
                if (self.direction != kMoveLeft)
                    self.direction = kMoveRight;
            }
            
        } else
        {
            
            if (normalizedLocation.y > normalizedLocation.x)
            {
                if (self.direction != kMoveUp)
                    self.direction = kMoveDown;
            }
            else
            {
                if (self.direction != kMoveRight)
                    self.direction = kMoveLeft;
            }
        }
    }
    
}


@end
