/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.Email;
import org.springframework.util.StringUtils;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@Entity
@Table(name = "comment")
public final class Comment implements Comparable<Comment> {
	private Long id;
	private String name;
	private String email;
	private String web;
	private String text;
	private String ipAddress;
	private Date dateCreated;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	public Long getId() { return id; }
	
	@SuppressWarnings("unused")
	private void setId(Long id) { this.id = id; }
	
	@Size(min = 1, max = 100)
	@Column(name = "name")
	public String getName() { return name; }
	
	/**
	 * <p>
	 * Sets the author name, trimming leading and trailing whitespace.
	 * </p>
	 * 
	 * @param name
	 */
	public void setName(String name) {
		this.name = StringUtils.trimWhitespace(name);
	}

	@Size(min = 1, max = 100)
	@Email
	@Column(name = "email")
	public String getEmail() { return email; }

	/**
	 * <p>
	 * Sets the author e-mail address, trimming leading and trailing whitespace.
	 * </p>
	 * 
	 * @param email
	 */
	public void setEmail(String email) {
		this.email = StringUtils.trimWhitespace(email);
	}

	@Size(max = 250)
	@Column(name = "web")
	public String getWeb() { return web; }

	/**
	 * <p>
	 * Sets the author website URL, trimming leading and trailing whitespace.
	 * </p>
	 * 
	 * @param web
	 */
	public void setWeb(String web) {
		this.web = StringUtils.trimWhitespace(web);
	}

	@Size(min = 1, max = 4000)
	@Column(name = "text")
	public String getText() { return text; }

	public void setText(String text) { this.text = text; }

	@Column(name = "ip_addr")
	public String getIpAddress() { return ipAddress; }

	public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

	@Column(name = "date_created")
	public Date getDateCreated() { return dateCreated; }

	public void setDateCreated(Date date) { this.dateCreated = date; }

	public int compareTo(Comment o) {
		return dateCreated.compareTo(o.dateCreated);
	}
}
