<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes - FARMAEDU</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
<body>

    <div class="wrapper">

        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <h2>Gestión de Clientes</h2>
                    </div>
                    <button class="btn-action-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoCliente">
                        <i class="fa-solid fa-plus me-1"></i> Nuevo Cliente
                    </button>
                </div>

                <!-- Lógica JSTL -->
                <c:set var="countDNI" value="0" />
                <c:set var="countRUC" value="0" />
                <c:forEach var="c" items="${listaClientes}">
                    <c:if test="${c.dniRuc.length() == 11}"><c:set var="countRUC" value="${countRUC + 1}" /></c:if>
                    <c:if test="${c.dniRuc.length() != 11}"><c:set var="countDNI" value="${countDNI + 1}" /></c:if>
                </c:forEach>

                <!-- Tarjetas de métricas -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-users metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${listaClientes.size()}</span>
                                <span class="metric-title">Total</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-id-card metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countDNI}</span>
                                <span class="metric-title">DNI</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-building metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countRUC}</span>
                                <span class="metric-title">RUC</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla -->
                <div class="panel-card">
                    <table id="tablaClientes" class="table-pos">
                        <thead>
                            <tr>
                                <th>Documento</th>
                                <th>Cliente</th>
                                <th>Contacto</th>
                                <th>Dirección</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${listaClientes}">
                                <tr>
                                    <td><strong>${c.dniRuc}</strong></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar">${c.nombresRsocial.substring(0,1).toUpperCase()}</div>
                                            <strong class="text-dark">${c.nombresRsocial}</strong>
                                        </div>
                                    </td>
                                    <td>
                                        <div>${c.telefono}</div>
                                        <div class="text-muted" style="font-size: 0.75rem;">${c.email}</div>
                                    </td>
                                    <td><span class="text-muted">${c.direccion}</span></td>
                                    <td>
                                        <i class="fa-solid fa-pen action-icon" title="Editar" 
                                           onclick="abrirModalEditar('${c.idCliente}', '${c.dniRuc}', '${c.nombresRsocial}', '${c.email}', '${c.telefono}', '${c.direccion}')"></i>
                                        <a href="ClienteServlet?accion=eliminar&id=${c.idCliente}" onclick="return confirm('¿Eliminar cliente?');">
                                            <i class="fa-solid fa-trash action-icon delete" title="Eliminar"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal Nuevo Cliente -->
    <div class="modal fade" id="modalNuevoCliente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Nuevo Cliente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Guardar">
                        
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Tipo de Documento</label>
                            <select name="txtTipoDoc" class="form-select">
                                <option value="DNI">DNI</option>
                                <option value="RUC">RUC</option>
                                <option value="CE">CE</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Documento</label>
                            <input type="text" name="txtDniRuc" class="form-control" required maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Completo</label>
                            <input type="text" name="txtNombres" class="form-control" required autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Correo</label>
                            <input type="email" name="txtEmail" class="form-control" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Teléfono</label>
                            <input type="text" name="txtTelefono" class="form-control" maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Dirección</label>
                            <input type="text" name="txtDireccion" class="form-control" autocomplete="off">
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

    <!-- Modal Editar Cliente -->
    <div class="modal fade" id="modalEditarCliente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Editar Cliente</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">
                        <input type="hidden" name="txtTipoDoc" value="DNI">

                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Documento</label>
                            <input type="text" name="txtDniRuc" id="editDni" class="form-control" required maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Completo</label>
                            <input type="text" name="txtNombres" id="editNombres" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Correo</label>
                            <input type="email" name="txtEmail" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Teléfono</label>
                            <input type="text" name="txtTelefono" id="editTelefono" class="form-control" maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-muted" style="font-size: 0.8rem;">Dirección</label>
                            <input type="text" name="txtDireccion" id="editDireccion" class="form-control">
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
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaClientes').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-4"Bf>rt<"d-flex justify-content-between mt-4"ip>',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa-solid fa-file-excel me-1"></i> Excel',
                        className: 'btn btn-light border btn-sm text-dark fw-bold',
                        title: 'Clientes',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    }
                ],
                pageLength: 10
            });
        });

        function abrirModalEditar(id, dni, nombres, email, tel, dir) {
            document.getElementById('editId').value = id;
            document.getElementById('editDni').value = dni;
            document.getElementById('editNombres').value = nombres;
            document.getElementById('editEmail').value = email;
            document.getElementById('editTelefono').value = tel;
            document.getElementById('editDireccion').value = dir;
            new bootstrap.Modal(document.getElementById('modalEditarCliente')).show();
        }
    </script>
</body>
</html>