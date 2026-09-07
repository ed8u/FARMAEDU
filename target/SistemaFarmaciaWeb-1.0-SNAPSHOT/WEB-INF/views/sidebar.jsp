<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%
    // Recuperamos el usuario para mostrar su nombre y rol
    Usuario usuarioSidebar = (Usuario) session.getAttribute("usuarioLogueado");
    String nombreUser = (usuarioSidebar != null) ? usuarioSidebar.getNombresCompletos() : "Usuario";
    String rolUser = (usuarioSidebar != null) ? usuarioSidebar.getRol() : "Sede Central";
%>
<nav class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
        <div>
            <h5>FARMAEDU</h5>
            <small>HEALTHCARE ERP SUITE</small>
        </div>
    </div>

    <div class="sidebar-content">
        <p class="sidebar-section">Principal</p>
        <ul class="sidebar-menu">
            <li class="nav-item"><a href="DashboardServlet" class="nav-link"><i class="fa-solid fa-border-all icon-main"></i> Dashboard General</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-desktop icon-main"></i> Punto de Venta (POS)</a></li>
        </ul>

        <p class="sidebar-section">Gestión Farmacéutica</p>
        <ul class="sidebar-menu">
            <li class="nav-item"><a href="InventarioServlet?accion=listar" class="nav-link"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario & Lotes (FEFO)</a></li>
            <li class="nav-item"><a href="MedicamentoServlet?accion=listar" class="nav-link"><i class="fa-solid fa-book-medical icon-main"></i> Catálogo Maestro</a></li>
            <li class="nav-item"><a href="ClienteServlet?accion=listar" class="nav-link"><i class="fa-solid fa-users icon-main"></i> Clientes y Pacientes</a></li>
        </ul>
    </div>

    <div class="sidebar-footer">
        <i class="fa-solid fa-user-doctor"></i>
        <div>
            <span><%= nombreUser %></span>
            <small><%= rolUser %></small>
        </div>
        <a href="LoginServlet?accion=CerrarSesion" class="logout-btn" title="Cerrar Sesión"><i class="fa-solid fa-arrow-right-from-bracket"></i></a>
    </div>
</nav>
