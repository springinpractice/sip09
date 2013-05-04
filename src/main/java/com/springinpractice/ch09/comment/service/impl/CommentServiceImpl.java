/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.service.impl;

import java.util.Date;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.springinpractice.ch09.comment.model.Comment;
import com.springinpractice.ch09.comment.service.CommentService;
import com.springinpractice.ch09.comment.service.PostCommentCallback;
import com.springinpractice.ch09.comment.service.TextFilter;
import com.springinpractice.web.WebUtils;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Service
public class CommentServiceImpl implements CommentService {
	@Inject private TextFilter textFilter;
	@Inject private CommentMailSender mailSender;
	
	public TextFilter getTextFilter() { return textFilter; }

	public void setTextFilter(TextFilter filter) { this.textFilter = filter; }
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch09.comment.service.CommentService#postComment
	 * (com.springinpractice.ch09.comment.model.Comment, com.springinpractice.ch09.comment.service.PostCommentCallback)
	 */
	@Override
	public void postComment(final Comment comment, final PostCommentCallback callback) {
		prepareComment(comment);
		callback.post(comment);
		mailSender.sendNotificationEmail(comment);
	}

	private void prepareComment(final Comment comment) {
		comment.setWeb(WebUtils.cleanupWebUrl(comment.getWeb()));
		comment.setDateCreated(new Date());
		comment.setText(textFilter.filter(comment.getText()));
	}
}
