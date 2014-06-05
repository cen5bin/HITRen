package cn.edu.hit.servlet.upload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import cn.edu.hit.kit.DataKit;
import cn.edu.hit.kit.FileKit;

/**
 * Servlet implementation class DownloadImageServlet
 */
@WebServlet("/DownloadImageServlet")
public class DownloadImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadImageServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String data = DataKit.getDataFromClient(request.getReader());
		String filename = "a.png";
		try {
			JSONObject json = new JSONObject(data);
			filename = json.getString("filename");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 // 获取图片绝对路径  
        String path = FileKit.getUpload();  
        File file = new File(path + filename);  
        if (!file.exists()) {
        	return;
        }
        //设置头信息,内容处理的方式,attachment以附件的形式打开,就是进行下载,并设置下载文件的命名  
        response.setHeader("Content-Disposition","attachment;filename="+file.getName());  
        // 创建文件输入流  
        FileInputStream is = new FileInputStream(file);  
        // 响应输出流  
        ServletOutputStream out = response.getOutputStream();  
        // 创建缓冲区  
        byte[] buffer = new byte[1024];  
        int len = 0;  
        while ((len = is.read(buffer)) != -1) {  
            out.write(buffer, 0, len);  
        }  
        is.close();  
        out.flush();  
        out.close();  
	}

	public void downlodeImage(HttpServletRequest request,  
            HttpServletResponse response) throws ServletException, IOException {  
          
       
  
    }  
}
