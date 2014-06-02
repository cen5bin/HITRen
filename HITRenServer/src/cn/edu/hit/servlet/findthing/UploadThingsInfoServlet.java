package cn.edu.hit.servlet.findthing;

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

import cn.edu.hit.kit.DataKit;
import cn.edu.hit.logic.FindLogic;

/**
 * Servlet implementation class UploadThingsInfoServlet
 */
@WebServlet("/UploadThingsInfoServlet")
public class UploadThingsInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadThingsInfoServlet() {
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
		String data = DataKit.getDataFromClient(request.getReader());
		try {
			JSONObject json = new JSONObject(data);
			int uid = json.getInt("uid");
			String name = json.getString("name");
			String desc = json.getString("description");
			JSONArray pics0 = json.getJSONArray("pics");
			ArrayList<String> pics = new ArrayList<String>();
			for (int i = 0; i < pics0.length(); i++)
				pics.add(pics0.getString(i));
			FindLogic.uploadThingsInfo(uid, name, pics, desc);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(FindLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
