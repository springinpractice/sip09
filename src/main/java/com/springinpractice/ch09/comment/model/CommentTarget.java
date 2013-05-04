/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.model;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * Represents anything that can have comments, such as an article, a blog post, a product description and so forth.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Entity
@Table(name = "comment_target")
public final class CommentTarget {
	private Long id;
	private List<Comment> comments;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
	@JoinColumn(name = "comment_target_id", nullable = false)
	public List<Comment> getComments() { return comments; }
	
	public void setComments(List<Comment> comments) {
		this.comments = comments;
	}
}
