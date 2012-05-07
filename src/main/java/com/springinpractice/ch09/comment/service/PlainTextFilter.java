package com.springinpractice.ch09.comment.service;

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
