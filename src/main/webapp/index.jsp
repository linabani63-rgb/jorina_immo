<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirige automatiquement vers le contrôleur
    response.sendRedirect(request.getContextPath() + "/Controller?action=login");
%>
