<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="guestbook.Guestbook" %>
<%@ page import="guestbook.Greeting" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<title>Blog - creation</title>
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
		<p>You can write your own blog here:</p>
		<br/>
		<form action="/blog" method="post">
	    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
	    	<div><input type="submit" value="Post Blog" /></div>
	      	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	    </form>
	    <br/>
		<a href="blogpage.jsp">Go Back</a>
	</body>
</html>