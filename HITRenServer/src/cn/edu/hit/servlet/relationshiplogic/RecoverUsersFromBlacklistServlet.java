package cn.edu.hit.servlet.relationshiplogic;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.Dao.RelationshipLogic;
import cn.edu.hit.Dao.UserSimpleLogic;

/**
 * Servlet implementation class RecoverUsersFromBlacklistServlet
 * 将黑名单里的一部分用户恢复
 * 参数uid, users(要恢复的uid数组)
 */
@WebServlet("/RecoverUsersFromBlacklistServlet")
public class RecoverUsersFromBlacklistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RecoverUsersFromBlacklistServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String data = request.getParameter("data");
		data = new String(data.getBytes("ISO8859_1"),"utf-8");
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			JSONArray users0 = json.getJSONArray("users");
			ArrayList<Integer> users = new ArrayList<Integer>();
			for (int i = 0; i < users0.length(); i++)
				users.add(users0.getInt(i));
			RelationshipLogic.recoverUsersToBlacklist(uid, users);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(UserSimpleLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}

}
