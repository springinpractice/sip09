/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.article.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.springinpractice.ch09.comment.model.Comment;
import com.springinpractice.ch09.comment.model.CommentTarget;

/**
 * Dummy article class to illustrate comment engine integration.
 */
@Entity
@Table(name = "article")
@NamedQueries({
	@NamedQuery(
		name = "getArticlesWithNumPages",
		query = "select article, count(page)" +
			" from Article as article" +
			" left outer join article.pages as page" +
			" group by article"),
	@NamedQuery(
		name = "getArticleByName",
		query = "from Article article where article.name = :name")
})
public final class Article {
	private Long id;
	private String name;
	private String category;
	private String title;
	private String author;
	private Date dateCreated;
	private String deck;
	private List<ArticlePage> pages = new ArrayList<ArticlePage>();
	private String description;
	private String keywords;
	private CommentTarget commentTarget;
	
	// Stats
	private boolean calculateStats;
	private int numPages;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@Column(name = "category")
	public String getCategory() { return category; }
	
	public void setCategory(String category) { this.category = category; }
	
	@Column(name = "name")
	public String getName() { return name; }
	
	public void setName(String name) { this.name = name; }

	@Column(name = "title")
	public String getTitle() { return title; }
	
	/**
	 * <p>
	 * Sets the title, trimming leading and trailing whitespace.
	 * </p>
	 * 
	 * @param title article title
	 */
	public void setTitle(String title) { this.title = title; }
	
	@Column(name = "author")
	public String getAuthor() { return author; }
	
	public void setAuthor(String author) { this.author = author; }
	
	@Column(name = "date_created")
	public Date getDateCreated() { return dateCreated; }
	
	public void setDateCreated(Date date) { this.dateCreated = date; }
	
	@Column(name = "deck")
	public String getDeck() { return deck; }
	
	public void setDeck(String deck) { this.deck = deck; }
	
	@OneToMany(mappedBy = "article", cascade = CascadeType.ALL)
	@OrderBy("pageNumber")
	public List<ArticlePage> getPages() { return pages; }
	
	public void setPages(List<ArticlePage> pages) { this.pages = pages; }
	
	@Column(name = "description")
	public String getDescription() { return description; }
	
	public void setDescription(String desc) { this.description = desc; }
	
	@Column(name = "keywords")
	public String getKeywords() { return keywords; }
	
	public void setKeywords(String keywords) { this.keywords = keywords; }
	
	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
//	@Cascade(org.hibernate.annotations.CascadeType.DELETE_ORPHAN)
	@JoinColumn(name = "comment_target_id")
	@SuppressWarnings("unused")
	private CommentTarget getCommentTarget() { return commentTarget; }
	
	@SuppressWarnings("unused")
	private void setCommentTarget(CommentTarget target) { this.commentTarget = target; }
	
	@Transient
	public List<Comment> getComments() { return commentTarget.getComments(); }
	
	@Transient
	public boolean getCalculateStats() { return calculateStats; }
	
	public void setCalculateStats(boolean flag) { this.calculateStats = flag; }
	
	@Transient
	public int getNumPages() { return (calculateStats ? pages.size() : numPages); }
	
	public void setNumPages(int n) { this.numPages = n; }
}
