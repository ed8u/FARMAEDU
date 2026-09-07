<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>
<%
    if (session.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    LocalDate fechaActual = LocalDate.now();
    DateTimeFormatter formato = DateTimeFormatter.ofPattern("d 'de' MMMM yyyy", new Locale("es", "ES"));
    String fechaFormateada = fechaActual.format(formato);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control - FARMAEDU ERP</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <div class="wrapper">

        <!-- INYECCIÓN DINÁMICA DEL SIDEBAR -->
        <jsp:include page="sidebar.jsp" />

        <main class="main-content">

            <!-- INYECCIÓN DINÁMICA DEL TOPBAR -->
            <jsp:include page="topbar.jsp" />

            <!-- ÁREA SCROLLABLE -->
            <div class="content-area">

                <div class="page-header">
                    <div class="page-title">
                        <span>Sede Operativa</span>
                        <h2>Panel de Control Farmacéutico</h2>
                        <p><i class="fa-solid fa-shield-check text-success"></i> Resumen operativo en tiempo real</p>
                    </div>
                    <div class="header-actions">
                        <div class="btn-action">
                            <i class="fa-regular fa-calendar"></i>
                            <div>
                                <div style="font-size: 0.6rem; color: var(--text-muted); line-height: 1;">JORNADA ACTIVA</div>
                                <div>Hoy, <%= fechaFormateada %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 1: KPIs -->
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Clientes Registrados <i class="fa-solid fa-users text-primary"></i></div>
                            <div>
                                <div class="metric-value">${kpiClientes != null ? kpiClientes : 0}</div>
                                <div class="metric-sub">Activos en cartera</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Medicamentos en Catálogo <i class="fa-solid fa-pills text-info"></i></div>
                            <div>
                                <div class="metric-value">${kpiMedicamentos != null ? kpiMedicamentos : 0}</div>
                                <div class="metric-sub">Productos listados</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header text-danger">Alertas Vencimiento FEFO <i class="fa-solid fa-triangle-exclamation text-danger"></i></div>
                            <div>
                                <div class="metric-value text-danger">${kpiLotesPorVencer != null ? kpiLotesPorVencer : 0} Lotes</div>
                                <div class="metric-sub">Vencen en menos de 60 días</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header text-warning">Stock Crítico <i class="fa-solid fa-box-open text-warning"></i></div>
                            <div>
                                <div class="metric-value text-warning">${kpiBajoStock != null ? kpiBajoStock : 0} Prod.</div>
                                <div class="metric-sub">Debajo del stock mínimo</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 2: Gráficos y Monitoreo -Mockups estatico -->
                <div class="row g-3 mb-4">
                    <div class="col-lg-8">
                        <div class="panel-card h-100 mb-0">
                            <div class="panel-title">Proyección de Ventas (Datos de Prueba)</div>
                            <div class="panel-subtitle">Este gráfico se conectará al implementar el módulo Facturación.</div>
                            <div style="position: relative; height: 250px; width: 100%;">
                                <canvas id="areaChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="panel-card h-100 mb-0">
                            <div class="panel-title">Monitoreo Crítico FEFO <span class="badge bg-danger">URGENTE</span></div>
                            <div class="panel-subtitle">Lotes de inventario próximos a vencer (Mockup).</div>

                            <div class="fefo-item">
                                <div class="fefo-head">
                                    <span>Paracetamol 500mg</span>
                                    <span class="fefo-badge"><i class="fa-regular fa-clock"></i> 14 Días</span>
                                </div>
                                <div class="fefo-details">Lote: LT-2024-001 • Stock Real: 100 unid.</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script src="${pageContext.request.contextPath}/js/dashboard.js"></script>
</body>
</html>
