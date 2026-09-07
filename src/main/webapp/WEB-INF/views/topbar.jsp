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
        <input type="text" placeholder="Búsqueda rápida en todo el ERP...">
    </div>
    <div class="topbar-info">
        <span><i class="fa-solid fa-store me-1 text-success"></i> Sucursal Principal</span>
        <span><i class="fa-regular fa-clock me-1 text-success"></i> Turno Mañana (Caja 01)</span>
    </div>
    <div class="topbar-icons">
        <i class="fa-regular fa-bell"></i>
        <div class="avatar"><%= inicial %></div>
    </div>
</header>
