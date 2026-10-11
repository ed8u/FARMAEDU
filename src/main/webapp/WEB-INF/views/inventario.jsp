<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%
    // Seguridad: Verificar sesión
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
        <title>Inventario - FARMAEDU</title>

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
                            <h2>Inventario y Lotes (FEFO)</h2>
                            <div class="text-muted" style="font-size: 0.85rem; margin-top: 4px;">Control de trazabilidad y vencimientos.</div>
                        </div>
                        <button class="btn-action-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoLote">
                            <i class="fa-solid fa-plus me-1"></i> Nuevo Lote
                        </button>
                    </div>

                    <!-- Tabla de Lotes -->
                    <div class="panel-card">
                        <table id="tablaLotes" class="table-pos">
                            <thead>
                                <tr>
                                    <th>Lote</th>
                                    <th>Medicamento</th>
                                    <th>Vencimiento</th>
                                    <th>Estado</th>
                                    <th>Stock</th>
                                    <th>Ingreso</th>
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
                                        <td><strong>${lote.numeroLote}</strong></td>
                                        <td>
                                            <div>
                                                <strong class="text-dark">${lote.nombreMedicamento}</strong>
                                                <div class="text-muted" style="font-size: 0.75rem;">Cód: ${lote.codigoBarras}</div>
                                            </div>
                                        </td>
                                        <td><strong>${lote.fechaVencimiento}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${diasRestantes <= 0}">
                                                    <span class="badge-status badge-vencido"><i class="fa-solid fa-ban"></i> Vencido</span>
                                                </c:when>
                                                <c:when test="${diasRestantes <= 60}">
                                                    <span class="badge-status badge-alerta"><i class="fa-solid fa-triangle-exclamation"></i> ${diasRestantes} días</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status badge-vigente"><i class="fa-solid fa-check"></i> ${diasRestantes} días</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${lote.stockActual <= 10}">
                                                    <span class="stock-badge-low">${lote.stockActual} unid.</span>
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
                    <div class="modal-header border-0">
                        <h5 class="modal-title fw-bold">Ingreso de Lote</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="InventarioServlet" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="accionForm" value="RegistrarLote">

                            <div class="mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Medicamento</label>
                                <select name="cboMedicamento" class="form-select" required>
                                    <option value="" disabled selected>Seleccione...</option>
                                    <c:forEach var="m" items="${listaMedicamentos}">
                                        <option value="${m.idMedicamento}">${m.nombreComercial} (${m.concentracion})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Número de Lote</label>
                                <input type="text" name="txtNumeroLote" class="form-control" placeholder="Ej: LT-2026-09A" required autocomplete="off">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Fecha de Vencimiento</label>
                                <input type="date" name="txtFechaVencimiento" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-muted" style="font-size: 0.8rem;">Cantidad Recibida</label>
                                <input type="number" name="txtCantidad" min="1" class="form-control" placeholder="Ej: 100" required>
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

        <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

        <script>
            $(document).ready(function () {
                $('#tablaLotes').DataTable({
                    language: {url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'},
                    dom: '<"d-flex justify-content-between align-items-center mb-4"f>rt<"d-flex justify-content-between mt-4"ip>',
                    order: [[2, 'asc']], // Ordena por fecha de vencimiento por defecto
                    pageLength: 10
                });
            });
        </script>


