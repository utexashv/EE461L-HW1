/**
 * Peter Yunpeng Zhang
 * 08/29/2016 EE461L
 * yz7724
 * https://peter-ofyguestbook.appspot.com/ofyguestbook.jsp
 */

package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import java.io.IOException;
import java.util.Date;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class OfySignGuestbookServlet extends HttpServlet {
	static {
        ObjectifyService.register(Greeting.class);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        // objectify
        String guestbookName = req.getParameter("guestbookName");
        String content = req.getParameter("content");
        Greeting gt = new Greeting(user, content);
        ObjectifyService.ofy().save().entity(gt).now();
        
        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + guestbookName);
    }

}