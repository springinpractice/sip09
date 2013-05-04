/* 
 * Copyright (c) 2013 Manning Publications Co.
 * 
 * Book: http://manning.com/wheeler/
 * Blog: http://springinpractice.com/
 * Code: https://github.com/springinpractice
 */
package com.springinpractice.ch09.comment.service.impl;

import static org.junit.Assert.assertEquals;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

/**
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
@ContextConfiguration(locations = "/spring/beans-service-richtext.xml")
public class RichTextFilterTests extends AbstractJUnit4SpringContextTests {
	
	// Class under test
	private RichTextFilter filter;
	
	@Before
	public void setUp() throws Exception {
		this.filter = applicationContext.getBean(RichTextFilter.class);
	}
	
	@After
	public void tearDown() throws Exception {
		this.filter = null;
	}
	
	@Test
	public void testAWithJavaScriptUrls() {
		String in = "<a href=\"javascript:alert('hi')\">Hi</a>";
//		String out = "<p><a rel=\"nofollow\">Hi</a></p>";
		String out = "<p>Hi</p>";
		assertEquals(out, filter.filter(in));
	}
	
	@Test
	public void testList() {
		String in = "* Item 1\n* Item 2\n";
		String out = "<ul>\n<li>Item 1</li>\n<li>Item 2</li>\n</ul>";
		assertEquals(out, filter.filter(in));
	}
}
