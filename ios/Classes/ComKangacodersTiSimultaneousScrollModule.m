/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComKangacodersTiSimultaneousScrollModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComKangacodersTiSimultaneousScrollModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"92071c8d-1512-4ed1-8e2e-b814aa95f3f4";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.kangacoders.tiSimultaneousScroll";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)unbind_scroll_views
{
    if (scroll_views) {
        for (TiUIScrollViewProxy* proxy in scroll_views) {
            [proxy forgetSelf];
        }
        RELEASE_TO_NIL(scroll_views);
    }
    if (floating_labels) {
        for (TiUILabelProxy* proxy in floating_labels) {
            [proxy forgetSelf];
        }
        RELEASE_TO_NIL(floating_labels);
    }
}

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

-(UILabel*)to_label:(id)view
{
    UILabel* label = nil;
    if ([view respondsToSelector:@selector(label)]) {
        label = [view label];
    }
    return label;
}

-(UIScrollView*)to_scroll_view:(id)view
{
    UIScrollView* scrollView = nil;
    if ([view respondsToSelector:@selector(scrollView)]) {
        scrollView = [view scrollView];
    }
    else if ([view respondsToSelector:@selector(scrollview)]) {
        scrollView = [view scrollview];
    }
    return scrollView;
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)bind_scrolls:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    NSArray *_scroll_views = [args valueForKey:(@"scroll_views")];
    NSArray *_floating_labels = [args valueForKey:(@"floating_labels")];

    ENSURE_ARRAY(_scroll_views);
    ENSURE_ARRAY(_floating_labels);
    
    [self unbind_scroll_views];
    scroll_views = [[NSMutableArray alloc] initWithCapacity:[_scroll_views count]];
    floating_labels = [[NSMutableArray alloc] initWithCapacity:[_floating_labels count]];
    
    for (TiViewProxy* proxy in _scroll_views) {
        [proxy rememberSelf];
        id view = proxy.view;
        UIScrollView* scroll = [self to_scroll_view:view];
        scroll.delegate = self;
        [scroll_views addObject:proxy];
    }
    
    for (TiViewProxy* proxy in _floating_labels) {
        [proxy rememberSelf];
        id view = proxy.view;
        UILabel* label = [self to_label:view];
        [floating_labels addObject:proxy];
    }
    
    disable_horizontal = [TiUtils boolValue:@"disableHorizontal" properties:args];
    disable_vertical = [TiUtils boolValue:@"disableVertical" properties:args];
}

-(void)float_labels:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);

    for (TiViewProxy* proxy in floating_labels)
    {
        UILabel* label = [self to_label:proxy.view];
        float _left = [[args valueForKey:(@"x")] floatValue];
        if(_left < 0.0){
            _left = 0.0;
        }
        float _top = [[args valueForKey:(@"y")] floatValue];
        if(_top < 0.0){
            _top = 0.0;
        }
        
//        NSLog([NSString stringWithFormat:@"%f", _left]);
//        NSLog([NSString stringWithFormat:@"%f", _top]);
        
        [label setFrame:CGRectMake(_left, _top, label.frame.size.width, label.frame.size.height)];
    }

}

-(void)scroll_to:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    CGPoint point = CGPointMake([[args valueForKey:(@"x")] floatValue], [[args valueForKey:(@"y")] floatValue]);
    
    for (TiViewProxy* proxy in scroll_views)
    {
        id view = proxy.view;
        UIScrollView* scroll = [self to_scroll_view:view];
        if (scroll != controlling_scroll)
        {
            [scroll setContentOffset:point animated:[TiUtils boolValue:@"animate" properties:args]];
        }
    }
    
    [self float_labels:[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%f", point.x], @"x", [NSString stringWithFormat:@"%f", point.y], @"y", nil]];
}

#pragma UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scroll_view
{
    controlling_scroll = scroll_view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll_view
{
    if (scroll_view != controlling_scroll)
        return;
    
    float _horizontal = scroll_view.contentOffset.x;
    if(disable_horizontal)
        _horizontal = 0.0;
    
    float _vertical = scroll_view.contentOffset.y;
    if(disable_vertical)
        _vertical = 0.0;
    
    [self scroll_to:[NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"%f", _horizontal], @"x", [NSString stringWithFormat:@"%f", _vertical], @"y", nil]];
}

@end
