/**
 * Peter Yunpeng Zhang
 * 08/29/2016 EE461L
 * yz7724
 * https://peter-ofyguestbook.appspot.com/ofyguestbook.jsp
 */

package guestbook;

import com.googlecode.objectify.ObjectifyService;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Blogpage extends HttpServlet {
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		Greeting greeting;
		
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        // objectify
        String guestbookName = req.getParameter("guestbookName");
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        if(user != null){
        	greeting = new Greeting(guestbookName, title, content, user.getUserId(), user.getEmail());
        } else {
        	greeting = new Greeting(guestbookName, title, content);
        }
        
        ObjectifyService.ofy().save().entity(greeting).now();
        
        resp.sendRedirect("/blogpage.jsp?guestbookName=" + guestbookName);
    }

}