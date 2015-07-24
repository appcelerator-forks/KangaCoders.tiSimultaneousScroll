package com.kangacoders.tisimultaneousscroll;

import java.util.HashMap;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.util.TiConvert;
import org.appcelerator.titanium.view.TiUIView;
import android.view.View;

public class KangaScrollView extends TiUIView {
	private static final String TAG = "KangaScrollView";
	private int offsetX = 0, offsetY = 0;

	public KangaScrollView(KangaScrollViewProxy kangaScrollViewProxy) {
		super(kangaScrollViewProxy);
		getLayoutParams().autoFillsHeight = true;
		getLayoutParams().autoFillsWidth = true;
		Kanga2DScrollView view = new Kanga2DScrollView(kangaScrollViewProxy.getActivity(), kangaScrollViewProxy);
		setNativeView(view);
	}

	public void scrollTo(int x, int y) {
		getNativeView().scrollTo(x, y);
		getNativeView().computeScroll();
	}

	public void setContentOffset(int x, int y) {
		KrollDict offset = new KrollDict();
		offsetX = x;
		offsetY = y;
		offset.put(TiC.EVENT_PROPERTY_X, offsetX);
		offset.put(TiC.EVENT_PROPERTY_Y, offsetY);
		getProxy().setProperty(TiC.PROPERTY_CONTENT_OFFSET, offset);
	}

	public void setContentOffset(Object hashMap) {
		if (hashMap instanceof HashMap) {
			HashMap contentOffset = (HashMap) hashMap;
			offsetX = TiConvert.toInt(contentOffset, TiC.PROPERTY_X);
			offsetY = TiConvert.toInt(contentOffset, TiC.PROPERTY_Y);
			setContentOffset(offsetX, offsetY);
		} else {
			Log.e(TAG, "ContentOffset must be an instance of HashMap");
		}
	}

	@Override
	public void propertyChanged(String key, Object oldValue, Object newValue,
			KrollProxy proxy) {
		if (Log.isDebugModeEnabled()) {
			Log.d(TAG, "Property: " + key + " old: " + oldValue + " new: "
					+ newValue, Log.DEBUG_MODE);
		}
		if (key.equals(TiC.PROPERTY_CONTENT_OFFSET)) {
			setContentOffset(newValue);
			scrollTo(offsetX, offsetY);
		}
		super.propertyChanged(key, oldValue, newValue, proxy);
	}

	@Override
	public void processProperties(KrollDict d) {
		if (d.containsKey(TiC.PROPERTY_CONTENT_OFFSET)) {
			Object offset = d.get(TiC.PROPERTY_CONTENT_OFFSET);
			setContentOffset(offset);
		}

		super.processProperties(d);
	}
}
