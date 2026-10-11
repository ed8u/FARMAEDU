<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Medicamentos - FARMAEDU</title>

    <!-- Bootstrap 5 CSS & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- DataTables CSS -->
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
                        <h2>Catálogo de Medicamentos</h2>
                    </div>
                    <button class="btn-action-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoMedicamento">
                        <i class="fa-solid fa-plus me-1"></i> Nuevo Medicamento
                    </button>
                </div>

                <c:set var="countReceta" value="0" />
                <c:set var="countLibre" value="0" />
                <c:forEach var="m" items="${listaMedicamentos}">
                    <c:if test="${m.recetaObligatoria}">
                        <c:set var="countReceta" value="${countReceta + 1}" />
                    </c:if>
                    <c:if test="${!m.recetaObligatoria}">
                        <c:set var="countLibre" value="${countLibre + 1}" />
                    </c:if>
                </c:forEach>

                <!-- Tarjetas de métricas -->
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-boxes-stacked metric-icon"></i>
                            <div class="metric-data">
                                <span class="metric-value">${listaMedicamentos.size()}</span>
                                <span class="metric-title">Total</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-file-prescription metric-icon text-danger" style="opacity: 0.7;"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countReceta}</span>
                                <span class="metric-title">Con Receta</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="metric-card">
                            <i class="fa-solid fa-shield-halved metric-icon text-success" style="opacity: 0.7;"></i>
                            <div class="metric-data">
                                <span class="metric-value">${countLibre}</span>
                                <span class="metric-title">Venta Libre</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabla -->
                <div class="panel-card">
                    <table id="tablaMedicamentos" class="table-pos">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Medicamento</th>
                                <th>Detalle / Lab</th>
                                <th>Condición</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${listaMedicamentos}">
                                <tr>
                                    <td><strong>${m.codigoBarras}</strong></td>
                                    <td>
                                        <div>
                                            <strong class="text-dark">${m.nombreComercial}</strong>
                                            <div class="text-muted" style="font-size: 0.75rem;">${m.nombrePrincipio} • ${m.concentracion}</div>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <span class="text-dark fw-medium">${m.nombreLaboratorio}</span>
                                            <div class="text-muted" style="font-size: 0.75rem;">${m.nombreCategoria}</div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${m.recetaObligatoria}">
                                            <span class="badge-condicion badge-rx"><i class="fa-solid fa-file-prescription"></i> Rx</span>
                                        </c:if>
                                        <c:if test="${!m.recetaObligatoria}">
                                            <span class="badge-condicion badge-otc"><i class="fa-solid fa-check"></i> Libre</span>
                                        </c:if>
                                    </td>
                                    <td><strong class="text-dark">S/ ${String.format("%.2f", m.precioVenta)}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.stockTotal <= m.stockMinimo}">
                                                <span class="stock-badge-low"><i class="fa-solid fa-circle-exclamation me-1"></i>${m.stockTotal}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-success fw-bold">${m.stockTotal}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="fa-solid fa-pen action-icon" title="Editar" 
                                           onclick="abrirModalEditar('${m.idMedicamento}', '${m.codigoBarras}', '${m.nombreComercial}', '${m.idPrincipio}', '${m.idForma}', '${m.concentracion}', '${m.idPresentacion}', '${m.idLaboratorio}', '${m.idCategoria}', '${m.recetaObligatoria}', '${m.precioCompraRef}', '${m.precioVenta}', '${m.stockMinimo}')"></i>

                                        <a href="MedicamentoServlet?accion=eliminar&id=${m.idMedicamento}" onclick="return confirm('¿Eliminar medicamento?');">
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

    <!-- Modal Nuevo Medicamento -->
    <div class="modal fade" id="modalNuevoMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Nuevo Medicamento</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Guardar">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Código de Barras</label>
                                <input type="text" name="txtCodigo" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Comercial</label>
                                <input type="text" name="txtNombre" class="form-control" required autocomplete="off">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Principio Activo</label>
                                <select name="cboPrincipio" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="p" items="${listaPrincipios}">
                                        <option value="${p.idPrincipio}">${p.nombrePrincipio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Forma Farmacéutica</label>
                                <select name="cboForma" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="f" items="${listaFormas}">
                                        <option value="${f.idForma}">${f.nombreForma}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Concentración</label>
                                <input type="text" name="txtConcentracion" class="form-control" placeholder="Ej: 500mg" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Presentación</label>
                                <select name="cboPresentacion" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="pr" items="${listaPresentaciones}">
                                        <option value="${pr.idPresentacion}">${pr.nombrePresentacion}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Laboratorio</label>
                                <select name="cboLaboratorio" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="l" items="${listaLaboratorios}">
                                        <option value="${l.idLaboratorio}">${l.nombreLaboratorio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Categoría</label>
                                <select name="cboCategoria" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <option value="${cat.idCategoria}">${cat.nombreCategoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-2">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Precio Compra</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Precio Venta</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Stock Mínimo</label>
                                <input type="number" name="txtStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-1">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="chkRecetaNuevo">
                            <label class="form-check-label text-danger fw-semibold" for="chkRecetaNuevo" style="font-size: 0.85rem;">
                                Requiere receta médica
                            </label>
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

    <!-- Modal Editar Medicamento -->
    <div class="modal fade" id="modalEditarMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-0">
                    <h5 class="modal-title fw-bold">Editar Medicamento</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Código de Barras</label>
                                <input type="text" name="txtCodigo" id="editCodigo" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Nombre Comercial</label>
                                <input type="text" name="txtNombre" id="editNombre" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Principio Activo</label>
                                <select name="cboPrincipio" id="editPrincipio" class="form-select" required>
                                    <c:forEach var="p" items="${listaPrincipios}">
                                        <option value="${p.idPrincipio}">${p.nombrePrincipio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Forma Farmacéutica</label>
                                <select name="cboForma" id="editForma" class="form-select" required>
                                    <c:forEach var="f" items="${listaFormas}">
                                        <option value="${f.idForma}">${f.nombreForma}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Concentración</label>
                                <input type="text" name="txtConcentracion" id="editConcentracion" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Presentación</label>
                                <select name="cboPresentacion" id="editPresentacion" class="form-select" required>
                                    <c:forEach var="pr" items="${listaPresentaciones}">
                                        <option value="${pr.idPresentacion}">${pr.nombrePresentacion}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Laboratorio</label>
                                <select name="cboLaboratorio" id="editLaboratorio" class="form-select" required>
                                    <c:forEach var="l" items="${listaLaboratorios}">
                                        <option value="${l.idLaboratorio}">${l.nombreLaboratorio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Categoría</label>
                                <select name="cboCategoria" id="editCategoria" class="form-select" required>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <option value="${cat.idCategoria}">${cat.nombreCategoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-2">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Precio Compra</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" id="editPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Precio Venta</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" id="editPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Stock Mínimo</label>
                                <input type="number" name="txtStockMinimo" id="editStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-1">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="editReceta">
                            <label class="form-check-label text-danger fw-semibold" for="editReceta" style="font-size: 0.85rem;">
                                Requiere receta médica
                            </label>
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

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaMedicamentos').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-4"f>rt<"d-flex justify-content-between mt-4"ip>',
                pageLength: 10
            });
        });

        function abrirModalEditar(id, codigo, nombre, principio, forma, concentracion, presentacion, lab, cat, receta, precioC, precioV, stock) {
            document.getElementById('editId').value = id;
            document.getElementById('editCodigo').value = codigo;
            document.getElementById('editNombre').value = nombre;
            
            document.getElementById('editPrincipio').value = principio;
            document.getElementById('editForma').value = forma;
            document.getElementById('editConcentracion').value = concentracion;
            document.getElementById('editPresentacion').value = presentacion;
            document.getElementById('editLaboratorio').value = lab;
            document.getElementById('editCategoria').value = cat;
            
            document.getElementById('editPrecioCompra').value = precioC;
            document.getElementById('editPrecioVenta').value = precioV;
            document.getElementById('editStockMinimo').value = stock;
            
            document.getElementById('editReceta').checked = (receta === 'true');
            
            new bootstrap.Modal(document.getElementById('modalEditarMedicamento')).show();
        }
    </script>
</body>
</html>