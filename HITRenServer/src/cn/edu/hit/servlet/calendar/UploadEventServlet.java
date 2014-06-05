package cn.edu.hit.servlet.calendar;

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
import cn.edu.hit.logic.EventLogic;

/**
 * Servlet implementation class UploadEventServlet
 * 参数，uid，eid（字符串），time（字符串），description（字符串），place(字符串), reminds（数组，每个元素是int，表示提前几分钟提醒）
 */
@WebServlet("/UploadEventServlet")
public class UploadEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadEventServlet() {
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
			String time = json.getString("time");
			String eid = json.getString("eid");
			String desc = json.getString("description");
			String place = json.getString("place");
			JSONArray reminds0 = json.getJSONArray("reminds");
			ArrayList<Integer> reminds = new ArrayList<Integer>();
			for (int i = 0; i < reminds0.length(); i++)
				reminds.add(reminds0.getInt(i));
			EventLogic.uploadEventInfo(uid, eid, time, place, desc, reminds);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(EventLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
