package cn.edu.hit.servlet.relationshiplogic;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.Dao.RelationshipLogic;
import cn.edu.hit.kit.LogKit;

/**
 * Servlet implementation class DeleteConcernedUserServlet
 * 删除关注的人
 * 参数uid,uid1(要删除的人的uid)
 */
@WebServlet("/DeleteConcernedUserServlet")
public class DeleteConcernedUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteConcernedUserServlet() {
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
			int uid1 = json.getInt("uid1");
			
			LogKit.debug("deleteConcernedUserFromGroups uid: %d  uid1: %d", uid, uid1);
			RelationshipLogic.deleteConcernedUser(uid, uid1);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(RelationshipLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
