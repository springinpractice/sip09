package com.springinpractice.ch09.comment.service;

import java.util.Date;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch09.comment.model.Comment;
import com.springinpractice.web.WebUtils;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Service
@Transactional(
	propagation = Propagation.REQUIRED,
	isolation = Isolation.DEFAULT,
	readOnly = true)
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
	@Transactional(
		propagation = Propagation.REQUIRED,
		isolation = Isolation.DEFAULT,
		readOnly = false)
	public void postComment(final Comment comment, final PostCommentCallback callback) {
		prepareComment(comment);
		callback.post(comment);
		mailSender.sendNotificationEmail(comment);
	}

	private void prepareComment(final Comment comment) {
		comment.setWeb(WebUtils.cleanupWebUrl(comment.getWeb()));
		comment.setDateCreated(new Date());
		comment.setHtmlText(textFilter.filter(comment.getMarkdownText()));
	}
}
