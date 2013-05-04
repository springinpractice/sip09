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

import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import com.springinpractice.ch09.comment.model.Comment;

// This is its own class instead of being part of CommentServiceImpl because proxying CommentServiceImpl with async
// functionality means that calls internal to the comment service will not hit the proxy layer.

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Component
public class CommentMailSender {
	@Inject private MailSender mailSender;
	@Inject private SimpleMailMessage commentMailMessage;

	public MailSender getMailSender() { return mailSender; }
	
	public void setMailSender(MailSender sender) { this.mailSender = sender; }
	
	public SimpleMailMessage getCommentMailMessage() { return commentMailMessage; }
	
	public void setCommentMailMessage(SimpleMailMessage message) { this.commentMailMessage = message; }
	
	/**
	 * Sends a notification e-mail to the system administrator indicating that the comment has been posted.
	 */
	@Async
	public void sendNotificationEmail(Comment comment) {
		SimpleMailMessage message = new SimpleMailMessage(commentMailMessage);
		message.setSentDate(new Date());
		message.setText(comment.getText());
		mailSender.send(message);
	}
}
