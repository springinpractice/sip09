/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.service;

import java.util.List;

import com.springinpractice.ch09.article.model.Article;
import com.springinpractice.ch09.article.model.ArticlePage;
import com.springinpractice.ch09.comment.model.Comment;

public interface ArticleService {

	/**
	 * Returns all articles. The comments are not loaded.
	 * 
	 * @return all articles, but without comments
	 */
	List<Article> getAllArticles();
	
	ArticlePage getArticlePage(String articleName, int pageNumber);
	
	void postComment(String articleName, Comment comment);
}
