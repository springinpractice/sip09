package com.springinpractice.ch09.comment.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

import org.htmlcleaner.BrowserCompactXmlSerializer;
import org.htmlcleaner.CleanerProperties;
import org.htmlcleaner.HtmlCleaner;
import org.htmlcleaner.ITagInfoProvider;
import org.htmlcleaner.TagNode;
import org.htmlcleaner.XmlSerializer;

import com.springinpractice.ch09.comment.service.TextFilter;

/**
 *>Performs HTML filtering based mostly on the rules defined
 * <a href="http://stackoverflow.com/questions/31657/what-html-tags-are-allowed-on-stack-overflow">here</a>,
 * including those in the answers that seem reasonable enough to whitelist.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public final class RichTextFilter implements TextFilter {
	@Inject private File showdownJsFile;
	@Inject private ITagInfoProvider tagProvider;
	
	private String showdownJs;
	private CleanerProperties cleanerProps;
	
	public RichTextFilter() {
		// See http://htmlcleaner.sourceforge.net/parameters.php
		this.cleanerProps = new CleanerProperties();
		cleanerProps.setOmitUnknownTags(true);
		cleanerProps.setOmitComments(true);
		cleanerProps.setOmitXmlDeclaration(true);
		cleanerProps.setOmitDoctypeDeclaration(true);
		cleanerProps.setUseEmptyElementTags(false);
		cleanerProps.setIgnoreQuestAndExclam(true);
		cleanerProps.setNamespacesAware(false);
	}
	
	public void setShowdownJsFile(File showdownJsFile) {
		this.showdownJsFile = showdownJsFile;
	} 
	
	public void setTagProvider(ITagInfoProvider tagProvider) {
		this.tagProvider = tagProvider;
	}
	
	@PostConstruct
	public void postConstruct() throws IOException {
		// Read showdown.js file once since it doesn't ever change
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(showdownJsFile));
			StringBuilder builder = new StringBuilder();
			String line = null;
			while ((line = br.readLine()) != null) {
				builder.append(line + "\n");
			}
			this.showdownJs = builder.toString();
		} finally {
			br.close();
		}
	}
	
	public String filter(String text) {
		return filterTags(markdownToHtml(prepareForRhino(text)));
	}
	
	private String prepareForRhino(String markdown) {
		markdown = markdown.replace("\r", "");
		markdown = markdown.replace("\\", "\\\\");
		markdown = markdown.replace("\'", "\\'");
		markdown = markdown.replace("\n", "\\n");
		markdown = markdown.replace("\t", "\\t");
		return markdown;
	}
	
	private String markdownToHtml(String markdown) {
		try {
			ScriptEngineManager mgr = new ScriptEngineManager();
			ScriptEngine engine = mgr.getEngineByName("JavaScript");
			engine.eval(showdownJs);
			engine.eval("var markdown = '" + markdown + "';");
			engine.eval("var converter = new Showdown.converter();");
			engine.eval("var html = converter.makeHtml(markdown);");
			return (String) engine.get("html");
		} catch (ScriptException e) {
			// Shouldn't happen unless somebody breaks the script
			throw new RuntimeException(e);
		}
	}
	
	private String filterTags(String text) {
		try {
			HtmlCleaner cleaner = new HtmlCleaner(tagProvider, cleanerProps);
			TagNode htmlElem = cleaner.clean(text);
			TagNode bodyElem = htmlElem.findElementByName("body", false);
			filterAttributes(bodyElem);
			XmlSerializer serializer = new BrowserCompactXmlSerializer(cleanerProps);
			
			// Clean up the &apos; since IE7 doesn't like it (renders it literally).
			return serializer.getXmlAsString(bodyElem)
				.replaceAll("</?body>", "")
				.replaceAll("&apos;", "'")
				.replaceAll("&quot;", "\"");
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
	
	private void filterAttributes(TagNode elem) {
		filterAttributesForA(elem);
		filterAttributesForImg(elem);
	}
	
	/** Whitelist for <a> attributes */
	private void filterAttributesForA(TagNode elem) {
		TagNode[] kids = elem.getElementsByName("a", true);
		for (TagNode kid : kids) {
			@SuppressWarnings("unchecked")
			Map<String, String> attrs = (Map<String, String>) kid.getAttributes();
			for (String name : attrs.keySet()) {
				if ("href".equals(name)) {
					String value = attrs.get(name);
					if (value.startsWith("javascript:")) {
						attrs.remove(name);
					}
				} else if (!("title".equals(name))) {
					attrs.remove(name);
				}
			}
			attrs.put("rel", "nofollow");
		}
	}
	
	/** Whitelist for <img> attributes */
	private void filterAttributesForImg(TagNode elem) {
		TagNode[] kids = elem.getElementsByName("img", true);
		for (TagNode kid : kids) {
			@SuppressWarnings("unchecked")
			Map<String, String> attrs = (Map<String, String>) kid.getAttributes();
			for (String name : attrs.keySet()) {
				if (!("src".equals(name) || "alt".equals(name) || "title".equals(name))) {
					attrs.remove(name);
				}
			}
		}
	}
}
