var win = Ti.UI.createWindow({
    backgroundColor : 'white',
    layout : "vertical"
});
var label_1 = Ti.UI.createLabel({
    text : "bla",
    width : 100,
    top : 0,
    left : 10
});
var line_1 = Ti.UI.createView({
    width : 2,
    height : Ti.UI.FILL,
    top : 0,
    left : 320,
    backgroundColor : "red"
});
var scrollview_1 = Ti.UI.createScrollView({
    height : 50,
    width : Ti.UI.FILL,
    contentWidth : 640,
    top : 100,
    backgroundColor : "green",
    contentOffset : {
        x : 0,
        y : 0
    },
    scrollingEnabled : true
});
scrollview_1.add(label_1);
scrollview_1.add(line_1);
win.add(scrollview_1);

var label_2 = Ti.UI.createLabel({
    text : "bla",
    width : 100,
    top : 0,
    left : 30
});
var line_2 = Ti.UI.createView({
    width : 2,
    height : Ti.UI.FILL,
    top : 0,
    left : 320,
    backgroundColor : "red"
});
var scrollview_2 = Ti.UI.createScrollView({
    height : 50,
    width : Ti.UI.FILL,
    contentWidth : 640,
    contentHeight : 50,
    top : 0,
    backgroundColor : "blue",
    contentOffset : {
        x : 0,
        y : 0
    },
    scrollingEnabled : true
});
scrollview_2.add(label_2);
scrollview_2.add(line_2);
win.add(scrollview_2);

win.open();

var tiSimultaneousScroll = require('com.kangacoders.tiSimultaneousScroll');
Ti.API.info("module is => " + tiSimultaneousScroll);

tiSimultaneousScroll.bind_scrolls({
    scroll_views : [scrollview_1, scrollview_2],
    floating_labels : [label_1, label_2],
    disableHorizontal : false,
    disableVertical : true
});

setTimeout(function() {
    tiSimultaneousScroll.scroll_to({
        x : 90,
        y : 0,
        animate : true
    });
}, 1000);
