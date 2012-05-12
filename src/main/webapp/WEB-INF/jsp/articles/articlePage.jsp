<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="article" value="${articlePage.article}" />

<fmt:formatDate var="articleDate" value="${article.dateCreated}" />

<c:url var="articlesCssUrl" value="/styles/articles.css" />
<c:url var="shCssUrl" value="/styles/SyntaxHighlighter.css" />
<c:url var="shCoreJsUrl" value="/scripts/shCore.js" />
<c:url var="shBrushJavaJsUrl" value="/scripts/shBrushJava.js" />
<c:url var="shBrushXmlJsUrl" value="/scripts/shBrushXml.js" />
<c:url var="clipboardSwfUrl" value="/swf/clipboard.swf" />
<c:url var="articlesUrl" value="/articles.html" />
<c:url var="postCommentUrl" value="/articles/${article.name}/comments?p=${articlePage.pageNumber}#postComment" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<c:if test="${not empty article.description}">
			<meta name="description" content="${article.description}" />
		</c:if>
		<c:if test="${not empty article.keywords}">
			<meta name="keywords" content="${article.description}" />
		</c:if>
		<title><c:out value="${articlePage.title}" /></title>
		<link rel="stylesheet" type="text/css" href="${articlesCssUrl}" />
		<link rel="stylesheet" type="text/css" href="${shCssUrl}" />
	</head>
	<body>
		<div id="breadcrumbs">
			<a href="${articlesUrl}">Articles</a> &gt;
			<a href="1">${article.title}</a> &gt;
			Page ${articlePage.pageNumber}
		</div>
		
		<%@ include file="pageNav.jspf" %>
		
		<div id="articlePageBody">
			<div><%@ include file="social.jspf" %></div>
			
			<c:choose>
				<c:when test="${articlePage.pageNumber == 1}">
					<div>
						<%-- FIXME Hardcoded path --%>
						<div style="float:right;margin:0 0 10px 10px"><img src="/sip/images/zone_it.png"></img></div>
			
						<c:if test="${not empty article.category}">
							<div id="kicker">${article.category}</div>
						</c:if>
						
						<h1 id="articleTitle">${articlePage.title}</h1>
						
						<div id="byline">
							by <span class="user icon">${article.author}</span>
							on <span class="date icon">${articleDate}</span>
						</div>
						
						<c:if test="${not empty article.deck}">
							<div id="deck">${article.deck}</div>
						</c:if>
					</div>
				</c:when>
				<c:otherwise>
					<div id="articleTitle">${article.title} - page ${articlePage.pageNumber}</div>
				</c:otherwise>
			</c:choose>
			
			<div>${articlePage.body}</div>
			<div style="text-align:right"><%@ include file="social.jspf" %></div>
		</div>
		
		<%@ include file="pageNav.jspf" %>
		
		<div class="panel"><%@ include file="/WEB-INF/jspf/comment/list.jspf" %></div>
		<div class="panel"><%@ include file="/WEB-INF/jspf/comment/post.jspf" %></div>
		
		<script type="text/javascript" src="${shCoreJsUrl}"></script>
		<script type="text/javascript" src="${shBrushJavaJsUrl}"></script>
		<script type="text/javascript" src="${shBrushXmlJsUrl}"></script>
		<script type="text/javascript">
			dp.SyntaxHighlighter.ClipboardSwf = '${clipboardSwfUrl}';
			dp.SyntaxHighlighter.HighlightAll('code');
		</script>
	</body>
</html>
