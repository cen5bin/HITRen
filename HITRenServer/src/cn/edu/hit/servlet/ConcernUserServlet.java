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
 * Servlet implementation class ConcernUserServlet
 * 关注一个好友,把他加到分组中，默认加入default分组
 * 客户端传来uid，uid1（关注的人的uid），和分组列表gnames（数组）
 */
@WebServlet("/ConcernUserServlet")
public class ConcernUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConcernUserServlet() {
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
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			int uid1 = json.getInt("uid1");
			JSONArray jsonArray = json.getJSONArray("gnames");
			for (int i = 0; i < jsonArray.length(); i++){
				boolean ret = RelationshipLogic.concernUserInGroup(uid, jsonArray.getString(i), uid1);
				if (!ret) 
					break;
			}
			PrintWriter out = response.getWriter();
			out.print(RelationshipLogic.retData);
			
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
