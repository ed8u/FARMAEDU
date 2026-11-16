<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Dashboard - FARMAEDU</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <div class="wrapper">

        <jsp:include page="sidebar.jsp" />

        <main class="main-content">
            <jsp:include page="topbar.jsp" />

            <div class="content-area">

                <!-- Header de la vista -->
                <div class="page-header">
                    <div class="page-title">
                        <h2>Panel de Control</h2>
                        <div class="text-muted" style="font-size: 0.85rem; margin-top: 4px;">
                            <i class="fa-solid fa-chart-pie me-1 text-primary"></i> Resumen operativo en tiempo real
                        </div>
                    </div>

                    <div class="date-badge">
                        <i class="fa-regular fa-calendar"></i>
                        <div>
                            <div class="label">Jornada Activa</div>
                            <div class="value">Hoy, <%= fechaFormateada %></div>
                        </div>
                    </div>
                </div>

                <!-- ROW 1: Tarjetas KPI -->
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="icon-box icon-green"><i class="fa-solid fa-sack-dollar"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Ventas de Hoy (${kpiVentasHoy != null ? kpiVentasHoy : 0})</span>
                                <span class="metric-value">S/ ${String.format("%.2f", kpiIngresosHoy != null ? kpiIngresosHoy : 0.00)}</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="icon-box icon-blue"><i class="fa-solid fa-pills"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Catálogo (${kpiClientes != null ? kpiClientes : 0} Clientes)</span>
                                <span class="metric-value">${kpiMedicamentos != null ? kpiMedicamentos : 0} </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="icon-box icon-red"><i class="fa-solid fa-triangle-exclamation"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Alertas FEFO</span>
                                <span class="metric-value">${kpiLotesPorVencer != null ? kpiLotesPorVencer : 0}</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="icon-box icon-orange"><i class="fa-solid fa-box-open"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Stock Crítico</span>
                                <span class="metric-value">${kpiBajoStock != null ? kpiBajoStock : 0}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 2: Gráficos y Monitoreo FEFO -->
                <div class="row g-3 mb-4">
                    <!-- Gráfico -->
                    <div class="col-lg-8">
                        <div class="panel-card h-100">
                            <div class="panel-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h3 class="panel-title">Evolución de Ventas</h3>
                                    <p class="panel-subtitle">Ingresos de los últimos 7 días (S/)</p>
                                </div>
                                <a href="VentaServlet" class="btn btn-sm btn-success fw-bold" style="font-size: 0.78rem;">
                                    <i class="fa-solid fa-cash-register me-1"></i> Ir al POS
                                </a>
                            </div>
                            <div style="position: relative; flex-grow: 1; min-height: 250px;">
                                <canvas id="ventasChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Monitoreo FEFO Dinámico -->
                    <div class="col-lg-4">
                        <div class="panel-card h-100">
                            <div class="panel-header">
                                <div>
                                    <h3 class="panel-title">Lotes por Vencer</h3>
                                    <p class="panel-subtitle">Monitoreo crítico FEFO (Próximos 60 días)</p>
                                </div>
                            </div>

                            <div class="fefo-list">
                                <c:forEach var="lote" items="${listaLotesCriticos}">
                                    <c:choose>
                                        <c:when test="${lote.diasParaVencer <= 30}">
                                            <!-- Ítem Urgente (Rojo) -->
                                            <div class="fefo-item">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong style="color: var(--kpi-red-txt); font-size: 0.9rem;">${lote.nombreMedicamento}</strong>
                                                    <span class="fefo-badge text-danger">
                                                        <i class="fa-regular fa-clock"></i> 
                                                        ${lote.diasParaVencer < 0 ? 'Vencido' : lote.diasParaVencer.toString().concat(' Días')}
                                                    </span>
                                                </div>
                                                <div class="text-muted" style="font-size: 0.75rem;">Lote: ${lote.numeroLote} • Stock: ${lote.stockActual} unid.</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Ítem Advertencia (Naranja) -->
                                            <div class="fefo-item warning">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong style="color: var(--kpi-orange-txt); font-size: 0.9rem;">${lote.nombreMedicamento}</strong>
                                                    <span class="fefo-badge text-warning" style="color: var(--kpi-orange-txt) !important;">
                                                        <i class="fa-regular fa-clock"></i> ${lote.diasParaVencer} Días
                                                    </span>
                                                </div>
                                                <div class="text-muted" style="font-size: 0.75rem;">Lote: ${lote.numeroLote} • Stock: ${lote.stockActual} unid.</div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${empty listaLotesCriticos}">
                                    <div class="text-center text-muted py-4" style="font-size: 0.85rem;">
                                        <i class="fa-solid fa-shield-heart text-success mb-2" style="font-size: 1.8rem;"></i><br>
                                        No hay lotes próximos a vencer en los siguientes 60 días.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 3: Últimas Transacciones Registradas en el POS -->
                <div class="row g-3">
                    <div class="col-12">
                        <div class="panel-card">
                            <div class="panel-header d-flex justify-content-between align-items-center mb-3">
                                <div>
                                    <h3 class="panel-title">Últimas Ventas Registradas</h3>
                                    <p class="panel-subtitle mb-0">Despachos recientes procesados en caja</p>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="font-size: 0.85rem;">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Comprobante</th>
                                            <th>Fecha / Hora</th>
                                            <th>Cliente</th>
                                            <th>Cajero</th>
                                            <th>Método Pago</th>
                                            <th class="text-end">Total</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="v" items="${listaUltimasVentas}">
                                            <tr>
                                                <td>
                                                    <strong class="text-dark">${v.numeroComprobante}</strong>
                                                    <span class="badge bg-light text-dark border ms-1">${v.tipoComprobante}</span>
                                                </td>
                                                <td>${v.fechaVenta.toLocalDate()} <small class="text-muted">${v.fechaVenta.toLocalTime()}</small></td>
                                                <td>${v.nombreCliente} <small class="text-muted">(${v.documentoCliente})</small></td>
                                                <td>${v.nombreCajero}</td>
                                                <td><span class="badge bg-success-subtle text-success">${v.metodoPago}</span></td>
                                                <td class="text-end fw-bold text-success">S/ ${String.format("%.2f", v.total)}</td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty listaUltimasVentas}">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">
                                                    Aún no hay ventas registradas. Realice un cobro en el Punto de Venta (POS) para ver el movimiento aquí.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Inicialización del Gráfico con Datos Reales desde SQL Server -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const ctx = document.getElementById('ventasChart').getContext('2d');
            
            let gradient = ctx.createLinearGradient(0, 0, 0, 300);
            gradient.addColorStop(0, 'rgba(16, 185, 129, 0.2)');
            gradient.addColorStop(1, 'rgba(16, 185, 129, 0)');

            const labelsReales = ${chartLabels != null ? chartLabels : "['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']"};
            const datosReales = ${chartValores != null ? chartValores : "[0, 0, 0, 0, 0, 0, 0]"};

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labelsReales,
                    datasets: [{
                        label: 'Ventas (S/)',
                        data: datosReales,
                        borderColor: '#10b981',
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#10b981',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: '#0f172a',
                            padding: 12,
                            titleFont: { size: 13, family: 'Inter' },
                            bodyFont: { size: 14, weight: 'bold', family: 'Inter' },
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return 'S/ ' + context.parsed.y.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: '#f1f5f9', drawBorder: false },
                            ticks: { color: '#64748b', font: { family: 'Inter' } }
                        },
                        x: {
                            grid: { display: false, drawBorder: false },
                            ticks: { color: '#64748b', font: { family: 'Inter' } }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>