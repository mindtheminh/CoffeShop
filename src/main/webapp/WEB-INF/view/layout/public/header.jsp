<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    String cPath = request.getContextPath();
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null || pageTitle.isEmpty()) {
        pageTitle = "Yen Coffee House";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><%= pageTitle %></title>
    <meta name="version" content="20241220-v2">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;600;700&family=Josefin+Sans:wght@600;700&display=swap&subset=vietnamese" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/open-iconic-bootstrap.min.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/animate.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/owl.carousel.min.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/owl.theme.default.min.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/magnific-popup.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/aos.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/style.css" rel="stylesheet">
    <link href="<%=cPath%>/assets/css/custom.css" rel="stylesheet">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
</head>
<body>
