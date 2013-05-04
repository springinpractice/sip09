/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.dao.hbn;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import com.springinpractice.ch09.article.dao.ArticlePageDao;
import com.springinpractice.ch09.article.model.Article;
import com.springinpractice.ch09.article.model.ArticlePage;
import com.springinpractice.dao.hibernate.AbstractHbnDao;

@Repository
public class HbnArticlePageDao extends AbstractHbnDao<ArticlePage> implements ArticlePageDao {
	
	/* (non-Javadoc)
	 * @see com.springinpractice.ch09.article.dao.ArticlePageDao#getByArticleNameAndPageNumber(java.lang.String, int)
	 */
	@Override
	public ArticlePage getByArticleNameAndPageNumber(String articleName, int pageNumber) {
		Query q = getSession()
			.getNamedQuery("getArticlePageByArticleNameAndPageNumber")
			.setParameter("articleName", articleName)
			.setParameter("pageNumber", pageNumber);
		
		Object[] result = (Object[]) q.uniqueResult();
		ArticlePage page = (ArticlePage) result[0];
		int numPages = (Integer) result[1];
		
		Article article = page.getArticle();
		article.setCalculateStats(false);
		article.setNumPages(numPages);
		
		return page;
	}
}