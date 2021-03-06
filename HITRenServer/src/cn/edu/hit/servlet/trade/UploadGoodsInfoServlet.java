package cn.edu.hit.servlet.trade;

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
import cn.edu.hit.logic.TradeLogic;

/**
 * Servlet implementation class UploadGoodsInfoServlet
 * 参数，uid，name（字符串），price（字符串），pics（字符串数组，内存图片名），description（字符串）
 */
@WebServlet("/UploadGoodsInfoServlet")
public class UploadGoodsInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadGoodsInfoServlet() {
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
			String price = json.getString("price");
			String desc = json.getString("description");
			JSONArray pics0 = json.getJSONArray("pics");
			ArrayList<String> pics = new ArrayList<String>();
			for (int i = 0; i < pics0.length(); i++)
				pics.add(pics0.getString(i));
			TradeLogic.uploadGoodsInfo(uid, name, price, pics, desc);
			response.setCharacterEncoding("utf-8");
			PrintWriter out = response.getWriter();
			out.print(TradeLogic.retData);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
