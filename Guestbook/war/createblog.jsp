<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Blog - creation</title>
		<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	</head>
	
	<body>
		<p>You can create blogs here</p>
		<br/>
		<form action="/ofysign" method="post">
	    	<div><textarea name="content" rows="3" cols="60"></textarea></div>
	    	<div><input type="submit" value="Post Blog" /></div>
	      	<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	    </form>
	    <br/>
		<a href="ofyguestbook.jsp">Go Back</a>
	</body>
</html>