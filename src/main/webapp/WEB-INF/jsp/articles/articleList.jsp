<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Technical Articles - Java, JEE, Spring Framework &amp; more" />
<c:url var="articlesCssUrl" value="/styles/articles.css" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<title>${pageTitle}</title>
		<link rel="stylesheet" type="text/css" href="${articlesCssUrl}" />
		<script type="text/javascript">
			$(document).ready(function() {
				$('#articleTable').tablesorter({
					sortList: [ [0, 0] ],
					textExtraction: "complex"
				});
			});
		</script>
	</head>
	<body>
		<div style="margin:20px 0">
			<h1>${pageTitle}</h1>
			
			<c:choose>
				<c:when test="${empty articleList}">
					<p>No articles.</p>
				</c:when>
				<c:otherwise>
					<table id="articleTable" class="table tablesorter">
						<thead>
							<tr>
								<th>Title</th>
								<th>Author</th>
								<th>Date</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="article" items="${articleList}">
								<c:set var="articleAuthor" value="${article.author}" />
								<fmt:formatDate var="articleDate" value="${article.dateCreated}" />
								<c:choose>
									<c:when test="${article.numPages == 1}">
										<c:set var="pageOrPages">page</c:set>
									</c:when>
									<c:otherwise>
										<c:set var="pageOrPages">pages</c:set>
									</c:otherwise>
								</c:choose>
								<c:url var="articleUrl" value="/articles/${article.name}/1" />
								<tr>
									<td>
										<a href="${articleUrl}"><c:out value="${article.title}" /></a>
										(${article.numPages} ${pageOrPages})
									</td>
									<td><span class="user icon">${articleAuthor}</span></td>
									<td><span class="date icon">${articleDate}</span></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:otherwise>
			</c:choose>
		</div>
	</body>
</html>
