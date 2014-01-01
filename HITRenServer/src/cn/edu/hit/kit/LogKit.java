package cn.edu.hit.kit;

import java.text.SimpleDateFormat;
import java.util.Date;

public class LogKit {
	public static final boolean isdebug = true;
	
	public final static void debug(Object o) {
		if (isdebug) {
			StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
			StringBuffer buf = new StringBuffer("[").append(_TIME_()).append(" | ").
					append(traceElement.getFileName()).append(" (").
					append(traceElement.getLineNumber()).append(")").append(" | ").append(traceElement.getMethodName()).append("]");
			System.out.println(buf.toString() + " "+ o.toString());
		}
	}
	
	public final static void debug(String s) {
		if (isdebug) {
			StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
			StringBuffer buf = new StringBuffer("[").append(_TIME_()).append(" | ").
					append(traceElement.getFileName()).append(" (").
					append(traceElement.getLineNumber()).append(")").append(" | ").append(traceElement.getMethodName()).append("]");
			System.out.println(buf.toString() + " "+ s);
		}
	}
	
	public final static void debug(int x) {
		if (isdebug) {
			StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
			StringBuffer buf = new StringBuffer("[").append(_TIME_()).append(" | ").
					append(traceElement.getFileName()).append(" (").
					append(traceElement.getLineNumber()).append(")").append(" | ").append(traceElement.getMethodName()).append("]");
			System.out.println(buf.toString() + " " + x);
		}
	}
	
	public final static void err(String s) {
		debug("error: "+s);
	}
	
	
	public static final String getPrefix() {
		StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
		StringBuffer buf = new StringBuffer("[").append(_TIME_()).append("|").
				append(traceElement.getFileName()).append(":").
				append(traceElement.getLineNumber()).append("|").append(traceElement.getMethodName()).append("]");
		return buf.toString();
	}
	// 当前文件名 
	public static String _FILE_() { 
		StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
		return traceElement.getFileName(); 
	} 

	// 当前方法名 
	public static String _FUNC_() { 
		StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
		return traceElement.getMethodName(); 
	} 

	// 当前行号 
	public static int _LINE_() { 
		StackTraceElement traceElement = ((new Exception()).getStackTrace())[1]; 
		return traceElement.getLineNumber(); 
	} 

	// 当前时间 
	public static String _TIME_() { 
		Date now = new Date(); 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return sdf.format(now); 
	}
	
	public static void main(String[] args) {
		debug(10);
	}
}
