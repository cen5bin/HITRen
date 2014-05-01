package cn.edu.hit.servlet.messagelogic;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.kit.DataKit;

/**
 * Servlet implementation class DownloadMessagesServlet
 * 下载状态数据
 * uid 用户id； gseq，global的序列号；useq，用户自己timeline的序列号；index 查找状态的初始下标
 */
@WebServlet("/DownloadMessagesServlet")
public class DownloadMessagesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadMessagesServlet() {
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
			int gseq = json.getInt("gseq");
			int useq = json.getInt("useq");
			int index = json.getInt("index");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
