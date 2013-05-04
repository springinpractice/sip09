/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@NamedQuery(
	name = "getArticlePageByArticleNameAndPageNumber",
	query = "select page, size(page.article.pages)" +
		" from ArticlePage page" +
		" where page.article.name = :articleName and page.pageNumber = :pageNumber")
@Entity
@Table(name = "article_page")
public class ArticlePage {
	private Long id;
	private Article article;
	private int pageNumber;
	private String title;
	private String body;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@ManyToOne
	@JoinColumn(name = "article_id", nullable = false)
	public Article getArticle() { return article; }
	
	public void setArticle(Article article) { this.article = article; }
	
	@Column(name = "page_number")
	public int getPageNumber() { return pageNumber; }
	
	public void setPageNumber(int pageNumber) { this.pageNumber = pageNumber; }
	
	@Column(name = "title")
	public String getTitle() { return title; }
	
	public void setTitle(String title) { this.title = title; }
	
	@Column(name = "body")
	public String getBody() { return body; }
	
	public void setBody(String body) { this.body = body; }
}
