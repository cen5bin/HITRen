package cn.edu.hit.Dao;

public enum Constant {
//	EMAIL("email"),
//	PASSWORD("password");
//	private final String value;
//	public String getValue() {
//		return value;
//	}
//	Constant(String value) {
//		this.value = value;
//	}
}

class UserConstant {
	//���ݿ����
	protected static final String COLLNAME = "User"; 

	//�ֶ���
	protected static final String UID = "uid";
	protected static final String EMAIL = "email";
	protected static final String PASSWORD = "password";
}

class IDCounter {
	//����
	protected static final String COLLNAME = "IDCounter";
	//����
	protected static final String KEY = "key";
	protected static final String VALUE = "value";
	//key
	protected static final String UID = "uid";
}