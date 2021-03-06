//
//  STTVCellView.m
//  STTVTableView
//
//  Created by 石破天 on 2017/11/3.
//  Copyright © 2017年 stone. All rights reserved.
//

#import "STTVCellView.h"
#import <React/RCTComponent.h>

@interface STTVCellView ()

@property (nonatomic, copy) RCTBubblingEventBlock onUpdate;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation STTVCellView

- (instancetype)init {
    if (self = [super init]) {
        self.jsRenderedRow = -1;
        self.nativeRow = -1;
    }
    return self;
}

- (void)setJsRenderedRow:(NSInteger)jsRenderedRow {
    _jsRenderedRow = jsRenderedRow;
    if (self.nativeRow == -1) {
        self.nativeRow = jsRenderedRow;
    }
    if (self.lastTime) {
        NSLog(@"time stamp:%lf", [[NSDate date] timeIntervalSince1970] - self.lastTime);
    }
}

- (void)reactSetFrame:(CGRect)frame{
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)updateToRow:(NSInteger)row{
    self.nativeRow = row;
    self.lastTime = [[NSDate date] timeIntervalSince1970];
    [self waitForRefresh];
}

- (void) waitForRefresh{
    if (!self.shouldForceReload && self.nativeRow == self.jsRenderedRow) {
        return;
    }
    if (self.jsFree) {
        self.jsFree = NO;
        self.shouldForceReload = NO;
        self.onUpdate(@{@"row":@(self.nativeRow)});
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self waitForRefresh];
        });
    }
}


@end
