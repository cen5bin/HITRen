package cn.edu.hit.kit;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

public class FileKit {
	private static String url = new FileKit().getClass().getClassLoader().getResource("").getPath()+"../../";
	private static String webRoot = "";//URLDecoder.decode(url, "utf-8");//(new FileKit().getClass().getClassLoader().getResource("").getPath()+"../../");
	private static String WEB_INF = "";//webRoot+"WEB-INF/";
	private static String conf = "";//WEB_INF+"conf/";
	private static String upload = "";
	
	static {
		try {
			webRoot = URLDecoder.decode(url, "utf-8");
			WEB_INF = webRoot+"WEB-INF/";
			conf = WEB_INF+"conf/";
			upload = webRoot + "../upload/";
			
			File file = new File(upload);
			if (!file.exists())
				file.mkdir();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static String getWebRoot() {
		return webRoot;
	}
	
	public static String getWebInf() {
		return WEB_INF;
	}
	
	public static String getConfPath() {
		return conf;
	}
	
	public static String getUpload() {
		return upload;
	}
}
