package cn.edu.hit.openfire;

import java.io.IOException;

import org.jivesoftware.smack.Chat;
import org.jivesoftware.smack.MessageListener;
import org.jivesoftware.smack.XMPPException;
import org.jivesoftware.smack.packet.Message;
import org.json.JSONException;



public class TipsPusher {
	
	/**
	 * 状态被点赞时发推送消息给该用户
	 * @param uid 被点赞的用户id
	 * @param uid1 去点赞的用户id
	 * @throws XMPPException 
	 * @throws IOException 
	 * @throws JSONException 
	 */
	public static void messageIsLikedByUser(int uid, int uid1, String name, String pic, int mid) throws Exception {
		String message = TipsCreator.createSNSPushMessage(SNSPushMessageType.LIKED, uid1, name, pic, mid);
		TipsPusher.sendMessage(calJidWithUid(uid), message);
	}
	
	/**
	 * 状态被评论，或者被回复
	 * @param uid 被评论或者被回复的用户id
	 * @param uid1 去评论的用户id
	 * @param name 去评论的用户名字
	 * @param pic
	 * @param mid 相关状态id
	 * @throws Exception
	 */
	public static void messageIsCommentedByUser(int uid, int uid1, String name, String pic, int mid) throws Exception {
		String message = TipsCreator.createSNSPushMessage(SNSPushMessageType.COMMENTED, uid1, name, pic, mid);
		TipsPusher.sendMessage(calJidWithUid(uid), message);
	}
	
	/**
	 * 状态被分享
	 * @param uid 被分享的状态的作者
	 * @param uid1 分享者
	 * @param name 
	 * @param pic
	 * @param mid 被分享的状态
	 * @throws Exception
	 */
	public static void messageIsSharedByUser(int uid, int uid1, String name, String pic, int mid) throws Exception {
		String message = TipsCreator.createSNSPushMessage(SNSPushMessageType.SHARED, uid1, name, pic, mid);
		TipsPusher.sendMessage(calJidWithUid(uid), message);
	}
	
	public static void messageIsReportedByUser(int uid, int uid1, String name, String pic, int mid) throws Exception {
		String message = TipsCreator.createSNSPushMessage(SNSPushMessageType.REPORTED, uid1, name, pic, mid);
		TipsPusher.sendMessage(calJidWithUid(uid), message);
	}
	
	private static void sendMessage(String user, String message) throws Exception {
		Chat chat = OpenfireConnector.getAdminConnection().getChatManager().createChat(user, new MessageListener() {
			@Override
			public void processMessage(Chat arg0, Message arg1) {
				// TODO Auto-generated method stub
			}
		});
		chat.sendMessage(message);
	}
	
	private static String calUsernameWithUid(int uid) {
		String username = String.format("hitrenuid%d", uid);
		return username;
	}
	
	private static String calJidWithUid(int uid) throws IOException, XMPPException {
		return calUsernameWithUid(uid) + "@" + OpenfireConnector.getHostname();
	}
	
}
