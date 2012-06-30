require.config({
	baseUrl : "pagedown"
});

var html;

require([ "Markdown.Sanitizer.Modified" ], function(sanitizer) {
	html = sanitizer.getSanitizingConverter().makeHtml(markdown);
});
