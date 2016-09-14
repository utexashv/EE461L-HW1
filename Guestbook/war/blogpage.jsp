<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="guestbook.Guestbook" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<title>My Blog</title>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>

	<body>
		<%
	    String guestbookName = request.getParameter("guestbookName");
	    if (guestbookName == null) {
	        guestbookName = "default";
	    }
	    pageContext.setAttribute("guestbookName", guestbookName);
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();  
		%>	
		    
	    <p>Welcome to the Blog Page!</p>
	    
		<%
	    if (user != null) {
	    	pageContext.setAttribute("user", user);
		%>	
			<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>	
				
			<p>Click <a href="createblog.jsp">here</a> to create a blog.</p>
			<%
			// interact with Objectify  
			Key<Guestbook> theBook = Key.create(Guestbook.class, guestbookName);
			List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).ancestor(theBook).order("-date").limit(5).list();
			
			if (greetings.isEmpty()) {
			%>
				<p>Blog '${fn:escapeXml(guestbookName)}' has no messages.</p>
			<%
			} else {
			%>
				<p>Messages in Blog '${fn:escapeXml(guestbookName)}'.</p>
			<%
				for (Greeting greeting : greetings) {
					pageContext.setAttribute("greeting_content", greeting.content);
					String author;
			  		if (greeting.author_email == null) {
						author = "An anonymous person";
			     	} else {
			          author = greeting.author_email;
			          String author_id = greeting.author_id;
			          if(user != null && user.getUserId().equals(author_id)){
			        	  author += " (You)";
			          }
			       	}
			  		pageContext.setAttribute("greeting_user", author);
			%>
				<p><b>${fn:escapeXml(greeting_user)}</b> wrote:</p>
			   	<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
			<%
			        }
			}
			%>
		<%
		} else {
		%>
			<p>Hello!
			<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to see and post blogs.</p>
		<%
		}
		%>
		<form action="/blogpage.jsp" method="get">
			<div><input type="text" name="guestbookName" value="${fn:escapeXml(guestbookName)}" /></div>
			<div><input type="submit" value="Switch Blog" /></div>
		</form>
	</body>
</html>

 