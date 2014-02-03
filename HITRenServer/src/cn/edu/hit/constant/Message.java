package cn.edu.hit.constant;

public class Message {
	public static final String COLLNAME = "Message";
	
	public static final String MID = "mid";
	public static final String UID = UserConstant.UID;
	public static final String TIME = "time";
	public static final String SEQ = "seq";
	public static final String COMMENTLIST = "commentlist";
	public static final String LIKEDLIST = "likedlist";
	public static final class LIKEDINFO {
		public static final String UID = UserConstant.UID;
		public static final String UNAME = UserConstant.NAME;
	}
	public static final String SHATECOUNT = "sharedcount";
	public static final String TYPE = "type";
	public static final class Type {
		public static final int NORMAL = 0;
		public static final int SHARED = 1;
	}
	public static final String CONTENT = "content";
}
