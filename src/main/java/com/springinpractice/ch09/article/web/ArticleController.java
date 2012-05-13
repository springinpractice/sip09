package com.springinpractice.ch09.article.web;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.springinpractice.ch09.article.model.ArticlePage;
import com.springinpractice.ch09.article.service.ArticleService;
import com.springinpractice.ch09.comment.model.Comment;

@Controller
@RequestMapping("/articles")
public final class ArticleController {
	private static final Logger log = LoggerFactory.getLogger(ArticleController.class);
	
	@Inject private ArticleService articleService;
	
	@Value("#{viewNames.articleList}") private String articleListViewName;
	@Value("#{viewNames.articlePage}") private String articlePageViewName;
	@Value("#{viewNames.postCommentFailed}") private String postCommentFailedViewName;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		binder.setAllowedFields(new String[] { "id", "name", "email", "web", "markdownText" });
	}
	
	@RequestMapping(value = "", method = RequestMethod.GET)
	public String getArticles(Model model) {
		model.addAttribute(articleService.getAllArticles());
		return articleListViewName;
	}
	
	@RequestMapping(value = "{articleName}/{pageNumber}", method = RequestMethod.GET)
	public String getArticlePage(
			@PathVariable("articleName") String articleName,
			@PathVariable("pageNumber") int pageNumber,
			Model model) {
		
		prepareModel(model, articleName, pageNumber);
		model.addAttribute(new Comment());
		return articlePageViewName;
	}
	
	@RequestMapping(value = "{articleName}/comments", method = RequestMethod.POST)
	public String postComment(
		HttpServletRequest req,
		@PathVariable("articleName") String articleName,
		@RequestParam("p") int pageNumber,
		Model model,
		@ModelAttribute @Valid Comment comment,
		BindingResult result) {
		
		if (result.hasErrors()) {
			log.debug("Comment validation error");
			result.reject("global.error");
			prepareModel(model, articleName, pageNumber);
			return postCommentFailedViewName;
		}
		
		// No validation errors; post comment.
		log.debug("Posting comment");
		comment.setIpAddress(req.getRemoteAddr());
		articleService.postComment(articleName, comment);
		return "redirect:" + pageNumber + "#comment-" + comment.getId();
	}

	/**
	 * @param articleName
	 * @param pageNumber
	 * @param model
	 */
	private void prepareModel( Model model, String articleName, int pageNumber) {
		ArticlePage page = articleService.getArticlePage(articleName, pageNumber);
		
		// articlePage.jsp expects this
		model.addAttribute(page);
		
		// list.jspf (comment list) expects this
		model.addAttribute(page.getArticle().getComments());
	}
}
