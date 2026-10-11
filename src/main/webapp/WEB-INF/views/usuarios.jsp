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
    <title>Usuarios - FARMAEDU</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="wrapper">
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <!-- Header de la página -->
                <div class="page-header">
                    <div class="page-title">
                        <h2>Gestión de Usuarios</h2>
                    </div>
                    <button class="btn-action-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario">
                        <i class="fa-solid fa-plus me-1"></i> Nuevo Usuario
                    </button>
                </div>

                <!-- Lógica JSTL -->
                <c:set var="countAdmin" value="0" />
                <c:set var="countVend" value="0" />
                <c:forEach var="u" items="${listaUsuarios}">
                    <c:if test="${u.rol == 'ADMINISTRADOR'}"><c:set var="countAdmin" value="${countAdmin + 1}" /></c:if>
                    <c:if test="${u.rol == 'VENDEDOR'}"><c:set var="countVend" value="${countVend + 1}" /></c:if>
                </c:forEach>

                <!-- Tarjetas de métricas -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-users metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${listaUsuarios.size()}</span>
                                <span class="metric-title">Total</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-user-tie metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countAdmin}</span>
                                <span class="metric-title">Administradores</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-cash-register metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countVend}</span>
                                <span class="metric-title">Vendedores</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla -->
                <div class="panel-card">
                    <table id="tablaUsuarios" class="table-pos">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Usuario</th>
                                <th>Rol</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${listaUsuarios}">
                                <tr>
                                    <td><strong>#${u.idUsuario}</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar">${u.nombresCompletos.substring(0,1).toUpperCase()}</div>
                                            <strong class="text-dark">${u.nombresCompletos}</strong>
                                        </div>
                                    </td>
                                    <td>${u.usuario}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.rol == 'ADMINISTRADOR'}">
                                                <span class="badge-rol badge-admin">ADMINISTRADOR</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-rol badge-vendedor">VENDEDOR</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="fa-solid fa-pen action-icon" title="Editar" 
                                           onclick="abrirModalEditar('${u.idUsuario}', '${u.nombresCompletos}', '${u.usuario}', '${u.password}', '${u.rol}')"></i>

                                        <c:if test="${u.idUsuario != usuarioLogueado.idUsuario}">
                                            <a href="UsuarioServlet?accion=eliminar&id=${u.idUsuario}" onclick="return confirm('¿Bloquear acceso a este usuario?');">
                                                <i class="fa-solid fa-lock action-icon delete" title="Bloquear"></i>
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
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Nuevo Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="UsuarioServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Guardar">

                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Completo</label>
                            <input type="text" name="txtNombres" class="form-control" required autocomplete="off">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Usuario (Login)</label>
                                <input type="text" name="txtUsuario" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Contraseña</label>
                                <input type="password" name="txtPassword" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Rol de Acceso</label>
                            <select name="cboRol" class="form-select" required>
                                <option value="VENDEDOR">Vendedor</option>
                                <option value="ADMINISTRADOR">Administrador</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary btn-action-primary">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Usuario -->
    <div class="modal fade" id="modalEditarUsuario" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Editar Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="UsuarioServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">

                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Completo</label>
                            <input type="text" name="txtNombres" id="editNombres" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Usuario (Login)</label>
                                <input type="text" name="txtUsuario" id="editUsuario" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Contraseña</label>
                                <input type="text" name="txtPassword" id="editPassword" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Rol de Acceso</label>
                            <select name="cboRol" id="editRol" class="form-select" required>
                                <option value="VENDEDOR">Vendedor</option>
                                <option value="ADMINISTRADOR">Administrador</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-dark">Actualizar</button>
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
                dom: '<"d-flex justify-content-between align-items-center mb-4"f>rt<"d-flex justify-content-between mt-4"ip>',
                pageLength: 10
            });
        });

        function abrirModalEditar(id, nombres, user, pass, rol) {
            document.getElementById('editId').value = id;
            document.getElementById('editNombres').value = nombres;
            document.getElementById('editUsuario').value = user;
            document.getElementById('editPassword').value = pass;
            document.getElementById('editRol').value = rol;
            new bootstrap.Modal(document.getElementById('modalEditarUsuario')).show();
        }
    </script>
</body>
</html>