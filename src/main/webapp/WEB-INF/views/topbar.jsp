<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%
    Usuario usuarioTopbar = (Usuario) session.getAttribute("usuarioLogueado");
    String inicial = (usuarioTopbar != null && usuarioTopbar.getNombresCompletos() != null && !usuarioTopbar.getNombresCompletos().isEmpty()) 
                     ? usuarioTopbar.getNombresCompletos().substring(0, 1).toUpperCase() 
                     : "U";
%>

<header class="topbar">
    <div class="search-bar">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" placeholder="Buscar...">
    </div>
    
    <div class="topbar-icons">
        <i class="fa-regular fa-bell" title="Notificaciones"></i>
        <div class="avatar" title="Perfil"><%= inicial %></div>
    </div>
</header>
