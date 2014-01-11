package cn.edu.hit.kit;

import java.text.SimpleDateFormat;
import java.util.Date;

public class LogKit {
	public static final boolean isdebug = true;
	
	public final static void debug(Object o) {
		if (isdebug) {
			System.out.println(getPrefix() + " "+ o.toString());
		}
	}
	
	public final static void debug(String s) {
		if (isdebug) {
			System.out.println(getPrefix() + " "+ s);
		}
	}
	
	public final static void debug(String s, Object ...arg) {
		if (isdebug) {
			System.out.printf(getPrefix() + s+"\n", arg);
		}
	}
	
	private final static void debug(String s, int d, Object ...arg) {
		if (isdebug) {
			System.out.printf(getPrefix(d) + s+"\n", arg);
		}
	}
	
	private final static void debug(String s, int d) {
		if (isdebug) {
			System.out.println(getPrefix(d) + " "+ s);
		}
	}
	
	public final static void debug(int x) {
		if (isdebug) {
			System.out.println(getPrefix() + " " + x);
		}
	}
	
	public final static void err(String s) {
		debug("error: "+s, 1);
	}
	
	public final static void err(String s, Object ...arg) {
		debug("error: "+s, 1, arg);
	}
	
	public static final String getPrefix() {
		return getPrefix(1);
	}
	
	public static final String getPrefix(int d) {
		StackTraceElement traceElement = ((new Exception()).getStackTrace())[d+2]; 
		StringBuffer buf = new StringBuffer("[").append(_TIME_()).append(" | ").
				append(traceElement.getFileName()).append(":").
				append(traceElement.getLineNumber()).append(" | ").append(traceElement.getMethodName()).append("]");
		return buf.toString();
	}

	// 当前时间 
	private static String _TIME_() { 
		Date now = new Date(); 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return sdf.format(now); 
	}
	
	public static void main(String[] args) {
		debug(10);
	}
}
