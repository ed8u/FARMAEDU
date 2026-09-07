<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    LocalDate hoy = LocalDate.now();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario & Lotes FEFO - FARMAEDU</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <div class="wrapper">

        <!-- Inyección del Sidebar -->
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">

            <!-- Inyección del Topbar -->
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-boxes-stacked"></i> Trazabilidad Sanitaria • </span>
                        <h2>Control de Inventario y Lotes (FEFO)</h2>
                        <p>Despacho priorizado según fecha de expiración y registro de ingresos.</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoLote" style="background: var(--primary-color); border: none; color: white;">
                            <i class="fa-solid fa-plus"></i> + Ingresar Nuevo Lote
                        </button>
                    </div>
                </div>

                <div class="panel-card mb-0">
                    <table id="tablaLotes" class="table-pos">
                        <thead>
                            <tr>
                                <th>N° Lote</th>
                                <th>Medicamento</th>
                                <th>Fecha Vencimiento</th>
                                <th>Estado Sanitario</th>
                                <th>Stock Actual</th>
                                <th>Fecha Ingreso</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lote" items="${listaLotes}">
                                <%
                                    pe.edu.utp.SistemaFarmaciaWeb.modelo.LoteMedicamento currentLote = (pe.edu.utp.SistemaFarmaciaWeb.modelo.LoteMedicamento) pageContext.getAttribute("lote");
                                    long diasRestantes = ChronoUnit.DAYS.between(hoy, currentLote.getFechaVencimiento());
                                    request.setAttribute("diasRestantes", diasRestantes);
                                %>
                                <tr>
                                    <td><strong class="text-dark">${lote.numeroLote}</strong></td>
                                    <td>
                                        <strong class="text-dark">${lote.nombreMedicamento}</strong><br>
                                        <small class="text-muted">Cód: ${lote.codigoBarras}</small>
                                    </td>
                                    <td><strong>${lote.fechaVencimiento}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${diasRestantes <= 0}">
                                                <span class="badge bg-danger text-white"><i class="fa-solid fa-ban me-1"></i> VENCIDO</span>
                                            </c:when>
                                            <c:when test="${diasRestantes <= 60}">
                                                <span class="badge bg-warning text-dark"><i class="fa-solid fa-triangle-exclamation me-1"></i> Por vencer (${diasRestantes} d)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-success text-white"><i class="fa-solid fa-circle-check me-1"></i> Vigente (${diasRestantes} d)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lote.stockActual <= 10}">
                                                <span class="text-danger fw-bold">${lote.stockActual} unid.</span>
                                            </c:when>
                                            <c:otherwise>
                                                <strong class="text-dark">${lote.stockActual} unid.</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="text-muted" style="font-size: 0.75rem;">${lote.fechaIngreso.toLocalDate()}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal Registrar Nuevo Lote -->
    <div class="modal fade" id="modalNuevoLote" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-boxes-packing me-2"></i>Ingreso de Mercadería / Lote</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="InventarioServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="RegistrarLote">

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Medicamento:</label>
                            <select name="cboMedicamento" class="form-select" required>
                                <option value="" disabled selected>-- Seleccione Medicamento --</option>
                                <c:forEach var="m" items="${listaMedicamentos}">
                                    <option value="${m.idMedicamento}">${m.nombreComercial} (${m.concentracion})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Número de Lote:</label>
                            <input type="text" name="txtNumeroLote" class="form-control" placeholder="Ej: LT-2026-09A" required autocomplete="off">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Fecha de Vencimiento:</label>
                            <input type="date" name="txtFechaVencimiento" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Cantidad Recibida (Unidades):</label>
                            <input type="number" name="txtCantidad" min="1" class="form-control" placeholder="100" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Guardar Entrada</button>
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
            $('#tablaLotes').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                order: [[2, 'asc']], // Ordena por fecha de vencimiento por defecto
                pageLength: 10
            });
        });
    </script>
</body>
</html>
