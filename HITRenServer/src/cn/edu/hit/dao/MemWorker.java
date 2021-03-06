package cn.edu.hit.dao;

/**
 * 建立在MemController上的逻辑处理
 * @author cen5bin
 *
 */
public class MemWorker {
	/**
	 * 从memcache中获取用户信息，返回值是用户信息的json数据
	 * @param uid
	 * @return
	 */
	public static String getUserInfo(int uid) {
		String key = calUserKey(uid);
		Object obj = MemController.get(key);
		if (obj == null)
			return null;
		return obj.toString();
	}
	
	/**
	 * 向memcache中插入用户信息，返回值表示成功与否
	 * @param uid
	 * @param userInfo 用户信息的json数据
	 * @return
	 */
	public static boolean setUserInfo(int uid, String userInfo) {
		String key = calUserKey(uid);
		return MemController.set(key, userInfo);
	}
	
	/**
	 * 删除memcached中的用户信息
	 * @param uid
	 * @return
	 */
	public static boolean deleteUserInfo(int uid) {
		String key = calUserKey(uid);
		return MemController.delete(key);
	}
	
	/**
	 * 获取mid对应的状态
	 * @param mid
	 * @return
	 */
	public static String getMessageInfo(int mid) {
		String key = calMessageKey(mid);
		Object obj = MemController.get(key);
		if (obj == null) return null;
		return obj.toString();
	}
	
	public static boolean setMessageInfo(int mid, String messageInfo) {
		String key = calMessageKey(mid);
		return MemController.set(key, messageInfo);
	}
	
	public static boolean deleteMessageInfo(int mid) {
		String key = calMessageKey(mid);
		return MemController.delete(key);
	}
	
	/**
	 * 根据uid计算memcache中对应的key
	 * @param uid
	 * @return
	 */
	private static String calUserKey(int uid) {
		String key = String.format("uid_%d", uid);
		return key;
	}
	
	private static String calMessageKey(int mid) {
		String key = String.format("mid_%d", mid);
		return key;
	}
}
