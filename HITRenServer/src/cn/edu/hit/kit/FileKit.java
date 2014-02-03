package cn.edu.hit.kit;

public class FileKit {
	private static String webRoot = new FileKit().getClass().getClassLoader().getResource("").getPath()+"../../";
	private static String WEB_INF = webRoot+"WEB-INF/";
	private static String conf = WEB_INF+"conf/";
	
	
	public static String getWebRoot() {
		return webRoot;
	}
	
	public static String getWebInf() {
		return WEB_INF;
	}
	
	public static String getConfPath() {
		return conf;
	}
}
