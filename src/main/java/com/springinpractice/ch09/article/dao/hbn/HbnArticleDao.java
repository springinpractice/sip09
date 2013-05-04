/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.dao.hbn;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.springinpractice.ch09.article.dao.ArticleDao;
import com.springinpractice.ch09.article.model.Article;
import com.springinpractice.dao.hibernate.AbstractHbnDao;
import com.springinpractice.util.NumberUtils;

@Repository
public class HbnArticleDao extends AbstractHbnDao<Article> implements ArticleDao {
	
	/* (non-Javadoc)
	 * @see com.springinpractice.dao.hibernate.AbstractHbnDao#getAll()
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<Article> getAll() {
		Query q = getSession().getNamedQuery("getArticlesWithNumPages");
		List<Object[]> results = (List<Object[]>) q.list();
		List<Article> articles = new ArrayList<Article>();
		for (Object[] result : results) {
			Article article = (Article) result[0];
			int numPages = NumberUtils.asInt((Long) result[1]);
			article.setCalculateStats(false);
			article.setNumPages(numPages);
			articles.add(article);
		}
		return articles;
	}
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch09.article.dao.ArticleDao#getByName(java.lang.String)
	 */
	@Override
	public Article getByName(String name) {
		return (Article) getSession()
			.getNamedQuery("getArticleByName")
			.setParameter("name", name)
			.uniqueResult();
	}
}
