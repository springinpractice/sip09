/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.dao;

import com.springinpractice.ch09.article.model.Article;
import com.springinpractice.dao.Dao;

public interface ArticleDao extends Dao<Article> {
	
	Article getByName(String name);
}
