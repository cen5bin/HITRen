package cn.edu.hit.dao;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import cn.edu.hit.kit.FileKit;

import com.danga.MemCached.MemCachedClient;
import com.danga.MemCached.SockIOPool;

/**
 * memcache控制类，负责get和set数据
 * @author cen5bin
 *
 */
public class MemController {
	private static MemCachedClient mcc = new MemCachedClient();
	private static SockIOPool pool = SockIOPool.getInstance();
	
	private static String confPath = "";
	
	static {
		confPath = FileKit.getConfPath()+"memcache.conf";
		try {
			BufferedReader br = new BufferedReader(new FileReader(confPath));
			br.readLine();
			String s = "";
			ArrayList<String> servers = new ArrayList<String>();
			while((s = br.readLine()) != null) 
				if (s.trim().length() > 0)
					servers.add(s.trim());
			br.close();
			
			String[] servers1 = new String[servers.size()];
			for (int i = 0; i < servers.size(); i++)
				servers1[i] = servers.get(i);
			
			pool.setServers(servers1);
			pool.setInitConn(5);
			pool.setMinConn(5);
			pool.setMaxConn(250);
			pool.setMaxIdle(1000 * 60 * 60 * 3);
			pool.setMaintSleep(30);
			pool.setNagle(false);
			pool.setSocketTO(3000);
			pool.setSocketConnectTO(0);
			pool.initialize();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static String get(String key) {
		Object ret = mcc.get(key);
		if (ret == null)
			return null;
		return ret.toString();
	}
	
	public static boolean set(String key, String value) {
		return mcc.set(key, value);
	}
	
	public static boolean delete(String key) {
		return mcc.delete(key);
	}
}
