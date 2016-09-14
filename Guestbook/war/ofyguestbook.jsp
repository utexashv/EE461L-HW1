<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="guestbook.Greeting" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
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
			ObjectifyService.register(Greeting.class);
			List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
			Collections.sort(greetings);
			
			if (greetings.isEmpty()) {
			%>
				<p>Blog '${fn:escapeXml(guestbookName)}' has no messages.</p>
			<%
			} else {
			%>
				<p>Messages in Blog '${fn:escapeXml(guestbookName)}'.</p>
			<%
				for (Greeting greeting : greetings) {
					pageContext.setAttribute("greeting_content", greeting.getContent());
			  		if (greeting.getUser() == null) {
			%>
			       	<p>An anonymous person wrote:</p>
			<%
			     	} else {
			          	pageContext.setAttribute("greeting_user", greeting.getUser());
			%>
			       		<p><b>${fn:escapeXml(greeting_user)}</b> wrote:</p>
			<%
			       	}
			%>
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
    
  </body>
</html>

 