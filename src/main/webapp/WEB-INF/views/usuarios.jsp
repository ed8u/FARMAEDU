<%-- 
    Document   : usuarios
    Created on : 4 oct 2026, 3:11:46 p.m.
    Author     : javie
--%>

<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Usuario usrSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usrSesion == null || !usrSesion.getRol().equalsIgnoreCase("ADMINISTRADOR")) {
        response.sendRedirect("DashboardServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - FARMAEDU ERP</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <div class="wrapper">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-shield-halved"></i> Seguridad Interna • </span>
                        <h2>Gestión de Usuarios y Accesos</h2>
                        <p>Control de credenciales y roles para administradores y vendedores.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario" style="background: var(--primary-color); border: none; color: white;">
                            <i class="fa-solid fa-user-plus"></i> + Nuevo Usuario
                        </button>
                    </div>
                </div>

                <c:set var="countAdmin" value="0" />
                <c:set var="countVend" value="0" />
                <c:forEach var="u" items="${listaUsuarios}">
                    <c:if test="${u.rol == 'ADMINISTRADOR'}"><c:set var="countAdmin" value="${countAdmin + 1}" /></c:if>
                    <c:if test="${u.rol == 'VENDEDOR'}"><c:set var="countVend" value="${countVend + 1}" /></c:if>
                </c:forEach>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="metric-card">
                            <div class="metric-header">Personal Activo <i class="fa-solid fa-users text-primary"></i></div>
                            <div class="metric-value text-success">${listaUsuarios.size()}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <div class="metric-header">Administradores <i class="fa-solid fa-user-tie text-danger"></i></div>
                            <div class="metric-value">${countAdmin}</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <div class="metric-header">Vendedores (Caja) <i class="fa-solid fa-cash-register text-info"></i></div>
                            <div class="metric-value">${countVend}</div>
                        </div>
                    </div>
                </div>

                <div class="panel-card mb-0">
                    <table id="tablaUsuarios" class="table-pos">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombres Completos</th>
                                <th>Usuario (Login)</th>
                                <th>Rol de Acceso</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${listaUsuarios}">
                                <tr>
                                    <td><strong>#${u.idUsuario}</strong></td>
                                    <td>
                                        <div class="avatar" style="width: 30px; height: 30px; background: #0f172a; color: white; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-right: 10px; font-weight: bold; vertical-align: middle;">
                                            ${u.nombresCompletos.substring(0,1).toUpperCase()}
                                        </div>
                                        <strong class="text-dark align-middle">${u.nombresCompletos}</strong>
                                    </td>
                                    <td><strong>${u.usuario}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.rol == 'ADMINISTRADOR'}">
                                                <span class="badge bg-danger">ADMINISTRADOR</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info text-dark">VENDEDOR</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <!-- Evita que el admin logueado se elimine a sí mismo por error -->
                                        <i class="fa-solid fa-pen text-secondary me-3" style="cursor: pointer;" title="Editar" 
                                           onclick="abrirModalEditar('${u.idUsuario}', '${u.nombresCompletos}', '${u.usuario}', '${u.password}', '${u.rol}')"></i>
                                        
                                        <c:if test="${u.idUsuario != usuarioLogueado.idUsuario}">
                                            <a href="UsuarioServlet?accion=eliminar&id=${u.idUsuario}" onclick="return confirm('¿Bloquear acceso a este usuario?');" style="color: #ef4444;">
                                                <i class="fa-solid fa-user-lock" title="Bloquear/Eliminar"></i>
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal Nuevo Usuario -->
    <div class="modal fade" id="modalNuevoUsuario" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-plus me-2"></i>Registrar Personal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="UsuarioServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Guardar">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombres y Apellidos:</label>
                            <input type="text" name="txtNombres" class="form-control" required autocomplete="off">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Usuario (Login):</label>
                                <input type="text" name="txtUsuario" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Contraseña:</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Rol de Acceso:</label>
                            <select name="cboRol" class="form-select" required>
                                <option value="VENDEDOR">Vendedor / Cajero</option>
                                <option value="ADMINISTRADOR">Administrador</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Crear Accesos</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header text-white" style="background-color: #0f172a;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen me-2"></i>Editar Credenciales</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="UsuarioServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombres y Apellidos:</label>
                            <input type="text" name="txtNombres" id="editNombres" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Usuario (Login):</label>
                                <input type="text" name="txtUsuario" id="editUsuario" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Contraseña:</label>
                                <input type="text" name="txtPassword" id="editPassword" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Rol de Acceso:</label>
                            <select name="cboRol" id="editRol" class="form-select" required>
                                <option value="VENDEDOR">Vendedor / Cajero</option>
                                <option value="ADMINISTRADOR">Administrador</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-dark fw-bold">Actualizar Datos</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaUsuarios').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                pageLength: 10
            });
        });

        function abrirModalEditar(id, nombres, user, pass, rol) {
            document.getElementById('editId').value = id;
            document.getElementById('editNombres').value = nombres;
            document.getElementById('editUsuario').value = user;
            document.getElementById('editPassword').value = pass;
            document.getElementById('editRol').value = rol;
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarUsuario'));
            myModal.show();
        }
    </script>
</body>
</html>