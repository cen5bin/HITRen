package cn.edu.hit.kit;

import java.io.BufferedReader;
import java.io.IOException;

public class DataKit {
	/**
	 * 获取客户端传来的json数据
	 * @param reader
	 * @return
	 * @throws IOException
	 */
	public static String getDataFromClient(BufferedReader reader) throws IOException {
		StringBuffer data = new StringBuffer();
		String s = null;
		while ((s = reader.readLine()) != null) {
			data = data.append(s);
		}
//		return data.toString();
		return new String(data.toString().getBytes("ISO8859_1"),"utf-8");
	}
}
