package cn.edu.hit.openfire;

import java.io.IOException;

import org.jivesoftware.smack.XMPPException;

public class AccountManager {
	/**
	 * 在openfire里创建uid对应的用户
	 * @param uid 用户id
	 * @param password 密码
	 * @throws IOException 
	 * @throws XMPPException 
	 */
	public static void createAccount(int uid, String password) throws XMPPException, IOException {
		OpenfireConnector.getAdminConnection().getAccountManager().createAccount(calUsernameWithUid(uid), password);
	}
	
	/**
	 * 在openfire里删除uid对应的账户
	 * @param uid
	 * @param password
	 * @throws XMPPException
	 * @throws IOException 
	 */
	public static void deleteAccount(int uid, String password) throws XMPPException, IOException {
		OpenfireConnector.getNormalConnection(calUsernameWithUid(uid), password).getAccountManager().deleteAccount();
	}
	
	/**
	 * 修改openfire里账号的密码
	 * @param uid
	 * @param oldPassword
	 * @param newPassword
	 * @throws XMPPException
	 * @throws IOException
	 */
	public static void changePassword(int uid, String oldPassword, String newPassword) throws XMPPException, IOException {
		OpenfireConnector.getNormalConnection(calUsernameWithUid(uid), oldPassword).getAccountManager().changePassword(newPassword);
	}
	
	private static String calUsernameWithUid(int uid) {
		String username = String.format("hitrenuid%d", uid);
		return username;
	}
}
