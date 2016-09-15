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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>List of Blogs</title>
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
	<h1>List of Blogs</h1>
	
	<p><a href="blogpage.jsp">Go Back</a>
	<%	
	// interact with Objectify  
	Key<Guestbook> theBook = Key.create(Guestbook.class, guestbookName);
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).ancestor(theBook).order("-date").list();

	if (greetings.isEmpty()) {
	%>
		<h3>There are no blogs yet. :(</h3>
	<%
	} else {
	%>
		<h3>Blog(s)</h3>
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
	
	<p><a href="blogpage.jsp">Go Back</a>

</body>
</html>