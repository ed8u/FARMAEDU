<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSidebar = (Usuario) session.getAttribute("usuarioLogueado");
    String nombreUser = (usuarioSidebar != null) ? usuarioSidebar.getNombresCompletos() : "Usuario";
    String rolUser = (usuarioSidebar != null) ? usuarioSidebar.getRol().toUpperCase() : "INVITADO";
%>

<nav class="sidebar">
    <div class="sidebar-header">
        <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
        <div>
            <h5>FARMAEDU</h5>
        </div>
    </div>

    <div class="sidebar-content">
        <p class="sidebar-section">Principal</p>
        <ul class="sidebar-menu">
            <li class="nav-item"><a href="DashboardServlet" class="nav-link"><i class="fa-solid fa-border-all icon-main"></i> Dashboard</a></li>
            <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-desktop icon-main"></i> POS / Ventas</a></li>
            <li class="nav-item"><a href="ClienteServlet?accion=listar" class="nav-link"><i class="fa-solid fa-users icon-main"></i> Clientes</a></li>
            <li class="nav-item"><a href="MedicamentoServlet?accion=listar" class="nav-link"><i class="fa-solid fa-pills icon-main"></i> Medicamentos</a></li>
        </ul>

        <% if ("ADMINISTRADOR".equals(rolUser) || "ADMIN".equals(rolUser)) { %>
            <p class="sidebar-section">Administración</p>
            <ul class="sidebar-menu">
                <li class="nav-item"><a href="InventarioServlet?accion=listar" class="nav-link"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario</a></li>
                <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-chart-simple icon-main"></i> Reportes</a></li>
                <li class="nav-item"><a href="UsuarioServlet?accion=listar" class="nav-link"><i class="fa-solid fa-user-shield icon-main"></i> Usuarios</a></li>
            </ul>
        <% } %>
    </div>

    <div class="sidebar-footer">
        <div class="footer-avatar"><%= nombreUser.substring(0, 1).toUpperCase() %></div>
        <div class="footer-info">
            <span><%= nombreUser %></span>
            <small><%= rolUser %></small>
        </div>
        <a href="LoginServlet?accion=CerrarSesion" class="logout-btn" title="Cerrar Sesión">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
        </a>
    </div>
</nav>