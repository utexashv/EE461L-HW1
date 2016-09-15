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
		    
	    <div>
	    	<h1>Welcome to Longhorn Blog!</h1>
		    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Texas_Longhorn_logo.svg/2000px-Texas_Longhorn_logo.svg.png"
	    		style="width:400px; height:200px;">
	    </div>
	    
		<%
	    if (user != null) {
	    	pageContext.setAttribute("user", user);
		%>	
			<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
				<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>	
				
			<p>Click <a href="createblog.jsp">here</a> to create a blog.</p>
		<%
		} else {
		%>
			<p>Hello!
			<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to post blogs.</p>
		<%
		}
		%>
		<p><a href="listblog.jsp">List of all blogs</a></p>
		<%
		// interact with Objectify  
		Key<Guestbook> theBook = Key.create(Guestbook.class, guestbookName);
		List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).ancestor(theBook).order("-date").limit(5).list();
		
		if (greetings.isEmpty()) {
		%>
			<h3>There are no blogs yet. :(</h3>
		<%
		} else {
		%>
			<h3>Blogs</h3>
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
		  		String date = greeting.formatDate();
		  		pageContext.setAttribute("greeting_user", author);
		  		pageContext.setAttribute("greeting_date", date);
		  		pageContext.setAttribute("greeting_title", greeting.title);
		%>
			<div style="background-color: #033863; padding: 10px 20px 10px 20px">
				<b>${fn:escapeXml(greeting_date)}</b><br/>
				<h3>${fn:escapeXml(greeting_title)}</h3>
				by <b>${fn:escapeXml(greeting_user)}</b>
	   			<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
	   		</div>
   			<br/>
		<%
		        }
		}
		%>
		<p><a href="listblog.jsp">List of all blogs</a></p>
		
	</body>
</html>

 