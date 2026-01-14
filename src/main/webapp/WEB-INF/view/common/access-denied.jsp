<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Truy cập bị từ chối</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/startbootstrap-sb-admin/css/styles.css">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        body{background:#f8f9fa}
    </style>
    </head>
<body class="bg-light">
<div class="container text-center mt-5">
    <h1 class="text-danger"><i class="fas fa-ban"></i> Truy cập bị từ chối</h1>
    <p>Bạn không có quyền truy cập vào khu vực này.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Quay về trang chủ</a>
  </div>
</body>
</html>


