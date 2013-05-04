/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.service;

import com.springinpractice.ch09.comment.model.Comment;

/**
 * Comment service interface.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public interface CommentService {

	/**
	 * Template method for posting a comment. Prepares the comment for storage (e.g., input sanitization, setting
	 * creation dates, etc.) before invoking the callback to do the actual work of saving the comment. Using a callback
	 * facilitates the integration of the comment engine with apps that want to use it, such as blogs and other
	 * publishing websites, product catalogs and so forth.
	 * 
	 * @param comment comment
	 * @param callback callback
	 */
	void postComment(Comment comment, PostCommentCallback callback);
}
