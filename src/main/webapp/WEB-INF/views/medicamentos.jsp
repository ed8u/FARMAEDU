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
    <title>Catálogo Médico - FARMAEDU </title>

    <!-- Bootstrap 5 CSS & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <div class="wrapper">

        <!-- INYECCIÓN DINÁMICA DEL SIDEBAR -->
        <jsp:include page="sidebar.jsp" />

        <!-- CONTENIDO PRINCIPAL -->
        <main class="main-content">

            <!-- INYECCIÓN DINÁMICA DEL TOPBAR -->
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-pills"></i> FarmaEdu V1.0 • </span>
                        <h2>Catálogo Maestro de Medicamentos</h2>
                        <p>Gestión de SKUs, precios, recetas y control de stock mínimo.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoMedicamento">
                            <i class="fa-solid fa-box-open"></i> + Nuevo Medicamento
                        </button>
                    </div>
                </div>

                <!-- Lógica JSTL para contar dinámicamente Medicamentos con/sin receta -->
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

                <!-- KPIs -->
                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Total SKUs <i class="fa-solid fa-boxes-stacked text-primary"></i></div>
                            <div class="metric-value text-success">${listaMedicamentos.size() > 0 ? listaMedicamentos.size() : '0'}</div>
                            <div class="metric-sub">Productos en el catálogo.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header text-danger">Con Receta (Rx) <i class="fa-solid fa-file-prescription text-danger"></i></div>
                            <div class="metric-value text-dark">${countReceta}</div>
                            <div class="metric-sub">Venta controlada.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header text-success">Venta Libre (OTC) <i class="fa-solid fa-basket-shopping text-success"></i></div>
                            <div class="metric-value text-dark">${countLibre}</div>
                            <div class="metric-sub">Sin restricción comercial.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Integridad de Precios <i class="fa-solid fa-tags text-warning"></i></div>
                            <div class="metric-value text-dark">100%</div>
                            <div class="metric-sub">Márgenes validados.</div>
                        </div>
                    </div>
                </div>

                <!-- TABLA DATA TABLES -->
                <div class="panel-card mb-0 mt-4">
                    <table id="tablaMedicamentos" class="table-pos">
                        <thead>
                            <tr>
                                <th>Código Barras</th>
                                <th>Medicamento / Concentración</th>
                                <th>Laboratorio / Categoría</th>
                                <th>Condición</th>
                                <th>Precio Venta</th>
                                <th>Stock Total</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${listaMedicamentos}">
                                <tr>
                                    <td><strong>${m.codigoBarras}</strong></td>
                                    <td>
                                        <div style="line-height: 1.2;">
                                            <strong class="text-dark">${m.nombreComercial}</strong><br>
                                            <small class="text-muted">${m.nombrePrincipio} | ${m.concentracion}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="line-height: 1.2;">
                                            <strong class="text-dark">${m.nombreLaboratorio}</strong><br>
                                            <small class="text-muted">${m.nombreCategoria}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${m.recetaObligatoria}">
                                            <span style="background: #fee2e2; color: #991b1b; font-size: 0.65rem; font-weight: 700; padding: 3px 6px; border-radius: 4px; border: 1px solid #f87171;"><i class="fa-solid fa-file-signature"></i> Rx Obligatoria</span>
                                        </c:if>
                                        <c:if test="${!m.recetaObligatoria}">
                                            <span style="background: #dcfce7; color: #166534; font-size: 0.65rem; font-weight: 700; padding: 3px 6px; border-radius: 4px; border: 1px solid #4ade80;"><i class="fa-solid fa-basket-shopping"></i> Libre (OTC)</span>
                                        </c:if>
                                    </td>
                                    <td><strong class="text-dark">S/ ${String.format("%.2f", m.precioVenta)}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.stockTotal <= m.stockMinimo}">
                                                <span class="text-danger fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ${m.stockTotal} unid.</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-success fw-bold">${m.stockTotal} unid.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="fa-solid fa-pen text-secondary me-3" style="cursor: pointer;" title="Editar" 
                                           onclick="abrirModalEditar('${m.idMedicamento}', '${m.codigoBarras}', '${m.nombreComercial}', '${m.idPrincipio}', '${m.idForma}', '${m.concentracion}', '${m.idPresentacion}', '${m.idLaboratorio}', '${m.idCategoria}', '${m.recetaObligatoria}', '${m.precioCompraRef}', '${m.precioVenta}', '${m.stockMinimo}')"></i>

                                        <a href="MedicamentoServlet?accion=eliminar&id=${m.idMedicamento}" onclick="return confirm('¿Seguro de eliminar este medicamento?');" style="color: #ef4444;">
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

    <!-- ========================================================== -->
    <!-- MODALS CON SELECTS DINÁMICOS -->
    <!-- ========================================================== -->

    <!-- Modal Nuevo Medicamento -->
    <div class="modal fade" id="modalNuevoMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-box-open me-2"></i>Registrar Nuevo Medicamento</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Guardar">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Código de Barras:</label>
                                <input type="text" name="txtCodigo" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Comercial:</label>
                                <input type="text" name="txtNombre" class="form-control" required autocomplete="off">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Principio Activo (DCI):</label>
                                <select name="cboPrincipio" class="form-select" required>
                                    <option value="" disabled selected>-- Seleccione --</option>
                                    <c:forEach var="p" items="${listaPrincipios}">
                                        <option value="${p.idPrincipio}">${p.nombrePrincipio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Forma Farmacéutica:</label>
                                <select name="cboForma" class="form-select" required>
                                    <option value="" disabled selected>-- Seleccione --</option>
                                    <c:forEach var="f" items="${listaFormas}">
                                        <option value="${f.idForma}">${f.nombreForma}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Concentración (Ej: 500mg):</label>
                                <input type="text" name="txtConcentracion" class="form-control" required autocomplete="off">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Presentación:</label>
                                <select name="cboPresentacion" class="form-select" required>
                                    <option value="" disabled selected>-- Seleccione --</option>
                                    <c:forEach var="pr" items="${listaPresentaciones}">
                                        <option value="${pr.idPresentacion}">${pr.nombrePresentacion}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Laboratorio:</label>
                                <select name="cboLaboratorio" class="form-select" required>
                                    <option value="" disabled selected>-- Seleccione --</option>
                                    <c:forEach var="l" items="${listaLaboratorios}">
                                        <option value="${l.idLaboratorio}">${l.nombreLaboratorio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Categoría:</label>
                                <select name="cboCategoria" class="form-select" required>
                                    <option value="" disabled selected>-- Seleccione --</option>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <option value="${cat.idCategoria}">${cat.nombreCategoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-1">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Precio Compra (Ref):</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-success" style="font-size: 0.8rem;">Precio Venta:</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-danger" style="font-size: 0.8rem;">Stock Mínimo:</label>
                                <input type="number" name="txtStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="chkRecetaNuevo">
                            <label class="form-check-label fw-bold text-danger" for="chkRecetaNuevo" style="font-size: 0.85rem;">
                                Requiere Receta Médica Obligatoria (Rx)
                            </label>
                        </div>

                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Guardar Medicamento</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Medicamento -->
    <div class="modal fade" id="modalEditarMedicamento" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header text-white" style="background-color: #0f172a;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen me-2"></i>Editar Medicamento</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="MedicamentoServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Código de Barras:</label>
                                <input type="text" name="txtCodigo" id="editCodigo" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Comercial:</label>
                                <input type="text" name="txtNombre" id="editNombre" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Principio Activo:</label>
                                <select name="cboPrincipio" id="editPrincipio" class="form-select" required>
                                    <c:forEach var="p" items="${listaPrincipios}">
                                        <option value="${p.idPrincipio}">${p.nombrePrincipio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Forma Farmacéutica:</label>
                                <select name="cboForma" id="editForma" class="form-select" required>
                                    <c:forEach var="f" items="${listaFormas}">
                                        <option value="${f.idForma}">${f.nombreForma}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Concentración:</label>
                                <input type="text" name="txtConcentracion" id="editConcentracion" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Presentación:</label>
                                <select name="cboPresentacion" id="editPresentacion" class="form-select" required>
                                    <c:forEach var="pr" items="${listaPresentaciones}">
                                        <option value="${pr.idPresentacion}">${pr.nombrePresentacion}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Laboratorio:</label>
                                <select name="cboLaboratorio" id="editLaboratorio" class="form-select" required>
                                    <c:forEach var="l" items="${listaLaboratorios}">
                                        <option value="${l.idLaboratorio}">${l.nombreLaboratorio}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Categoría:</label>
                                <select name="cboCategoria" id="editCategoria" class="form-select" required>
                                    <c:forEach var="cat" items="${listaCategorias}">
                                        <option value="${cat.idCategoria}">${cat.nombreCategoria}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row border-top pt-3 mt-1">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold" style="font-size: 0.8rem;">Precio Compra:</label>
                                <input type="number" step="0.01" name="txtPrecioCompra" id="editPrecioCompra" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-success" style="font-size: 0.8rem;">Precio Venta:</label>
                                <input type="number" step="0.01" name="txtPrecioVenta" id="editPrecioVenta" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold text-danger" style="font-size: 0.8rem;">Stock Mínimo:</label>
                                <input type="number" name="txtStockMinimo" id="editStockMinimo" class="form-control" required>
                            </div>
                        </div>

                        <div class="form-check mt-2">
                            <input class="form-check-input" type="checkbox" name="chkReceta" value="1" id="editReceta">
                            <label class="form-check-label fw-bold text-danger" for="editReceta" style="font-size: 0.85rem;">
                                Requiere Receta Médica Obligatoria (Rx)
                            </label>
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

    <!-- Scripts DataTables y Bootstrap -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#tablaMedicamentos').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                pageLength: 10
            });
        });

        // Función para cargar los datos en el Modal de Edición
        function abrirModalEditar(id, codigo, nombre, principio, forma, concentracion, presentacion, lab, cat, receta, precioC, precioV, stock) {
            document.getElementById('editId').value = id;
            document.getElementById('editCodigo').value = codigo;
            document.getElementById('editNombre').value = nombre;
            
            // Los Selects ahora sí coincidirán con los IDs reales de la base de datos
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
            
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarMedicamento'));
            myModal.show();
        }
    </script>
</body>
</html>
