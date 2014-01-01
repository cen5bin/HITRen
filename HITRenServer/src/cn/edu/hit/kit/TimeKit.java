package cn.edu.hit.kit;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeKit {
	public static String now() {
		Date now = new Date(); 
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		return sdf.format(now); 
	}
}
