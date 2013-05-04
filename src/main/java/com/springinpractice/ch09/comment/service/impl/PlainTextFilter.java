/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.service.impl;

import com.springinpractice.ch09.comment.service.TextFilter;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public final class PlainTextFilter implements TextFilter {
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch09.comment.service.TextFilter#filter(java.lang.String)
	 */
	@Override
	public String filter(String text) {
		return text.replace("&", "&amp;")
			.replace("<", "&lt;")
			.replace(">", "&gt;")
			.replace("\n", "<br />");
	}
}
