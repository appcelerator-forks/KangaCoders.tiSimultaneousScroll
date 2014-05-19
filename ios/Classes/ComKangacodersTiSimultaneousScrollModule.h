/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "TiUIScrollViewProxy.h"
#import "TiUIScrollView.h"
#import "TiUIScrollableViewProxy.h"
#import "TiUIScrollableView.h"
#import "TiUILabelProxy.h"
#import "TiUILabel.h"

@interface ComKangacodersTiSimultaneousScrollModule : TiModule <UIScrollViewDelegate>
{
    NSMutableArray* scroll_views;
    NSMutableArray* floating_labels;
    UIScrollView* controlling_scroll;
    BOOL disable_horizontal;
    BOOL disable_vertical;
}

@end
