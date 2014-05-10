package cn.edu.hit.servlet.upload;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.ByteArrayOutputStream;

import cn.edu.hit.kit.FileKit;
import cn.edu.hit.servlet.kit.BaseServlet;

/**
 * Servlet implementation class UploadImagesServlet
 */
@WebServlet("/UploadImagesServlet")
public class UploadImagesServlet extends BaseServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadImagesServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		DiskFileItemFactory factory = new DiskFileItemFactory();
		String upload = this.getServletContext().getRealPath("/upload/");
		logger.info(FileKit.getWebRoot());
		logger.info(upload);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		DiskFileItemFactory factory = new DiskFileItemFactory();
		String upload = FileKit.getUpload();
		String temp = System.getProperty("java.io.tmpdir");  
		factory.setSizeThreshold(1024 * 1024 * 5);  
		factory.setRepository(new File(temp));  
		ServletFileUpload servletFileUpload = new ServletFileUpload(factory);  
		logger.info("begin");
		try {
			List<FileItem> list = servletFileUpload.parseRequest(request);
			for (FileItem item : list) {
				
				String name = item.getFieldName();  
                InputStream is = item.getInputStream();  
                logger.info(name);
                if (name.contains("content"))  
                {  
                    System.out.println(inputStream2String(is));  
                } else if(name.contains("pic"))  
                {  
                    try  
                    {  
                        inputStream2File(is, upload + item.getName());  
                    } catch (Exception e)  
                    {  
                        e.printStackTrace();  
                    }  
                }  
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
	}
	
	// 流转化成字符串  
    public static String inputStream2String(InputStream is) throws IOException  
    {  
        ByteArrayOutputStream baos = new ByteArrayOutputStream();  
        int i = -1;  
        while ((i = is.read()) != -1)  
        {  
            baos.write(i);  
        }  
        return baos.toString();  
    }  
  
    // 流转化成文件  
    public static void inputStream2File(InputStream is, String savePath)  
            throws Exception  
    {  
        System.out.println("文件保存路径为:" + savePath);  
        File file = new File(savePath);  
        InputStream inputSteam = is;  
        BufferedInputStream fis = new BufferedInputStream(inputSteam);  
        FileOutputStream fos = new FileOutputStream(file);  
        int f;  
        while ((f = fis.read()) != -1)  
        {  
            fos.write(f);  
        }  
        fos.flush();  
        fos.close();  
        fis.close();  
        inputSteam.close();  
          
    }  
  

}
