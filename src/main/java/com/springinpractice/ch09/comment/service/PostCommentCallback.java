package com.springinpractice.ch09.comment.service;

import com.springinpractice.ch09.comment.model.Comment;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public interface PostCommentCallback {
	
	void post(Comment comment);
}
