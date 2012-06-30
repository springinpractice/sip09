package com.springinpractice.ch09.comment.service.impl;

import java.io.IOException;
import java.io.InputStreamReader;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.ScriptableObject;
import org.springframework.core.io.Resource;

import com.springinpractice.ch09.comment.service.TextFilter;

/**
 * Performs HTML filtering based mostly on the rules defined
 * <a href="http://stackoverflow.com/questions/31657/what-html-tags-are-allowed-on-stack-overflow">here</a>,
 * including those in the answers that seem reasonable enough to whitelist.
 * 
 * @author Willie Wheeler (willie.wheeler@gmail.com)
 */
public final class RichTextFilter implements TextFilter {
	private Resource r;
	private Resource convert;
	
	public Resource getR() { return r; }
	
	public void setR(Resource r) { this.r = r; }
	
	public Resource getConvert() { return convert; }
	
	public void setConvert(Resource convert) { this.convert = convert; }
	
	public String filter(String text) {
		
		// Just use Rhino directly. See
		// http://stackoverflow.com/questions/11074836/resolving-modules-using-require-js-and-java-rhino
		// http://stackoverflow.com/questions/11080037/java-7-rhino-1-7r3-support-for-commonjs-modules
		Context ctx = Context.enter();
		try {
			ScriptableObject sharedScope = ctx.initStandardObjects(new JsRuntimeSupport(), true);
			
			// Set up RequireJS
			String[] names = { "print", "load" };
			sharedScope.defineFunctionProperties(names, sharedScope.getClass(), ScriptableObject.DONTENUM);
			Scriptable argsObj = ctx.newArray(sharedScope, new Object[] { });
			sharedScope.defineProperty("arguments", argsObj, ScriptableObject.DONTENUM);
			ctx.evaluateReader(sharedScope, new InputStreamReader(r.getInputStream()), "r", 1, null);
			
			// Run PageDown
			sharedScope.defineProperty("markdown", text, ScriptableObject.DONTENUM);
			ctx.evaluateReader(sharedScope, new InputStreamReader(convert.getInputStream()), "convert", 1, null);
			
			return (String) sharedScope.get("html");
			
		} catch (IOException e) {
			throw new RuntimeException(e);
		} finally {
			Context.exit();
		}
	}
}
