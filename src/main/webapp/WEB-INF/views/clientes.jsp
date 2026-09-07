<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario"%>
<%
    // Seguridad: Verificar sesión
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
    <title>Directorio de Clientes - FARMAEDU ERP</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <div class="wrapper">

        <!-- Inyección dinámica del Sidebar -->
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">

            <!-- Inyección dinámica del Topbar -->
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-id-card"></i> Farma-Edu • v1.0 </span>
                        <h2>Directorio de Clientes & Pacientes</h2>
                        <p>Gestión y registro para facturación y boletas electrónicas.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoCliente" style="background: var(--primary-color); border: none; color: white;">
                            <i class="fa-solid fa-user-plus"></i> + Nuevo Cliente / Paciente
                        </button>
                    </div>
                </div>

                <!-- Lógica JSTL para contar dinámicamente DNI y RUC -->
                <c:set var="countDNI" value="0" />
                <c:set var="countRUC" value="0" />
                <c:forEach var="c" items="${listaClientes}">
                    <c:if test="${c.dniRuc.length() == 11}">
                        <c:set var="countRUC" value="${countRUC + 1}" />
                    </c:if>
                    <c:if test="${c.dniRuc.length() != 11}">
                        <c:set var="countDNI" value="${countDNI + 1}" />
                    </c:if>
                </c:forEach>

                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Total Registrados <i class="fa-solid fa-users text-primary"></i></div>
                            <div class="metric-value text-success">${listaClientes.size() > 0 ? listaClientes.size() : '0'}</div>
                            <div class="metric-sub">Activos en base de datos.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Personas Naturales (DNI) <i class="fa-solid fa-user text-info"></i></div>
                            <div class="metric-value">${countDNI}</div>
                            <div class="metric-sub">Clientes para Boleta Electrónica.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Empresas (RUC) <i class="fa-solid fa-building text-warning"></i></div>
                            <div class="metric-value">${countRUC}</div>
                            <div class="metric-sub">Clientes para Factura Electrónica.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Integridad de Datos <i class="fa-solid fa-shield-check text-success"></i></div>
                            <div class="metric-value">100%</div>
                            <div class="metric-sub">Listos para exportación.</div>
                        </div>
                    </div>
                </div>

                <div class="panel-card mb-0">
                    <table id="tablaClientes" class="table-pos">
                        <thead>
                            <tr>
                                <th>Identificación / Doc</th>
                                <th>Paciente / Razón Social</th>
                                <th>Contacto (Email / Tel)</th>
                                <th>Dirección</th>
                                <th>Acciones Clínicas</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${listaClientes}">
                                <tr>
                                    <td>
                                        <strong class="text-dark">${c.dniRuc}</strong><br>
                                        <small class="text-muted">${c.dniRuc.length() == 11 ? 'RUC Jurídico' : 'DNI Natural'}</small>
                                    </td>
                                    <td>
                                        <div class="avatar" style="width: 30px; height: 30px; background: #0f172a; color: white; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-right: 10px; font-weight: bold; vertical-align: middle;">
                                            ${c.nombresRsocial.substring(0,1).toUpperCase()}
                                        </div>
                                        <strong class="text-dark align-middle">${c.nombresRsocial}</strong>
                                    </td>
                                    <td>
                                        <strong class="text-dark">${c.telefono}</strong><br>
                                        <small class="text-muted">${c.email}</small>
                                    </td>
                                    <td><span class="text-muted" style="font-size: 0.75rem;">${c.direccion}</span></td>
                                    <td>
                                        <i class="fa-solid fa-pen text-secondary me-3" style="cursor: pointer;" title="Editar" 
                                           onclick="abrirModalEditar('${c.idCliente}', '${c.dniRuc}', '${c.nombresRsocial}', '${c.email}', '${c.telefono}', '${c.direccion}')"></i>

                                        <a href="ClienteServlet?accion=eliminar&id=${c.idCliente}" onclick="return confirm('¿Seguro de eliminar este registro?');" style="color: #ef4444;">
                                            <i class="fa-solid fa-trash-can" title="Eliminar"></i>
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
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-plus me-2"></i>Registrar Nuevo Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Guardar">
                        
                        <!-- Añadimos el tipo de documento para coincidir con tu BD -->
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Tipo de Documento:</label>
                            <select name="txtTipoDoc" class="form-select">
                                <option value="DNI">DNI</option>
                                <option value="RUC">RUC</option>
                                <option value="CE">Carnet de Extranjería</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Número de Doc:</label>
                            <input type="text" name="txtDniRuc" class="form-control" required maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Completo / Razón Social:</label>
                            <input type="text" name="txtNombres" class="form-control" required autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Correo Electrónico:</label>
                            <input type="email" name="txtEmail" class="form-control" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Teléfono:</label>
                            <input type="text" name="txtTelefono" class="form-control" maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Dirección:</label>
                            <input type="text" name="txtDireccion" class="form-control" autocomplete="off">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Guardar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Cliente -->
    <div class="modal fade" id="modalEditarCliente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header text-white" style="background-color: #0f172a;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen me-2"></i>Editar Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">
                        
                        <!-- Select estático ya que editaremos el número, asumimos DNI por defecto si se edita (mejorar con JS si se desea) -->
                        <input type="hidden" name="txtTipoDoc" value="DNI">

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Número de Doc:</label>
                            <input type="text" name="txtDniRuc" id="editDni" class="form-control" required maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Completo / Razón Social:</label>
                            <input type="text" name="txtNombres" id="editNombres" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Correo Electrónico:</label>
                            <input type="email" name="txtEmail" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Teléfono:</label>
                            <input type="text" name="txtTelefono" id="editTelefono" class="form-control" maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Dirección:</label>
                            <input type="text" name="txtDireccion" id="editDireccion" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-dark fw-bold">Actualizar Registro</button>
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaClientes').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-3"Bf>rt<"d-flex justify-content-between mt-3"ip>',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa-solid fa-file-excel me-1"></i> Exportar a Excel',
                        className: 'btn btn-success text-white fw-bold shadow-sm border-0 btn-sm',
                        title: 'Directorio de Clientes - FARMAEDU',
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
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarCliente'));
            myModal.show();
        }
    </script>
</body>
</html>
