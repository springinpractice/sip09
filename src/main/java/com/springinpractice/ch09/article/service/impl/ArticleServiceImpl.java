/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.service.impl;

import java.util.List;

import javax.inject.Inject;

import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.springinpractice.ch09.article.dao.ArticleDao;
import com.springinpractice.ch09.article.dao.ArticlePageDao;
import com.springinpractice.ch09.article.model.Article;
import com.springinpractice.ch09.article.model.ArticlePage;
import com.springinpractice.ch09.article.service.ArticleService;
import com.springinpractice.ch09.comment.model.Comment;
import com.springinpractice.ch09.comment.service.CommentService;
import com.springinpractice.ch09.comment.service.PostCommentCallback;

@Service
@Transactional(
	propagation = Propagation.REQUIRED,
	isolation = Isolation.DEFAULT,
	readOnly = true)
public class ArticleServiceImpl implements ArticleService {
	@Inject private ArticleDao articleDao;
	@Inject private ArticlePageDao pageDao;
	@Inject private CommentService commentService;
	
	public List<Article> getAllArticles() { return articleDao.getAll(); }
	
	public ArticlePage getArticlePage(String articleName, int pageNumber) {
		ArticlePage page = pageDao.getByArticleNameAndPageNumber(articleName, pageNumber);
		Hibernate.initialize(page.getArticle().getComments());
		return page;
	}
	
	@Transactional(
		propagation = Propagation.REQUIRED,
		isolation = Isolation.DEFAULT,
		readOnly = false)
	public void postComment(final String articleName, Comment comment) {
		commentService.postComment(comment, new PostCommentCallback() {
			public void post(Comment comment) {
				Article article = articleDao.getByName(articleName);
				article.getComments().add(comment);
				articleDao.update(article);
			}
		});
	}
}
