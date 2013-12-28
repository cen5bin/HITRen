package cn.edu.hit.servlet;

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

/**
 * Servlet implementation class CopyUsersToGroupsServlet
 * 将一部分好友复制到某些分组
 * 传递参数：当前用户uid，要复制的好友users，目标分组gnames
 */
@WebServlet("/CopyUsersToGroupsServlet")
public class CopyUsersToGroupsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CopyUsersToGroupsServlet() {
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
			JSONArray groups = json.getJSONArray("gnames");
			for (int i = 0; i < groups.length(); i++) {
				boolean ret = RelationshipLogic.copyUsersToGroup(uid, users, groups.getString(i));
				if (!ret)
					break;
			}
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(RelationshipLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
