package com.springinpractice.ch09.comment.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.ScriptableObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;

/**
 * @author sperumal
 * @see http://stackoverflow.com/questions/11074836/resolving-modules-using-require-js-and-java-rhino
 */
@SuppressWarnings("serial")
public class JsRuntimeSupport extends ScriptableObject {
	private static final Logger log = LoggerFactory.getLogger(JsRuntimeSupport.class);

	/* (non-Javadoc)
	 * @see org.mozilla.javascript.ScriptableObject#getClassName()
	 */
	@Override
	public String getClassName() { return "test"; }
	
	public static void print(Context ctx, Scriptable thisObj, Object[] args, Function func) {
		for (int i = 0; i < args.length; i++) {
			log.info(Context.toString(args[i]));
		}
	}
	
	public static void load(Context ctx, Scriptable thisObj, Object[] args, Function func) throws IOException {
		JsRuntimeSupport shell = (JsRuntimeSupport) getTopLevelScope(thisObj);
		for (int i = 0; i < args.length; i++) {
			String filename = Context.toString(args[i]);
			log.info("Loading file: {}", filename);
			shell.processSource(ctx, filename);
		}
	}
	
	private void processSource(Context ctx, String filename) throws IOException {
		InputStream is = new ClassPathResource(filename).getInputStream();
		ctx.evaluateReader(this, new InputStreamReader(is), filename, 1, null);
	}
}
