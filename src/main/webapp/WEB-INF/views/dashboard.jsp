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
                            <div class="icon-box icon-blue"><i class="fa-solid fa-users"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Clientes</span>
                                <span class="metric-value">${kpiClientes != null ? kpiClientes : 0}</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="icon-box icon-green"><i class="fa-solid fa-pills"></i></div>
                            <div class="metric-info">
                                <span class="metric-title">Catálogo</span>
                                <span class="metric-value">${kpiMedicamentos != null ? kpiMedicamentos : 0}</span>
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
                <div class="row g-3">
                    <!-- Gráfico -->
                    <div class="col-lg-8">
                        <div class="panel-card h-100">
                            <div class="panel-header">
                                <div>
                                    <h3 class="panel-title">Proyección de Ventas</h3>
                                    <p class="panel-subtitle">Ingresos de los últimos 7 días (Datos de prueba)</p>
                                </div>
                            </div>
                            <!-- Contenedor del gráfico -->
                            <div style="position: relative; flex-grow: 1; min-height: 250px;">
                                <canvas id="ventasChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Monitoreo FEFO -->
                    <div class="col-lg-4">
                        <div class="panel-card h-100">
                            <div class="panel-header">
                                <div>
                                    <h3 class="panel-title">Lotes por Vencer</h3>
                                    <p class="panel-subtitle">Monitoreo crítico FEFO</p>
                                </div>
                            </div>

                            <div class="fefo-list">
                                <!-- Ítem Urgente (Rojo) -->
                                <div class="fefo-item">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <strong style="color: var(--kpi-red-txt); font-size: 0.9rem;">Paracetamol 500mg</strong>
                                        <span class="fefo-badge text-danger"><i class="fa-regular fa-clock"></i> 14 Días</span>
                                    </div>
                                    <div class="text-muted" style="font-size: 0.75rem;">Lote: LT-2024-001 • Stock: 100 unid.</div>
                                </div>

                                <!-- Ítem Advertencia (Naranja) -->
                                <div class="fefo-item warning">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <strong style="color: var(--kpi-orange-txt); font-size: 0.9rem;">Amoxicilina 250mg</strong>
                                        <span class="fefo-badge text-warning" style="color: var(--kpi-orange-txt) !important;"><i class="fa-regular fa-clock"></i> 45 Días</span>
                                    </div>
                                    <div class="text-muted" style="font-size: 0.75rem;">Lote: AX-9923-B • Stock: 45 unid.</div>
                                </div>
                                
                                <!-- Ítem Advertencia (Naranja) -->
                                <div class="fefo-item warning">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <strong style="color: var(--kpi-orange-txt); font-size: 0.9rem;">Ibuprofeno 400mg</strong>
                                        <span class="fefo-badge text-warning" style="color: var(--kpi-orange-txt) !important;"><i class="fa-regular fa-clock"></i> 58 Días</span>
                                    </div>
                                    <div class="text-muted" style="font-size: 0.75rem;">Lote: IB-8841-C • Stock: 210 unid.</div>
                                </div>
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

    <!-- Inicialización del Gráfico Minimalista -->
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const ctx = document.getElementById('ventasChart').getContext('2d');
            
            // Gradiente para el gráfico
            let gradient = ctx.createLinearGradient(0, 0, 0, 300);
            gradient.addColorStop(0, 'rgba(16, 185, 129, 0.2)'); // Verde FARMAEDU suave
            gradient.addColorStop(1, 'rgba(16, 185, 129, 0)');

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                    datasets: [{
                        label: 'Ventas (S/)',
                        data: [1200, 1900, 1500, 2200, 1800, 2800, 2400],
                        borderColor: '#10b981', // Verde principal
                        backgroundColor: gradient,
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#10b981',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4 // Curvas suaves
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }, // Ocultamos leyenda para más minimalismo
                        tooltip: {
                            backgroundColor: '#0f172a',
                            padding: 12,
                            titleFont: { size: 13, family: 'Inter' },
                            bodyFont: { size: 14, weight: 'bold', family: 'Inter' },
                            displayColors: false,
                            callbacks: {
                                label: function(context) {
                                    return 'S/ ' + context.parsed.y;
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